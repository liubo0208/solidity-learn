// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract VotingSystem {
    struct Proposal {
        string description;
        uint voteCount;
        uint deadline;
        bool exists;
    }
    
    address public owner;
    uint public proposalCount;
    
    mapping(uint => Proposal) public proposals;
    mapping(uint => mapping(address => bool)) public hasVoted;

    event ProposalCreated(uint indexed proposalId,string description,uint deadline);
    event Voted(uint indexed proposalId,address indexed voter);
    
    constructor() {
        owner = msg.sender;
    }
    
    modifier onlyOwner() {
        require(owner == msg.sender,"Only owner can call");
        _;
    }
    // 实现创建提案
    function createProposal(string memory description, uint durationDays) 
        public onlyOwner
    {
        // 检查权限 onlyOwner
        // 验证参数
        require(bytes(description).length > 0 , "Empty description");
        require(durationDays > 0 &&  durationDays < 31, "Invalid duration" );
        // 创建提案
        uint proposalId = proposalCount ++;
        uint deadline = block.timestamp + (durationDays * 1 days);

        proposals[proposalId] = Proposal({
            description: description,
            voteCount: 0,
            deadline: deadline,
            exists: true
        });

        emit ProposalCreated(proposalId,description,deadline);
    }
    
    // 实现投票
    function vote(uint proposalId) public {
        // 检查提案存在
        // 检查是否已投票
        // 检查是否已截止
        require(proposals[proposalId].exists, "Proposal does not exist");
        require(block.timestamp <= proposals[proposalId].deadline, "Voting ended");
        require(!hasVoted[proposalId][msg.sender], "Already voted");
        // 执行投票
        hasVoted[proposalId][msg.sender] = true;
        proposals[proposalId].voteCount++;

        emit Voted(proposalId,msg.sender);
    }
    
    // 获取获胜提案
    function getWinner() public view returns (uint) {
        // 遍历所有提案
        // 找出票数最多的

        uint maxVotes = 0;
        
        for (uint i = 0; i < proposalCount; i++) {
            if (proposals[i].voteCount > maxVotes) {
                maxVotes = proposals[i].voteCount;
                winningProposalId = i;
            }
        }
        
        return winningProposalId;
    }

    function getProposalInfo(uint proposalId) 
        public view 
        returns (
            string memory description,
            uint voteCount,
            uint deadline,
            bool hasEnded
        ) 
    {
        require(proposals[proposalId].exists, "Proposal does not exist");
        
        Proposal memory p = proposals[proposalId];
        return (
            p.description,
            p.voteCount,
            p.deadline,
            block.timestamp > p.deadline
        );
    }
}