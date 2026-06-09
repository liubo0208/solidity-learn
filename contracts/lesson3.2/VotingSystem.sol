// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// @title VotingSystem 链上投票系统
/// @notice 实现提案创建、投票、查询结果的完整投票流程
contract VotingSystem {
    /// @notice 提案结构体，包含提案的全部信息
    struct Proposal {
        string description;              // 提案描述文本
        uint256 voteCount;               // 当前得票数
        uint256 deadline;                // 投票截止时间（Unix 时间戳）
        bool executed;                   // 提案是否已执行（预留字段，当前未使用）
        mapping(address => bool) voters; // 记录已投票的地址，用于防止重复投票
    }

    /// @notice 以提案 ID 为键，存储所有提案
    mapping(uint256 => Proposal) public proposals;

    /// @notice 提案计数器，同时也是下一个提案的自增 ID
    uint256 public proposalCount;

    // ========== 事件定义 ==========

    /// @notice 提案创建事件，前端可据此监听新提案
    event ProposalCreated(uint256 indexed proposalId, string description);

    /// @notice 投票事件，记录谁对哪个提案投了票
    event Voted(uint256 indexed proposalId, address indexed voter);

    // ========== 写入函数 ==========

    /// @notice 创建新提案
    /// @param description 提案描述，不能为空
    /// @param duration 投票持续时间（秒），必须大于 0
    /// @return proposalId 新创建的提案 ID
    function createProposal(
        string memory description,
        uint256 duration
    ) public returns (uint256) {
        // 校验：描述不能为空（string 没有 .length 属性，需先转为 bytes）
        require(bytes(description).length > 0, "Description required");
        // 校验：持续时间必须为正数
        require(duration > 0, "Duration must be positive");

        // 自增 ID 模式：先取当前值作为 ID，再自增
        uint256 proposalId = proposalCount++;

        // 获取 storage 引用并赋值各字段
        Proposal storage p = proposals[proposalId];
        p.description = description;
        p.voteCount = 0;
        // 截止时间 = 当前区块时间戳 + 持续时长
        p.deadline = block.timestamp + duration;
        p.executed = false;

        // 发出事件，通知链下监听方
        emit ProposalCreated(proposalId, description);

        return proposalId;
    }

    /// @notice 对指定提案投票
    /// @param proposalId 要投票的提案 ID
    function vote(uint256 proposalId) public {
        // 校验 1：提案必须存在
        require(proposalId < proposalCount, "Proposal does not exist");

        Proposal storage p = proposals[proposalId];

        // 校验 2：必须在投票期内（当前时间 < 截止时间）
        require(block.timestamp < p.deadline, "Voting has ended");
        // 校验 3：该地址尚未对此提案投过票（防止重复投票）
        require(!p.voters[msg.sender], "Already voted");

        // 记录投票：标记该地址已投票，票数 +1
        p.voters[msg.sender] = true;
        p.voteCount++;

        // 发出投票事件
        emit Voted(proposalId, msg.sender);
    }

    // ========== 只读查询函数 ==========

    /// @notice 查询某地址是否已对某提案投过票
    /// @param proposalId 提案 ID
    /// @param voter 要查询的投票者地址
    /// @return 是否已投票
    function hasVoted(
        uint256 proposalId,
        address voter
    ) public view returns (bool) {
        require(proposalId < proposalCount, "Proposal does not exist");
        return proposals[proposalId].voters[voter];
    }

    /// @notice 获取提案的详细信息
    /// @dev 由于 struct 中包含 mapping 无法直接返回整个 struct，因此拆开逐字段返回
    /// @param proposalId 提案 ID
    /// @return description 提案描述
    /// @return voteCount 当前得票数
    /// @return deadline 投票截止时间
    /// @return executed 是否已执行
    function getProposalInfo(uint256 proposalId) public view returns (
        string memory description,
        uint256 voteCount,
        uint256 deadline,
        bool executed
    ) {
        require(proposalId < proposalCount, "Proposal does not exist");

        Proposal storage p = proposals[proposalId];
        return (p.description, p.voteCount, p.deadline, p.executed);
    }

    /// @notice 获取得票最多的提案 ID
    /// @dev 遍历所有提案找最高票，提案数量大时 Gas 消耗较高
    /// @return winningProposalId 得票最多的提案 ID（若无提案则返回 0）
    function getWinningProposal() public view returns (uint256 winningProposalId) {
        uint256 maxVotes = 0;

        // 遍历所有已创建的提案
        for (uint256 i = 0; i < proposalCount; i++) {
            if (proposals[i].voteCount > maxVotes) {
                maxVotes = proposals[i].voteCount;
                winningProposalId = i; // 利用命名返回值直接赋值
            }
        }

        return winningProposalId;
    }
}
