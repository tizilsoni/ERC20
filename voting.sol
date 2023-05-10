// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Voting {
    address public owner;
    uint256 public totalVotes = 0;
    uint public voteTime;
    uint private totaltime;
    string public votefor;
    uint private against;
    uint private favour;

    enum Status{
        draw,
        passed,
        failed
    }

    Status private status;
    mapping(address => bool) private voteCaster;

    constructor(uint time , string memory _votefor) {
        voteTime = time;
        owner = msg.sender;
        totaltime = block.timestamp + voteTime;
        votefor = _votefor;
    }

    modifier onlyOwner() {
        require(msg.sender == owner , "only owner can call this function");
        _;
    }


    function Infavour() public returns(bool){
        require(voteCaster[msg.sender] != true, "Voter already voted");
        require(block.timestamp < totaltime , "voting time is over");
        voteCaster[msg.sender] = true;
        totalVotes +=1;
        favour += 1;
        return true;
    }

     function Against() public returns(bool){
        require(voteCaster[msg.sender] != true, "Voter already voted");
        require(block.timestamp < totaltime , "voting time is over");
        voteCaster[msg.sender] = true;
        totalVotes +=1;
        against += 1;
        return true;
    }


    function getResult() public onlyOwner{
        require(block.timestamp > totaltime , "Voting is still ONN.");
        if(against > favour){
            status = Status.failed;
        }
        else if(favour > against){
            status = Status.passed;
        }
        else{
            status = Status.draw;
        }

    }
        
    function castResult() public view onlyOwner returns(string memory, uint256, Status , uint , uint){
        require(block.timestamp > totaltime , "Voting is still ONN.");
        
        return (votefor , totalVotes , status , against , favour);

    }
}
