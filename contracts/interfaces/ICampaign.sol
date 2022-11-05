//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

// TODO: Revisit and Improve overall interface design. (Especially, it's alinged with Campaign implementation.)
interface ICampaign is IERC721 {
    enum MessageStatus {
        WAITING_FOR_REPLY,
        REPLIED
    }
    
    enum MessageType {
        INCOMING,
        SENT
    }

    struct Message {
        address sender;
        address recipient;
        uint greetingWordIndex;
        string bodyURI;
    }

    struct MessageResponseDto {
        uint id;
        address sender;
        address recipient;
        string greetingWord;
        string bodyURI;
        MessageStatus status;
        bool isResonanced;
    }

    function getGreetingWordList() external view returns (string[] memory);

    function selectGreetingWord(uint wordIndex) external;

    function getPricePerMessageInWei() external view returns (uint price);

    function send(
        address from,
        address to,
        string memory messageURI
    ) external;

    function getMessageIds(
        address who,
        MessageType messageType
    ) external view returns (uint[] memory);

    function getMessageById(
        uint id
    ) external view returns (MessageResponseDto memory);

    function onRegistered() external pure returns (string memory);
}