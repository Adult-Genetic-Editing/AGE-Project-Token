# AGE-Project-Token
ERC20-based crowsale token using pre-sale incentives, shareholders and refunds (if funding goal not met)
Refunds and Withdrawal of shareholder funds are controlled by the contract.

TO TEST with Ethereum Wallet:
1. Connect to, and fully synch the Ethereum Wallet with the TEST network (Ropsten or Rinkeby) 
2. Create 4 new accounts from the File Menu: "owner", "buyer", vault" and one or more "shareholders"
3. Give owner at least .5 test eth from a faucet (https://faucet.metamask.io/ works well if you have metamask)   
4. Give buyer at least 5 ether  
5. Click Contracts - Deploy New Contract 
6. Paste in the AGE_Token.sol file contents
7. Edit line 7 & 8 if you wish to name your Token
8. Edit Line #27
uint256 minFundingGoal = 10000000000000000000000;  change to 5000000000000000000; (10,000 eth to 5 eth)
7. Edit Line #29
address AGE_Vault = 0x29725Ac55276EdE262ed17F3e95483cAf7DBCc77;  <- overwite the address with your vault address from step #1
8. Edit Line #30
address AGE_EOS_Community = 0x5d9d570Ab2DfB72c9dCDCA6A5bf3E1dacDa433d9; <- overwrite the address with your shareholder
9. Edit Line #149
preSaleEndBlock = SafeMath.add(startBlock, 5 days); change '5 days' to '10 minutes'
and change Line #150        
endBlock = SafeMath.add(startBlock, 95 days); change '95 days to '20 minutes'                 
10. IMPORTANT: set from at the top to be owner 
11. Under select contact to deploy - select the Token (not SafeMath or tokenRecepient - they will 'ride along')
12. Add some gas if you're in a hurry, and click Deploy
13. Wait for confirmations
14. Click Contracts on top right, then your contract 
15. Select Set_Live from the dropdown, check the checkbox, and IMPORTANT: select Owner to execute from 
16. Wait for Confirmations - 

Your token is live. You can scroll down and check the running values like isLive, isFunded, your start and end time and so on. If you created more than one shareholder: you can list their addresses by changing the value in the Payees box (0,1,2,3..)

17. On the contract page - click copy address
18. From the Buyer - send 1 eth to the contract address
19. Wait for confirmations, and check to see the buyer got 1,250 tokens and the vault got its 20%
20. Wait for the pre-sale time to end and repeat step #19
21. This time the buyer only got 1,000 tokens, and the vault got 20%
22. Wait for the end of the sale (check endblock value on the token page)
23. Try and send a small amount of ether to the contract... it will fail we're done selling) and refunds enabled should now be Yes.
24. Go to the contact page, select refund from the drop-down, paste in the buyers address and execute from buyer
25. You'll note (after confirmation) the ether in the contract has dropped and the buyer got their ether back
26. Go back up to Step #16 and Set_Live to true again
27. Send the contract 6 ether from buyer
28. You will now see on the contract page isFunded is yes (since we set 5 ether as a minimum funding goal
29. Select Claim from the contract drop-down
30. Pick one of your shareholders and click execute
31. Note that the contracts ether was reduced and the shareholder got their share
32. If you try to have the same shareholder grab more ether - they wont be able to
33. If you have the buyer send more ether - the same shareholder can get claim their share of the new ether

NOTE: The amount of shares a shareholder owns is set at lines 219-228 in the contract. Since solidity doesn't do decimals, 10 shares = 1%. 805 shares = 80.5%. The contract allows you to add shareholders on the fly (while it's running) - and will adjust everyones shares accordingly (but not the shares that were already claimed).

Enjoy and Happy-Coding!
Feel free to comment or email me
Address is available at https://adultgeneticediting.com

