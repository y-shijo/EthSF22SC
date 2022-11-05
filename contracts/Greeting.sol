//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "./interfaces/IGreeting.sol";

contract TheGreeting is 
    IGreeting
{
    // The user can get a list of available campaigns.
    function getCampaignList() external view override returns (address[] memory) {

    }

    // The user can get a list of available words for a campaign.
    function getGreetingWordList(
        address campaign
    ) external view override returns (string[] memory) {

    }

    // The user can select the word for a campaign.
    function selectGreetingWord(
        address campaign,
        uint wordIndex
    ) external override {

    }

    // The user can get price in Wei per message for a campaign
    function getPricePerMessageInWei(
        address campaign
    ) external view override returns (uint price) {

    }

    // The user can send the greeting message to a recipient(to).
    // Make sure that the sender can only one message to a recipient.
    function send(
        address campaign,
        address to,
        string memory messageURI
    ) external payable override {
        // TODO: Check whether the sender is the genuine human or not.

        // TODO: Update the payment based on the sender identity.

        // TODO: Integrate PUSH Protocol to send notification to the recipient
    }

    // The user can get message IDs of Campaign
    function getMessageIdsOfCampaign(
        address campaign,
        address who,
        ICampaign.MessageType action
    ) external view override returns (uint[] memory) {

    }

    // The user can get message by ID
    function getMessageByIdOfCampaign(
        address campaign,
        uint id
    ) external view override returns (ICampaign.MessageResponseDto memory) {

    }

    // The user can register new campaign
    function registerCampaign(
        address campaign
    ) external override {

    }

}