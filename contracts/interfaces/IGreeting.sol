//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "./ICampaign.sol";

interface IGreeting {
    // The user can get a list of available campaigns.
    function getCampaignList() external view returns (ICampaign[] memory);

    // The user can get a list of <CampaignAddress, CampaignName> for available campaigns.
    function getCampaignListAndName() external view returns (ICampaign[] memory, string[] memory);

    // The user can get a list of available words for a campaign.
    function getGreetingWordList(
        ICampaign campaign
    ) external view returns (string[] memory);

    // The user can select the word for a campaign.
    function selectGreetingWord(
        ICampaign campaign,
        uint wordIndex
    ) external;

    // The user can get a selected word
    function getSelectedGreetingWord(
        ICampaign campaign,
        address sender
    ) external view returns (uint, string memory);


    // The user can get price in Wei per message for a campaign
    function getPricePerMessageInWei(
        ICampaign campaign
    ) external view returns (uint price);

    // The user can send the greeting message to a recipient(to).
    // Make sure that the sender can only one message to a recipient.
    function send(
        ICampaign campaign,
        address to,
        string memory messageURI
    ) external payable;

    // The user can get message IDs of Campaign
    function getMessageIdsOfCampaign(
        ICampaign campaign,
        address who,
        ICampaign.MessageType action
    ) external view returns (uint[] memory);

    // The user can get message by ID
    function getMessageByIdOfCampaign(
        ICampaign campaign,
        uint id
    ) external view returns (ICampaign.MessageResponseDto memory);

    // The user can register new campaign
    function registerCampaign(
        ICampaign campaign
    ) external;

    // The users can verfy their humanity.
    function verifyHumanity() external;

    // The users can get their humanity is verified or not.
    function isHumanityVerified(
        address address_
    ) external view returns (bool);
}