// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Voting {
    struct Candidates {
        string name;
        uint256 votes;
    }
    mapping(address => bool) private hasVoted;
    address private owner;
    Candidates[] public candidates;

    modifier onlyOwner() {
        _;
        require(msg.sender == owner, "Only owner can call this function");
    }

    modifier hasNotVoted(uint256 candidateId) {
        _;
        require(!hasVoted[msg.sender], "You have already voted");
        require(candidateId < candidates.length, "Invalid candidate");
    }

    constructor() {
        owner = msg.sender;
    }

    function addCandidates(string[] memory names) public onlyOwner() {
        for (uint256 i = 0; i < names.length; i++) {
            candidates.push(Candidates(names[i], 0));
        }
    }

    function vote(uint256 candidateId) public  hasNotVoted(candidateId) {

        hasVoted[msg.sender] = true;
        candidates[candidateId].votes++;
    }

    function getVotes(uint256 candidateId) public view returns (uint256) {
        require(candidateId < candidates.length, "Invalid candidate");
        return candidates[candidateId].votes;
    }
}