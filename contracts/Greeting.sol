//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "./interfaces/IGreeting.sol";
import "./interfaces/ICampaign.sol";

contract TheGreeting is 
    IGreeting
{
    // List of Campaigns
    ICampaign[] campaigns;


    // The user can get a list of available campaigns.
    function getCampaignList() external view override returns (ICampaign[] memory) {
        return campaigns;
    }

    // The user can get a list of available words for a campaign.
    function getGreetingWordList(
        ICampaign campaign
    ) external view override returns (string[] memory) {
        return campaign.getGreetingWordList();
    }

    // The user can select the word for a campaign.
    function selectGreetingWord(
        ICampaign campaign,
        uint wordIndex
    ) external override {
        campaign.selectGreetingWord(msg.sender, wordIndex);
    }

    // The user can get a selected word
    function getSelectedGreetingWord(
        ICampaign campaign,
        address sender
    ) external view override returns (uint, string memory) {
        return campaign.getSelectedGreetingWord(sender);
    }
    
    // The user can get price in Wei per message for a campaign
    function getPricePerMessageInWei(
        ICampaign campaign
    ) external view override returns (uint price) {
        return campaign.getPricePerMessageInWei();
    }

    // The user can send the greeting message to a recipient(to).
    // Make sure that the sender can only one message to a recipient.
    function send(
        ICampaign campaign,
        address to,
        string memory messageURI
    ) external payable override {
        // TODO: Check whether the sender is the genuine human or not.

        // TODO: Update the payment based on the sender identity.

        // Send a Message via Campaign.
        campaign.send(msg.sender, to, messageURI);

        // TODO: Integrate PUSH Protocol to send notification to the recipient
    }

    // The user can get message IDs of Campaign
    function getMessageIdsOfCampaign(
        ICampaign campaign,
        address who,
        ICampaign.MessageType messageType
    ) external view override returns (uint[] memory) {
        return campaign.getMessageIds(who, messageType);
    }

    // The user can get message by ID
    function getMessageByIdOfCampaign(
        ICampaign campaign,
        uint id
    ) external view override returns (ICampaign.MessageResponseDto memory) {
        return campaign.getMessageById(id);
    }

    // The user can register new campaign
    function registerCampaign(
        ICampaign campaign_
    ) external override {
        require(
            ICampaign(campaign_).supportsInterface(type(ICampaign).interfaceId),
            "Err: The given address does not comply with ICampaign."
        );
        // TODO: to check not to register the same campaign.

        campaigns.push(ICampaign(campaign_));
    }
}