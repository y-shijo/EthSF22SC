//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/interfaces/IERC165.sol";

interface ICampaign is
    IERC165
{
    // Message Status
    //  - WAITING_FOR_REPLY: Sender sent a message, but a recipient does not reply.
    //  - REPLIED: Sender and Recipient sent a message each other.
    enum MessageStatus {
        WAITING_FOR_REPLY,
        REPLIED
    }
    
    // Message Type
    //  - INCOMING: Message was sent TO the address (The address was recipient)
    //  - SENT: Message was sent FROM the address (The address was sender)
    enum MessageType {
        INCOMING,
        SENT
    }

    // Struct of Message
    // struct Message {
    //     address sender;
    //     address recipient;
    //     uint greetingWordIndex;
    //     string bodyURI;
    // }

    // Data Transfer Object for Querying message
    struct MessageResponseDto {
        uint id;
        address sender;
        address recipient;
        string greetingWord;
        string bodyURI;
        MessageStatus status;
        bool isResonanced;
    }

    function name() external view returns (string memory);

    /**
     * @dev Get List of Greeting Words
     */
    function getGreetingWordList() external view returns (string[] memory);

    /**
     * @dev Select the greeting Word for a caller.
     */
    function selectGreetingWord(address sender, uint wordIndex) external;
    
    /**
     * @dev Get List of Greeting Words for a certain sender.
     */
    function getSelectedGreetingWord(address sender) external view returns (uint, string memory);

    /**
     * @dev Get a price to send a message in Wei
     */
    function getPricePerMessageInWei() external view returns (uint price);

    /**
     * @dev Get a price to send a message in Wei
     */
    // TODO: This function should be able to be called by only GreetingContract. (As of now, anyone can call the function directly, then bypass the payment.)
    function send(
        address from,
        address to,
        string memory messageURI
    ) external;

    /**
     * @dev Get message IDs for given address and messageType
     */
    function getMessageIds(
        address who,
        MessageType messageType
    ) external view returns (uint[] memory);

    /**
     * @dev Get Message By ID. Construct MessageResponse DTO.
     */
    function getMessageById(
        uint id
    ) external view returns (MessageResponseDto memory);

    /** 
     * @dev Callback function when the Campaign is registered on Greeting Contract.
     *      Now it's not in use.
     */
    function onRegistered() external pure returns (string memory);
}