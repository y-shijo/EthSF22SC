//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "./interfaces/IGreeting.sol";
import "./interfaces/ICampaign.sol";
import "./interfaces/IPUSHCommInterface.sol";

contract TheGreeting is 
    IGreeting
{
    // List of Campaigns
    ICampaign[] campaigns;
    mapping(ICampaign => bool) isCampaignRegistered;

    // To check whether the address is verified as `having humanity`
    mapping(address => bool) verifiedHumanity;

    // For PUSH Protocol Integration
    address public pushCommContractAddress  = 0xb3971BCef2D791bc4027BbfedFb47319A4AAaaAa;
    address public theGreetingChannelOnPush = address(0);

    // The user can get a list of available campaigns.
    function getCampaignList() external view override returns (ICampaign[] memory) {
        return campaigns;
    }

    // The user can get a list of <CampaignAddress, CampaignName> for available campaigns.
    function getCampaignListAndName() external view override returns (ICampaign[] memory, string[] memory) {
        uint numCampaigns = campaigns.length;
        ICampaign[] memory _campaigns = new ICampaign[](numCampaigns);
        string[] memory _name = new string[](numCampaigns);

        for (uint i = 0; i < numCampaigns; i++) {
            _campaigns[i] = campaigns[i];
            _name[i] = campaigns[i].name();
        }

        return (_campaigns, _name);
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
        // Determine the price for sending message.
        // If the humanity is verified, the user can send a message for free.
        uint pricePerMessage  = campaign.getPricePerMessageInWei();
        if(verifiedHumanity[msg.sender]) {
            pricePerMessage = 0;
        }

        // Check whether sufficient value is sent to the contract.
        // Return the change to sender if any.
        require(msg.value >= pricePerMessage, "Err: Insufficient msg.value to send message.");
        uint change = msg.value - pricePerMessage;
        payable(msg.sender).transfer(change);

        // Send a Message via Campaign.
        campaign.send(msg.sender, to, messageURI);

        // Send Notification Via PushProtocol.
        _sendNotificationViaPush(to,
                                campaign.name(), 
                                "New greeting coming!"
                                );
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

        require(!isCampaignRegistered[campaign_], "Err: The given campaign is alreaady registered.");
        isCampaignRegistered[campaign_] = true;

        campaigns.push(ICampaign(campaign_));
    }

    // The users can verify their humanity.
    // TODO: [Future Work] This function must implement some authentication logic to restrict who can call this function. Hopefully, WorldID verification contract will be deployed to Ethereum, then we can verify onchain.
    function verifyHumanity() external override {
        verifiedHumanity[msg.sender] = true;
    }

    // The users can get their humanity is verified or not.
    function isHumanityVerified(
        address address_
    ) external view override returns (bool) {
        return verifiedHumanity[address_];
    }


    // ------- PUSH Utilities ------- 
    // Set PUSH Comm Contract Address
    function setPushCommContractAddr(address addr_) external {
        pushCommContractAddress = addr_;
    }

    // Set Channel Address On PUSH Protocol
    function setChannelAddrOnPush(address addr_) external {
        theGreetingChannelOnPush = addr_;
    }

    // Send Notification message via Push Protocol
    function _sendNotificationViaPush(
        address recipient,
        string memory title,
        string memory body) internal
    {
        IPUSHCommInterface(pushCommContractAddress).sendNotification(
            theGreetingChannelOnPush, // PUSH Channel Address
            recipient,              // Recipient Address 
            bytes(                    // Identity (Notification Body)
                string(
                    abi.encodePacked(
                        "0", // From Smart contract
                        "+", // segregator
                        "3", // Targetted Message
                        "+", // segregator
                        title, // Notificaiton title
                        "+", // segregator
                        body // notification body
                    )
                )
            )
        );
    }

}