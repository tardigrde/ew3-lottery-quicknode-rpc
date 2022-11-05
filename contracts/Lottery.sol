// SPDX-License-Identifier: MIT

// based on: https://github.com/jspruance/block-explorer-tutorials/blob/main/smart-contracts/solidity/Lottery.sol

pragma solidity ^0.8.0;

/**
 * @dev Basic lottery contract. This contract can be used standalone. 
 * 
 * The lottery can be played repeatedly.
 */
contract Lottery {
    address public owner;
    address payable[] public players;
    uint public lotteryId;
    mapping (uint => address payable) public lotteryHistory;
    uint public cost = .0001 ether;

    constructor() {
        owner = msg.sender;
        lotteryId = 1;
    }

    /**
    * @dev returns winner address of the lottery by lottery ID.
    */
    function getWinnerByLotteryId(uint lottery) public view returns (address payable) {
        return lotteryHistory[lottery];
    }

    /**
    * @dev returns balance of the contract.
    */
    function getBalance() public view returns (uint) {
        return address(this).balance;
    }

    /**
    * @dev returns a list of the participants' addresses.
    */
    function getPlayers() public view returns (address payable[] memory) {
        return players;
    }

    /**
    * @dev users can participate in the lottery by calling this function.
    * The cost of the participations is the public cost attribute.
    */
    function enter() public payable {
        require(msg.value >= cost);

        // address of player entering lottery
        players.push(payable(msg.sender));
    }

    /**
    * @dev picks a winner for the current iteration, 
    * transfers the contract balance to the winner, 
    * and resets the lottery.
    */
    function pickWinner() public onlyOwner {
        uint index = getRandomNumber() % players.length;
        players[index].transfer(address(this).balance);

        lotteryHistory[lotteryId] = players[index];
        lotteryId++;
        

        // reset the state of the contract
        players = new address payable[](0);
    }

    /**
    * @dev returns a pseudo-random uint.
    */
    function getRandomNumber() public view returns (uint) {
        return uint(keccak256(abi.encodePacked(owner, block.timestamp)));
    }

    /**
    * @dev sets the cost of entering the lottery.
    */
    function setCost(uint _newCost) public onlyOwner {
        cost = _newCost;
    }

    /**
    * @dev methods with this modifier can only be called by the owner of the contract.
    */
    modifier onlyOwner() {
      require(msg.sender == owner);
      _;
    }
}