pragma solidity ^0.4.18;

interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }

contract AGEToken {
    
    string public name = "The AGE Project";
    string public symbol = "AGE";
    uint8 public decimals = 18;
    
    uint256 public totalSupply = 1;                                             
    uint256 initialSupply = 1;
    uint256 public tokenRate = 1000;                                                   
    uint256 public preSaleTokenRate = 1250;                                            
    uint256 public startBlock;
    uint256 public endBlock;
    uint256 public preSaleEndBlock;
    uint256 public total_tokens;                                                
    uint256 public ether_raised;                                                
    uint256 private fundingRaised;                                             
    
    bool isLocked;                                                                                                                      
    bool public isFunded;    
    bool public refundsEnabled;
    bool public isLive;

    uint256 public minFundingTokens;

    address AGE_Vault = 0x4A0D8d5718DECBF902668A992e71d50cc7A93399;             
    address AGE_EOS_Community = 0xbcd7B52C2230B69a8a3b7511B137c2964d6dF53B;     
    address AGE_Lab_Expand = 0x821253f450b8872cbB116AEa79BbAD412E618c35;        
    address AGE_Founder_G =  0x00E50b554cD34353e5BE59986D21a788d0963FDf;         
    address AGE_Founder_K = 0xDDd78b7316516A58F69A6dbD8C0Bf4CC6bBA1217;        
    address AGE_Founder_J = 0x46Ab483E3F1990B797606eB03d5eCcc285719923;                        
    address AGE_Founder_J2 = 0x33C5D24b3d0984BB2651FeF4E589D040803A889b;        
    address AGE_Founder_N1 = 0x7b1492D7DDAc90F3BE1CfC6083404B3580471b6b;        
    address AGE_Founder_R =  0x8513285149a44CD76A422CC31f56C88F7e32A337;         
    address AGE_Founder_N2 = 0x8E960657f47f474Fbd19Fb7Bb5a3c23FA43a8524;        
    address AGE_Founder_D =  0xa852Bd32c3590F9b1842deC36F84A6992af82DDC;
    address owner;

    // Variables used to manage extraction of Ether from Contract
    uint256 public totalShares = 0;                                             
    uint256 public totalReleased = 0;                                           
    address[] public payees;                                                    
    mapping(address => uint256) public shares;
    mapping(address => uint256) public released;
    mapping (address => uint256) public deposited;                              
    mapping (address => uint256) public balanceOf;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Burn(address indexed from, uint256 value);
    event RefundsEnabled();
    event Refunded(address indexed beneficiary, uint256 weiAmount);

    modifier onlyOwner {                                                        
        require(msg.sender == owner);
        _;
    }
    modifier onyFunded {                                                        
         require(isFunded);
         _;
    }
    modifier noReentrance() {                                                    
        require(!isLocked);
        isLocked = true;
        _;
        isLocked = false;
    }

//***************************************
// Constructorpragma solidity ^0.4.18;

interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }

