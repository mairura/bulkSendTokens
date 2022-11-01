// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IERC20  {
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
}

//Function sto consider - try to reduce on gas usage
//1. balanceOf sender before dispatch of tokens - make a require condition
//2. transfer of token from sc to addresses
//3. transferFrom owner account to sc some amount
//4. allowance by owner for sc to use some amount
//5. approve of sc to use some amount - off-chain to reduce gas usage ["0xbf311cAC37d459e3A111f42a61bB839d1466DB24","0x63AEebF5a1A95A896b24DC0805F06c5Faf23e81b"]

//Initialize contract for bulk sending tokens to addresses
contract Bulksend {
    //Public state variable
    address public owner;

    constructor() public  {
        owner = msg.sender;
    }

    //Mapping an address to its balance
    mapping(address => uint) balances;

    //Function to get address of owner
    function getOwner() public view returns (address) {
        return owner;
    }

    //find balance of owner
    function getBalance() public view returns (uint256) {
        return owner.balance;
    }

    //Function to transfer to many addresses
    function multiTransfer(IERC20 _token, address[] calldata _toAddresses, uint256[] calldata _amount) public payable {
        require(_toAddresses.length == _amount.length, "Length inconsistent");
        uint256 requiredAmount = _toAddresses.length * _amount.length;
        _token.approve(address(this), requiredAmount);

        for(uint i = 0; i < _toAddresses.length; i++) {
            _token.transferFrom(msg.sender, payable(_toAddresses[i]), _amount[i]);
        }
    }  
}