// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title GovernanceContract
 * @dev A smart contract for decentralized governance through voting and decision-making.
 */
contract Governance {
    // Define proposal status
    enum ProposalStatus { Pending, Approved, Rejected }

    // Define proposal structure to store proposal data
    struct Proposal {
        uint proposalId;
        address proposer;
        string description;
        uint forVotes;
        uint againstVotes;
        ProposalStatus status;
        uint votingEndTime;
    }

    // Array to store all proposals
    Proposal[] public proposals;

    // Mapping to track if a voter has voted on a proposal
    mapping(uint => mapping(address => bool)) public hasVoted;

    // Mapping to track voting power of token holders
    mapping(address => uint) public votingPower;

    // Events for logging proposal creation, votes, and status updates
    event ProposalCreated(uint indexed proposalId, address indexed proposer, string description, uint votingEndTime);
    event VoteCasted(uint indexed proposalId, address indexed voter, bool inSupport, uint forVotes, uint againstVotes);
    event ProposalStatusUpdated(uint indexed proposalId, ProposalStatus status);

    /**
     * @dev Create a new governance proposal.
     * @param _description The description of the proposal.
     * @param _votingEndTime The end time for voting on the proposal.
     */
    function createProposal(string memory _description, uint _votingEndTime) public {
        uint proposalId = proposals.length;
        Proposal memory newProposal = Proposal({
            proposalId: proposalId,
            proposer: msg.sender,
            description: _description,
            forVotes: 0,
            againstVotes: 0,
            status: ProposalStatus.Pending,
            votingEndTime: _votingEndTime
        });
        proposals.push(newProposal);

        emit ProposalCreated(proposalId, msg.sender, _description, _votingEndTime);
    }

    /**
     * @dev Cast a vote on a governance proposal.
     * @param _proposalId The ID of the proposal to vote on.
     * @param _inSupport Whether the vote is in support of the proposal (true) or against it (false).
     */
    function castVote(uint _proposalId, bool _inSupport) public {
        require(_proposalId < proposals.length, "Proposal not found");
        require(!hasVoted[_proposalId][msg.sender], "Already voted");

        Proposal storage proposal = proposals[_proposalId];
        require(proposal.status == ProposalStatus.Pending, "Proposal already decided");

        if (_inSupport) {
            proposal.forVotes += votingPower[msg.sender];
        } else {
            proposal.againstVotes += votingPower[msg.sender];
        }
        hasVoted[_proposalId][msg.sender] = true;

        emit VoteCasted(_proposalId, msg.sender, _inSupport, proposal.forVotes, proposal.againstVotes);

        checkProposalStatus(_proposalId);
    }

    /**
     * @dev Check and update the status of a proposal based on voting results.
     * @param _proposalId The ID of the proposal to check.
     */
    function checkProposalStatus(uint _proposalId) internal {
        Proposal storage proposal = proposals[_proposalId];
        if (block.timestamp >= proposal.votingEndTime) {
            if (proposal.forVotes > proposal.againstVotes) {
                proposal.status = ProposalStatus.Approved;
            } else {
                proposal.status = ProposalStatus.Rejected;
            }

            emit ProposalStatusUpdated(_proposalId, proposal.status);
        }
    }

    /**
     * @dev Get details of a proposal.
     * @param _proposalId The ID of the proposal to retrieve details for.
     * @return proposer The address of the proposer.
     * @return description The description of the proposal.
     * @return forVotes The total votes in favor of the proposal.
     * @return againstVotes The total votes against the proposal.
     * @return status The status of the proposal.
     * @return votingEndTime The end time for voting on the proposal.
     */
    function getProposalDetails(uint _proposalId) public view returns (
        address proposer,
        string memory description,
        uint forVotes,
        uint againstVotes,
        ProposalStatus status,
        uint votingEndTime
    ) {
        require(_proposalId < proposals.length, "Proposal not found");

        Proposal storage proposal = proposals[_proposalId];
        return (
            proposal.proposer,
            proposal.description,
            proposal.forVotes,
            proposal.againstVotes,
            proposal.status,
            proposal.votingEndTime
        );
    }

    /**
     * @dev Update the voting power of a token holder (admin function).
     * @param _tokenHolder The address of the token holder.
     * @param _votingPower The new voting power for the token holder.
     */
    function updateVotingPower(address _tokenHolder, uint _votingPower) public {
        // Implement access control to restrict this function to admins or governance members
        votingPower[_tokenHolder] = _votingPower;
    }
}