contract AGEToken {
    
    string public name = "The AGE Project";
    string public symbol = "AGE";
    uint8 public decimals = 18;
    
    uint256 public totalSupply = 1;                                             
    uint256 initialSupply = 1;
    uint256 public tokenRate = 1000;                                                   
    uint256 public preSaleTokenRate = 1250;                                            
    uint256 public startBlock;
    uint256 public endBlock;
    uint256 public preSaleEndBlock;
    uint256 public total_tokens;                                                
    uint256 public ether_raised;                                                
    uint256 private fundingRaised;                                             
    
    bool isLocked;                                                                                                                      
    bool public isFunded;    
    bool public refundsEnabled;
    bool public isLive;

    uint256 public minFundingTokens;

    address AGE_Vault = 0x4A0D8d5718DECBF902668A992e71d50cc7A93399;             
    address AGE_EOS_Community = 0xbcd7B52C2230B69a8a3b7511B137c2964d6dF53B;     
    address AGE_Lab_Expand = 0x821253f450b8872cbB116AEa79BbAD412E618c35;        
    address AGE_Founder_G =  0x00E50b554cD34353e5BE59986D21a788d0963FDf;         
    address AGE_Founder_K = 0xDDd78b7316516A58F69A6dbD8C0Bf4CC6bBA1217;        
    address AGE_Founder_J = 0x46Ab483E3F1990B797606eB03d5eCcc285719923;                        
    address AGE_Founder_J2 = 0x33C5D24b3d0984BB2651FeF4E589D040803A889b;        
    address AGE_Founder_N1 = 0x7b1492D7DDAc90F3BE1CfC6083404B3580471b6b;        
    address AGE_Founder_R =  0x8513285149a44CD76A422CC31f56C88F7e32A337;         
    address AGE_Founder_N2 = 0x8E960657f47f474Fbd19Fb7Bb5a3c23FA43a8524;        
    address AGE_Founder_D =  0xa852Bd32c3590F9b1842deC36F84A6992af82DDC;
    address owner;

    // Variables used to manage extraction of Ether from Contract
    uint256 public totalShares = 0;                                             
    uint256 public totalReleased = 0;                                           
    address[] public payees;                                                    
    mapping(address => uint256) public shares;
    mapping(address => uint256) public released;
    mapping (address => uint256) public deposited;                              
    mapping (address => uint256) public balanceOf;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Burn(address indexed from, uint256 value);
    event RefundsEnabled();
    event Refunded(address indexed beneficiary, uint256 weiAmount);

    modifier onlyOwner {                                                        
        require(msg.sender == owner);
        _;
    }
    modifier onyFunded {                                                        
         require(isFunded);
         _;
    }
    modifier noReentrance() {                                                    
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
        totalSupply = initialSupply * 10 ** uint256(decimals);                  
        balanceOf[msg.sender] = totalSupply;                                    
        fundingRaised = 0;
        loadPayees();                                                            
        isFunded = false;
        refundsEnabled = false;
        isLive = false;
    }
    
//***************************************
// Payable Fallback Function
//***************************************
    
    function() public payable {
        require(msg.value > 0);

        if(!isLive){
            assert(endBlock < startBlock);                                          
        }
        else{
            //***********************
            // Manage Ether 
            //***********************
            if(!isFunded){
                deposit(msg.sender, msg.value);                                  
            }
            else {
                balanceOf[this] = SafeMath.add(balanceOf[this], msg.value);      
            }
            fundingRaised = SafeMath.add(fundingRaised, msg.value); 
            ether_raised = fundingRaised/(1 ether);            
            
            //***********************
            // Manage Token 
            //***********************
            uint256 nowRate;
            if (block.timestamp <= preSaleEndBlock){                            
                nowRate = preSaleTokenRate;                                     
            }
            else{
                nowRate = tokenRate; 
            }
            uint256 buyAmount = SafeMath.mul(msg.value, nowRate);               
            uint256 mintAmount = SafeMath.div(buyAmount, 5);                    
            mintToken(msg.sender, buyAmount);
            mintToken(AGE_Vault ,mintAmount);                                       

            //***********************
            // Manage Flags 
            //***********************
            if(total_tokens > minFundingTokens){                                 
                isFunded = true;
            }
            if (endBlock < now){                                                
                if(total_tokens < minFundingTokens){                             
                    enableRefunds();                                            
                }
                isLive = false;                				                    
            }
        }
    }

//*****************************************************
// Helper & Standard ERC20 Functions + Self-Distruct
//*****************************************************
    function Set_Live(bool amLive) public onlyOwner {
        isLive = amLive;
        refundsEnabled = false;  
        ether_raised = 0;                                                
        fundingRaised = 0;
        startBlock=now;                                                             
        preSaleEndBlock = SafeMath.add(startBlock, 5 days);                    
        endBlock = SafeMath.add(startBlock, 95 days);                         
    } 
    
    function Set_Min_Fund(uint256 Min_Tokens) public onlyOwner {                //Sets the Min number of Tokens for the sale - must be set before Set_Live
        require(!isLive);
        minFundingTokens = Min_Tokens;
    }
        
    function deposit(address investor, uint256 _amount) internal {              
        deposited[investor] = SafeMath.add(deposited[investor], _amount);
    }
    
    function mintToken(address _to, uint256 quantity) internal {                
        balanceOf[this] = SafeMath.add(balanceOf[this], quantity) ;                         
        totalSupply = SafeMath.add (totalSupply, quantity);
        total_tokens = totalSupply/(1 ether);                                   
         _transfer(this, _to, quantity);
    }

    function _transfer(address _from, address _to, uint _value) internal {      
        require(_to != 0x0);
        require(balanceOf[_from] >= _value);
        require(balanceOf[_to] + _value >= balanceOf[_to]);
        uint previousBalances = balanceOf[_from] + balanceOf[_to];
        balanceOf[_from] -= _value;
        balanceOf[_to] += _value;
        emit Transfer(_from, _to, _value);
        assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
    }
    
    function Set_PreRate(uint256 new_rate) public onlyOwner{                       
        preSaleTokenRate = new_rate;                                                   
    } 
    
    function Set_Rate(uint256 new_rate) public onlyOwner{                       
        tokenRate = new_rate;                                                   
    }                                                                           

    function SELF_DESTRUCT() external onlyOwner {                               
 	    selfdestruct(owner);
	}

//***************************************
// Refund Functions
//***************************************

    function enableRefunds() internal returns (bool success) {                                                          
        require(!isFunded); 
        refundsEnabled = true;
        emit RefundsEnabled();
        return true;
    }

    function refund(address buyer) public noReentrance {                        
        require (refundsEnabled);                                                   
        uint256 depositedValue = deposited[buyer];   
        require (depositedValue != 0);                                          
        deposited[buyer] = 0;                                                   
        buyer.transfer(depositedValue);                                          
        emit Refunded(buyer, depositedValue);                                   
    }                                                                           
    
//***************************************
// Distribution Functions
//***************************************

    function addPayee(address _payee, uint256 _shares) public onlyOwner {       
        require(_payee != address(0));
        require(_shares > 0);
        require(shares[_payee] == 0);                                           //<----- Never increase shares - give someone a second wallet to award more  
        payees.push(_payee);
        shares[_payee] = _shares;
        totalShares = SafeMath.add(totalShares, _shares);
    }

    function loadPayees() internal {                                             
                                        
        addPayee(AGE_EOS_Community, 805);                                       
        addPayee(AGE_Lab_Expand,    150);                                           
        addPayee(AGE_Founder_G,      10);                                       
        addPayee(AGE_Founder_K,       5);                                          
        addPayee(AGE_Founder_J,       5);
        addPayee(AGE_Founder_J2,      5);                                       
        addPayee(AGE_Founder_N1,      5);
        addPayee(AGE_Founder_R,       5);
        addPayee(AGE_Founder_D,       5);
        addPayee(AGE_Founder_N2,      5);
    }

    function claim() public noReentrance onyFunded {                            
        address payee = msg.sender;
        require(shares[payee] > 0);
        uint256 totalReceived = SafeMath.add(address(this).balance,totalReleased);
        uint256 payment =  SafeMath.mul(totalReceived, shares[payee]);
        payment = SafeMath.div(payment, totalShares);  
        payment = SafeMath.sub(payment, released[payee]);                       
        require(payment != 0);                                                  
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
//***************************************
  function AGEToken() public {                                                
        owner = msg.sender;
        totalSupply = initialSupply * 10 ** uint256(decimals);                  
        balanceOf[msg.sender] = totalSupply;                                    
        fundingRaised = 0;
        loadPayees();                                                            
        isFunded = false;
        refundsEnabled = false;
        isLive = false;
    }
    
//***************************************
// Payable Fallback Function
//***************************************
    
    function() public payable {
        require(msg.value > 0);

        if(!isLive){
            assert(endBlock < startBlock);                                          
        }
        else{
            //***********************
            // Manage Ether 
            //***********************
            if(!isFunded){
                deposit(msg.sender, msg.value);                                  
            }
            else {
                balanceOf[this] = SafeMath.add(balanceOf[this], msg.value);      
            }
            fundingRaised = SafeMath.add(fundingRaised, msg.value); 
            ether_raised = fundingRaised/(1 ether);            
            
            //***********************
            // Manage Token 
            //***********************
            uint256 nowRate;
            if (block.timestamp <= preSaleEndBlock){                            
                nowRate = preSaleTokenRate;                                     
            }
            else{
                nowRate = tokenRate; 
            }
            uint256 buyAmount = SafeMath.mul(msg.value, nowRate);               
            uint256 mintAmount = SafeMath.div(buyAmount, 5);                    
            mintToken(msg.sender, buyAmount);
            mintToken(AGE_Vault ,mintAmount);                                       

            //***********************
            // Manage Flags 
            //***********************
            if(total_tokens > minFundingTokens){                                 
                isFunded = true;
            }
            if (endBlock < now){                                                
                if(total_tokens < minFundingTokens){                             
                    enableRefunds();                                            
                }
                isLive = false;                				                    
            }
        }
    }

//*****************************************************
// Helper & Standard ERC20 Functions + Self-Distruct
//*****************************************************
    function Set_Live(bool amLive) public onlyOwner {
        isLive = amLive;
        refundsEnabled = false;                                                 
        startBlock=now;                                                             
        preSaleEndBlock = SafeMath.add(startBlock, 5 days);                    
        endBlock = SafeMath.add(startBlock, 95 days);                         
    } 
    
    function Set_Min_Fund(uint256 Min_Tokens) public onlyOwner {                //Sets the Min number of Tokens for the sale - must be set before Set_Live
        require(!isLive);
        minFundingTokens = Min_Tokens;
    }
        
    function deposit(address investor, uint256 _amount) internal {              
        deposited[investor] = SafeMath.add(deposited[investor], _amount);
    }
    
    function mintToken(address _to, uint256 quantity) internal {                
        balanceOf[this] = SafeMath.add(balanceOf[this], quantity) ;                         
        totalSupply = SafeMath.add (totalSupply, quantity);
        total_tokens = totalSupply/(1 ether);                                   
         _transfer(this, _to, quantity);
    }

    function _transfer(address _from, address _to, uint _value) internal {      
        require(_to != 0x0);
        require(balanceOf[_from] >= _value);
        require(balanceOf[_to] + _value >= balanceOf[_to]);
        uint previousBalances = balanceOf[_from] + balanceOf[_to];
        balanceOf[_from] -= _value;
        balanceOf[_to] += _value;
        emit Transfer(_from, _to, _value);
        assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
    }
    
    function Set_PreRate(uint256 new_rate) public onlyOwner{                       
        preSaleTokenRate = new_rate;                                                   
    } 
    
    function Set_Rate(uint256 new_rate) public onlyOwner{                       
        tokenRate = new_rate;                                                   
    }                                                                           

    function SELF_DESTRUCT() external onlyOwner {                               
 	    selfdestruct(owner);
	}

//***************************************
// Refund Functions
//***************************************

    function enableRefunds() internal returns (bool success) {                                                          
        require(!isFunded); 
        refundsEnabled = true;
        emit RefundsEnabled();
        return true;
    }

    function refund(address buyer) public noReentrance {                        
        require (refundsEnabled);                                                   
        uint256 depositedValue = deposited[buyer];   
        require (depositedValue != 0);                                          
        deposited[buyer] = 0;                                                   
        buyer.transfer(depositedValue);                                          
        emit Refunded(buyer, depositedValue);                                   
    }                                                                           
    
//***************************************
// Distribution Functions
//***************************************

    function addPayee(address _payee, uint256 _shares) public onlyOwner {       
        require(_payee != address(0));
        require(_shares > 0);
        require(shares[_payee] == 0);                                           //<----- Never increase shares - give someone a second wallet to award more  
        payees.push(_payee);
        shares[_payee] = _shares;
        totalShares = SafeMath.add(totalShares, _shares);
    }

    function loadPayees() internal {                                             
                                        
        addPayee(AGE_EOS_Community, 805);                                       
        addPayee(AGE_Lab_Expand,    150);                                           
        addPayee(AGE_Founder_G,      10);                                       
        addPayee(AGE_Founder_K,       5);                                          
        addPayee(AGE_Founder_J,       5);
        addPayee(AGE_Founder_J2,      5);                                       
        addPayee(AGE_Founder_N1,      5);
        addPayee(AGE_Founder_R,       5);
        addPayee(AGE_Founder_D,       5);
        addPayee(AGE_Founder_N2,      5);
    }

    function claim() public noReentrance onyFunded {                            
        address payee = msg.sender;
        require(shares[payee] > 0);
        uint256 totalReceived = SafeMath.add(address(this).balance,totalReleased);
        uint256 payment =  SafeMath.mul(totalReceived, shares[payee]);
        payment = SafeMath.div(payment, totalShares);  
        payment = SafeMath.sub(payment, released[payee]);                       
        require(payment != 0);                                                  
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
