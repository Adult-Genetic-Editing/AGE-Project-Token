pragma solidity ^0.4.16;

interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }

contract AGEToken {
    
    string public name = "The AGE Project";
    string public symbol = "AGE";
    uint8 public decimals = 18;
    
    uint256 public totalSupply = 1;                                             // first token minted goes to owner
    uint256 initialSupply = 1;
    uint256 tokenRate = 1000;                                                   // 1,000 tokens per Eth
    uint256 preSaleTokenRate = 1250;                                            // pre-sale buyers get 25% more
    uint256 public startBlock;
    uint256 public endBlock;
    uint256 public preSaleEndBlock;
    uint256 public total_tokens;                                                // total of all tokens minted
    uint256 public ether_raised;                                                // funding collected in Eth
    uint256 private fundingRaised;                                              // funding collected in Wei
    
    bool isLocked;                                                              // used to block re-entrance                                                         
    bool public isFunded;    
    bool public refundsEnabled;
    bool public isLive;

    uint256 minFundingGoal = 10000000000000000000000;                           //**************** (10,000 Ether)
    
    address AGE_Vault = 0x29725Ac55276EdE262ed17F3e95483cAf7DBCc77;             //**************** ADDRESSES IS FROM TEST NETWORK - Multi-Sig
    address AGE_EOS_Community = 0x5d9d570Ab2DfB72c9dCDCA6A5bf3E1dacDa433d9;     //**************** ADDRESSES IS FROM TEST NETWORK - Multi-Sig
    address AGE_Lab_Expand = 0x1AF80dF4c48F6a96A5915FA4a904d7ca01ad1dFb;        //**************** ADDRESSES IS FROM TEST NETWORK - Multi-Sig
    address AGE_Founder_G = 0xD7Ae5aA2D4C9f69AF5401105Fd129C9B7248a1e8;         //**************** ADDRESSES IS FROM TEST NETWORK
    address AGE_Founder_K = 0x25a5b890826227c184812757c2CB672333FAEf05;         //**************** ADDRESSES IS FROM TEST NETWORK
    address AGE_Founder_J = 0xAcBA9654a06a70726AD244FEd31210cD0fcacAcE;         //**************** ADDRESSES IS FROM TEST NETWORK               
    address AGE_Founder_J2 = 0x83BFAbbD53D1DcdfaB3D5a441A3BFBEB2Cf91aae;        //**************** ADDRESSES IS FROM TEST NETWORK
    address AGE_Founder_N1 = 0x57A5Dbce0dE639e29a07e38ba6272f8bd02e8014;        //**************** ADDRESSES IS FROM TEST NETWORK
    address AGE_Founder_R = 0x7C0C3AAeA77bF802667FAE36569d566606558069;         //**************** ADDRESSES IS FROM TEST NETWORK
    address AGE_Founder_D = 0x509eeFF3f39A264c787C7623ae619f4c86a142bA;         //**************** ADDRESSES IS FROM TEST NETWORK
    address AGE_Founder_N2 = 0x692e37d3e9D460Af50D57ED432699dc663D81f37;        //**************** ADDRESSES IS FROM TEST NETWORK
    address owner;

    // Variables used to manage extraction of Ether from Contract
    uint256 public totalShares = 0;                                             // shares are used to split sale proceeds between the accounts above
    uint256 public totalReleased = 0;                                           // released shares have been moved from contract -> wallet
    address[] public payees;                                                    // payees are wallets with shares
    mapping(address => uint256) public shares;
    mapping(address => uint256) public released;

    mapping (address => uint256) public deposited;                              // deposits track buyer purchases until we are funded - used to allow refunds

    mapping (address => uint256) public balanceOf;
    mapping (address => mapping (address => uint256)) public allowance;         // legacy code - unused

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Burn(address indexed from, uint256 value);
    event RefundsEnabled();
    event Refunded(address indexed beneficiary, uint256 weiAmount);

    modifier onlyOwner {                                                        // only allows owner to execute functions modified by it
        require(msg.sender == owner);
        _;
    }
    modifier onyFunded {                                                        // only allows execution of function if we are funded
         require(isFunded);
         _;
    }
    modifier noReentrance() {                                                   // prevents exploitation of refunds(buyers) and claims(shareholders) 
        require(!isLocked);
        isLocked = true;
        _;
        isLocked = false;
    }

//***************************************
// Constructor
//***************************************
    function AGEToken() public {
        owner = msg.sender;
        totalSupply = initialSupply * 10 ** uint256(decimals);                  // update total supply with the decimal amount
        balanceOf[msg.sender] = totalSupply;                                    // give the creator all initial tokens (in this case: 1 Token)
        fundingRaised = 0;
        loadPayees();                                                           // loads existing shareholders and their #of shares 
        isFunded = false;
        refundsEnabled = false;
        isLive = false;
    }
    
//***************************************
// Payable Fallback Function
//***************************************
    
    function() public payable {
        require(msg.value > 0);

        if(isLive){
            //***********************
            // Manage Ether 
            //***********************
            if(!isFunded){
                deposit(msg.sender, msg.value);                                 //if we're not yet funded - track purchases for refunding if we fail to raise minimum 
            }
            else {
                balanceOf[this] = SafeMath.add(balanceOf[this], msg.value);     //if we're funded, don't spend gas tracking 
            }
            fundingRaised = SafeMath.add(fundingRaised, msg.value); 
            ether_raised = fundingRaised/(1 ether);            
            
            //***********************
            // Manage Token 
            //***********************
            uint256 nowRate;
            if (block.timestamp <= preSaleEndBlock){                            // risk of using now() ack'd
                nowRate = preSaleTokenRate;                                     // pre-sale buyers get extra tokens (set above)
            }
            else{
                nowRate = tokenRate; 
            }
            uint256 buyAmount = SafeMath.mul(msg.value, nowRate);               // creates and delivers tokens to buyers
            uint256 mintAmount = SafeMath.div(buyAmount, 5);                    // creates 20% additional tokens for The Volatility Fund (stored in Vault Contract)
            mintToken(msg.sender, buyAmount);
            mintToken(AGE_Vault ,mintAmount);                                       

            //***********************
            // Manage Flags 
            //***********************
            if(fundingRaised > minFundingGoal){                                 // check if this purchase got us funded
                isFunded = true;
            }

            if (endBlock < now){                                                // sale is over - risk of using now() ack'd
                if(fundingRaised < minFundingGoal){                             // if we're not funded - turn on refunds
                    enableRefunds();                                            
                }
                isLive = false;                				                    // sale is really over
            }
        }
        else{
            assert(endBlock < startBlock);                                      // we are NOT live: fail and revert the transaction    
        }
    }

//*****************************************************
// Helper & Standard ERC20 Functions + Self-Distruct
//*****************************************************
    function Set_Live(bool amLive) public onlyOwner {
        isLive = amLive;
        refundsEnabled = false;                                                 
        startBlock=now;                                                         //// risk of using now() ack'd    
        preSaleEndBlock = SafeMath.add(startBlock, 5 days);                     // << ---- Insure This is correctly Set
        endBlock = SafeMath.add(startBlock, 95 days);                           // << ---- Insure This is correctly Set
    } 
        
    function deposit(address investor, uint256 _amount) internal {              // store buyers purchases in an array till we are funded
        deposited[investor] = SafeMath.add(deposited[investor], _amount);
    }
    
    function mintToken(address _to, uint256 quantity) internal {                //mint (create) the token & add it to the balance
        balanceOf[this] = SafeMath.add(balanceOf[this], quantity) ;                         
        totalSupply = SafeMath.add (totalSupply, quantity);
        total_tokens = totalSupply/(1 ether);                                   // display tokens without the decimals (helpful in most ETH wallets)
         _transfer(this, _to, quantity);
    }

    function _transfer(address _from, address _to, uint _value) internal {      // send the token to the buyer from this contract
        require(_to != 0x0);
        require(balanceOf[_from] >= _value);
        require(balanceOf[_to] + _value >= balanceOf[_to]);
        uint previousBalances = balanceOf[_from] + balanceOf[_to];
        balanceOf[_from] -= _value;
        balanceOf[_to] += _value;
        emit Transfer(_from, _to, _value);
        assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
    }
    
    function Set_Rate(uint256 new_rate) public onlyOwner{                       // since funding goal is in ETH, and the price of ETH can fluctuate ...
        tokenRate = new_rate;                                                   // this function lets us react to the market and participate in a truly free market...
    }                                                                           // where we can sell tokens for what they will price at each day (second?)

    function SELF_DESTRUCT() external onlyOwner {                               // clean up and delete the contract
 	    selfdestruct(owner);
	}

//***************************************
// Refund Functions
//***************************************

    function enableRefunds() internal returns (bool success) {                  // triggered by the contract when endBlock has passed, and funding min not met                                        
        require(!isFunded); 
        refundsEnabled = true;
        emit RefundsEnabled();
        return true;
    }

    function refund(address buyer) public noReentrance {                        // buyer call to get back their ETH if we didnt fund...
        require (refundsEnabled);                                               // compiler is warning of re-entrancy for this function: ack'd, however...    
        uint256 depositedValue = deposited[buyer];   
        require (depositedValue != 0);                                          // 1. insure buyer has funds deposited
        deposited[buyer] = 0;                                                   // 2. zero their depost
        buyer.transfer(depositedValue);                                         // 3. transfer their depost 
        emit Refunded(buyer, depositedValue);                                   // -- the above should prevent re-entrance
    }                                                                           // -- additionaly function is modified to prevent re-entrance
    

//***************************************
// Distribution Functions
//***************************************

    function addPayee(address _payee, uint256 _shares) public onlyOwner {       // here to give us the ability to add a 'founder/shareholder' mid-sale
        require(_payee != address(0));
        require(_shares > 0);
        require(shares[_payee] == 0);                                           //<----- Never increase shares - give someone a second wallet to award more  
        payees.push(_payee);
        shares[_payee] = _shares;
        totalShares = SafeMath.add(totalShares, _shares);
    }

    function loadPayees() internal {                                            // original founders + storage/conversion wallets of people & things who get shares 
                                        
        addPayee(AGE_EOS_Community, 805);                                       // EOS Stake & materials & labor to deliver services - controlled by Token Redeemers on EOS - MANUAL MOVE :(
        addPayee(AGE_Lab_Expand,    150);                                       // used to build out facilities to deliver services    
        addPayee(AGE_Founder_G,      10);                                       // founder / CEO share = 1%
        addPayee(AGE_Founder_K,       5);                                       // other founders listed = 0.5%    
        addPayee(AGE_Founder_J,       5);
        addPayee(AGE_Founder_J2,      5);                                       
        addPayee(AGE_Founder_N1,      5);
        addPayee(AGE_Founder_R,       5);
        addPayee(AGE_Founder_D,       5);
        addPayee(AGE_Founder_N2,      5);
    }

    function claim() public noReentrance onyFunded {                            // used by wallets that have shares to claim them (allowed by contract only when funded)
        address payee = msg.sender;
        require(shares[payee] > 0);
        uint256 totalReceived = SafeMath.add(address(this).balance,totalReleased);
        uint256 payment =  SafeMath.mul(totalReceived, shares[payee]);
        payment = SafeMath.div(payment, totalShares);  
        payment = SafeMath.sub(payment, released[payee]);                       // claimers can call this multiple times - we track this and insure they only..
        require(payment != 0);                                                  // get what they haven't withdrawn
        require(address(this).balance >= payment);
        released[payee] = SafeMath.add(released[payee], payment);
        totalReleased = SafeMath.add(totalReleased, payment);
        payee.transfer(payment);
    }

//********************************************************
// OLD Distribution Functions - Some Exploitable - Unused
//********************************************************
    
//    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
//        require(_value <= allowance[_from][msg.sender]);     // Check allowance
//        allowance[_from][msg.sender] -= _value;
//        _transfer(_from, _to, _value);
//        return true;
//    }
    
//    function approve(address _spender, uint256 _value) public
//        returns (bool success) {
//        allowance[msg.sender][_spender] = _value;
//        return true;
//    }

//    function approveAndCall(address _spender, uint256 _value, bytes _extraData)
//        public
//        returns (bool success) {
//        tokenRecipient spender = tokenRecipient(_spender);
//        if (approve(_spender, _value)) {
//            spender.receiveApproval(msg.sender, _value, this, _extraData);
//            return true;
//        }
//    }

//    function burn(uint256 _value) public returns (bool success) {
//        require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
//        balanceOf[msg.sender] -= _value;            // Subtract from the sender
//        totalSupply -= _value;                      // Updates totalSupply
//        emit Burn(msg.sender, _value);
//        return true;
//    }

//    function burnFrom(address _from, uint256 _value) public returns (bool success) {
//        require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
//        require(_value <= allowance[_from][msg.sender]);    // Check allowance
//        balanceOf[_from] -= _value;                         // Subtract from the targeted balance
//        allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
//        totalSupply -= _value;                              // Update totalSupply
//        emit Burn(_from, _value);
//        return true;
//    }

    
}

//***************************************
// Standard SafeMath
//***************************************

library SafeMath {
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
    if (a == 0) {
      return 0;
    }
    uint256 c = a * b;
    assert(c / a == b);
    return c;
  }
  function div(uint256 a, uint256 b) internal pure returns (uint256) {
    // assert(b > 0); // Solidity automatically throws when dividing by 0
    uint256 c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn't hold
    return c;
  }
  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    assert(b <= a);
    return a - b;
  }
  function add(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a + b;
    assert(c >= a);
    return c;
  }
}    
