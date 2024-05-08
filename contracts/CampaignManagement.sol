// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title CampaignManagement
 * @dev A smart contract for managing fundraising campaigns on a blockchain-based charity platform.
 */
contract CampaignManagement {
    // Define campaign status
    enum CampaignStatus { Active, Completed, Expired }

    // Define campaign structure to store campaign data
    struct Campaign {
        uint campaignId;
        address payable creator;
        string title;
        string description;
        uint fundingGoal;
        uint currentFunding;
        CampaignStatus status;
    }

    // Mapping to store donations for each campaign
    mapping(uint => mapping(address => uint)) public campaignDonations;

    // Array to store all campaigns
    Campaign[] public campaigns;

    // Events for logging campaign creation, donations, and status updates
    event CampaignCreated(uint indexed campaignId, address indexed creator, string title, uint fundingGoal);
    event DonationReceived(uint indexed campaignId, address indexed donor, uint amount);
    event CampaignStatusUpdated(uint indexed campaignId, CampaignStatus status);

    /**
     * @dev Create a new fundraising campaign.
     * @param _title The title of the campaign.
     * @param _description The description of the campaign.
     * @param _fundingGoal The funding goal of the campaign.
     */
    function createCampaign(string memory _title, string memory _description, uint _fundingGoal) public {
        uint campaignId = campaigns.length;
        Campaign memory newCampaign = Campaign({
            campaignId: campaignId,
            creator: payable(msg.sender),
            title: _title,
            description: _description,
            fundingGoal: _fundingGoal,
            currentFunding: 0,
            status: CampaignStatus.Active
        });
        campaigns.push(newCampaign);

        emit CampaignCreated(campaignId, msg.sender, _title, _fundingGoal);
    }

    /**
     * @dev Contribute to a fundraising campaign.
     * @param _campaignId The ID of the campaign to donate to.
     */
    function donate(uint _campaignId) public payable {
        require(_campaignId < campaigns.length, "Campaign not found");

        Campaign storage campaign = campaigns[_campaignId];
        require(campaign.status == CampaignStatus.Active, "Campaign not active");

        campaignDonations[_campaignId][msg.sender] += msg.value;
        campaign.currentFunding += msg.value;

        emit DonationReceived(_campaignId, msg.sender, msg.value);

        checkCampaignStatus(_campaignId);
    }

    /**
     * @dev Check and update the status of a campaign based on funding progress.
     * @param _campaignId The ID of the campaign to check.
     */
    function checkCampaignStatus(uint _campaignId) internal {
        Campaign storage campaign = campaigns[_campaignId];
        if (campaign.currentFunding >= campaign.fundingGoal) {
            campaign.status = CampaignStatus.Completed;
        } else if (block.timestamp >= 30 days) {
            campaign.status = CampaignStatus.Expired;
        }

        emit CampaignStatusUpdated(_campaignId, campaign.status);
    }

    /**
     * @dev Get details of a campaign.
     * @param _campaignId The ID of the campaign to retrieve details for.
     * @return title The title of the campaign.
     * @return description The description of the campaign.
     * @return fundingGoal The funding goal of the campaign.
     * @return currentFunding The current funding amount of the campaign.
     * @return status The status of the campaign.
     */
    function getCampaignDetails(uint _campaignId) public view returns (
        string memory title,
        string memory description,
        uint fundingGoal,
        uint currentFunding,
        CampaignStatus status
    ) {
        require(_campaignId < campaigns.length, "Campaign not found");

        Campaign storage campaign = campaigns[_campaignId];
        return (
            campaign.title,
            campaign.description,
            campaign.fundingGoal,
            campaign.currentFunding,
            campaign.status
        );
    }
}
