// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Lottery {

    address[] public players;
    uint private counter;
    // -------------- //
    address public immutable OWNER;

    constructor() {
        OWNER = msg.sender;
    }
    // -------------- //
    function enter() public payable {
        require(msg.value == 0.1 ether, "Invalid amount");
        
        players.push(msg.sender);
    }

    function getPlayers() public view returns(address[] memory) {
        return players;
    }

    function random() private view returns(uint) {
        return uint(keccak256(abi.encodePacked(block.timestamp, block.prevrandao, players, counter)));
    }

    function pickWinner() public onlyOwner returns(address) {
        address payable winner = payable(players[random() % players.length]);

        winner.transfer(address(this).balance);

        players = new address[](0);

        counter += 1;

        return winner;
    }

    // -------------- //
    modifier onlyOwner {
        require(OWNER == msg.sender, "Only Owner");
        _;
    }
    // -------------- //

}