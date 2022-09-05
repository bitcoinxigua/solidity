// SPDX-License-Identifier: MIT
pragma solidity ^0.8.6;

contract Vote {

    struct Candidate {
        string name;
        uint numberOfVotes;
    }

    Candidate[] public candidates;

    mapping (string => bool) public nameExists;

    address public owner;

    constructor() {
        owner = msg.sender;
    }

    mapping (address => bool) public isVoted;

    modifier onlyOwner {
        require(msg.sender == owner,"must be owner");
        _;
    }

    function addCandidate(string memory _name) public onlyOwner {
        require(!nameExists[_name],"name already exist");
        candidates.push(
            Candidate({
                name : _name,
                numberOfVotes : 0
            })
        );
        nameExists[_name] = true;
    }

    function vote(uint _candidateNum) public {
        require(!isVoted[msg.sender],"you already vote");
        candidates[_candidateNum].numberOfVotes += 1;
        isVoted[msg.sender] = true;
    }

    function end() public view onlyOwner returns(string memory) {
        uint res;
        string memory winner;
        for (uint i = 0; i<candidates.length;i++) {
            if (candidates[i].numberOfVotes > res) {
                res = candidates[i].numberOfVotes;
                winner = candidates[i].name;
            }
        }
        return winner;
    }

}