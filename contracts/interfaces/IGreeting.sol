//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.9;

import "./ICampaign.sol";

interface IGreeting {
    // The user can get a list of available campaigns.
    function getCampaignList() external view returns (address[] memory);

    // The user can get a list of available words for a campaign.
    function getGreetingWordList(
        address campaign
    ) external view returns (string[] memory);

    // The user can select the word for a campaign.
    function selectGreetingWord(
        address campaign,
        uint wordIndex
    ) external;

    // The user can get price in Wei per message for a campaign
    function getPricePerMessageInWei(
        address campaign
    ) external view returns (uint price);

    // The user can send the greeting message to a recipient(to).
    // Make sure that the sender can only one message to a recipient.
    function send(
        address campaign,
        address to,
        string memory messageURI
    ) external payable;

    // The user can get messages within a campaign
    function getMessagesOfCampaign(
        address campaign,
        address who,
        ICampaign.MessageType action
    ) external view returns (ICampaign.MessageResponseDto[] memory);

    // The user can register new campaign
    function registerCampaign(
        address campaign
    ) external;

}