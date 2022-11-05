//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

// import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

import "@openzeppelin/contracts/utils/Counters.sol";

import "./interfaces/ICampaign.sol";

// TOOD: ERC721 should be converted to ERC721Enumerable and ERC721Storage
contract Campaign is 
    ICampaign,
    ERC721Enumerable,
    ERC721URIStorage
{
    // Counters for token ID
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIdCounter;

    /* Set by Constoructors */

    // list of greeting words - ["", "Hello!", "LGTM!", "TGIF", ...]
    // The first element will be null as a workaround.
    string[] private greetingWords;

    // Price per message in Wei - 10000000000000000 (= 0.01 Ether)
    uint private pricePerMessageInWei;


    /* Valiables for Utilities */

    // Whether the user already selected word or not.
    mapping(address => bool) isWordSelected;

    // Greeting Word ID for each user - 0xA => 1, 0xB => 2, ...
    mapping(address => uint) selectedWordId;


    /* Below is data repositories for Query */

    // Sent Messages (0xA => [1, 2, 5])
    mapping(address => uint[]) public sentMessageIds;

    // Message Sender By Id (1 => 0xA)
    mapping(uint => address) public messageSenderById;

    // [Sender][Receiver] = true(if sent from sender to receiver); false, otherwise.
    mapping(address => mapping(address => bool)) public isMessageSentFromSenderToRecipient;

    /**
     * @dev Store GreetiingWords and PricePerMessageInWei.
     * 
     * @param greetingWords_ string[] - ["Hello", "LGTM"]
     * @param pricePerMessageInWei_ uint - 10000000000000000 (= 0.01 Ether)
     */
    constructor(
        string[] memory greetingWords_,
        uint pricePerMessageInWei_,
        string memory name_,
        string memory symbol_
    ) ERC721(name_, symbol_) {
        greetingWords.push('');
        for (uint i = 0; i < greetingWords_.length; i++) {
            greetingWords.push(greetingWords_[i]);
        }
        pricePerMessageInWei = pricePerMessageInWei_;
    }

    /**
     * @dev Get List of Greeting Words
     */
    function getGreetingWordList() external view virtual override returns (string[] memory) {
        return greetingWords;
    }

    /**
     * @dev Select the greeting Word for a caller.
     */
    function selectGreetingWord(
        uint wordIndex_
    ) external virtual override {
        require(isWordSelected[msg.sender] == false, "Err: Word is already selected.");
        require(wordIndex_ < greetingWords.length, "Err: The invalid word index.");
        require(wordIndex_ != 0, "Err: Cannot set word index to 0.");

        selectedWordId[msg.sender] = wordIndex_;
        isWordSelected[msg.sender] = true;
    }

    /**
     * @dev Get List of Greeting Words for a certain sender.
     */
    function getSelectedGreetingWord(address sender) external view returns (uint, string memory) {
        uint index = selectedWordId[sender];
        string memory word = greetingWords[index];

        return (index, word);
    }

    /**
     * @dev Get a price to send a message in Wei
     */
    function getPricePerMessageInWei() external view virtual override returns (uint price) {
        return pricePerMessageInWei;
    }

    /**
     * @dev Get a price to send a message in Wei
     */
    function send(
        address from,
        address to,
        string memory messageURI
    ) external virtual override {

        // Validation
        require(from != to, "Err: Cannot send to yourself!");
        require(!isMessageSentFromSenderToRecipient[from][to], "Err: Cannot send message to the same recipient more than once.");

        // Mint Message NFT and setURI
        uint tokenId = _tokenIdCounter.current();
        _mint(to, tokenId);
        _setTokenURI(tokenId, messageURI);

        // Store the sender information
        sentMessageIds[from].push(tokenId);
        messageSenderById[tokenId] = from;
        isMessageSentFromSenderToRecipient[from][to] = true;

        // Increment Token ID for next token minting
        _tokenIdCounter.increment();
    }

    /**
     * @dev Get message IDs for given address and messageType
     */
    function getMessageIds(
        address who_,
        MessageType messageType_
    ) external view virtual override returns (uint[] memory) {
        
        if (messageType_ == MessageType.INCOMING) {
            // In the case of Incoming Message
            uint balance = balanceOf(who_);

            uint[] memory ids  = new uint[](balance);
            for (uint index = 0; index < balance; index++) {
                ids[index] = tokenOfOwnerByIndex(who_, index);
            }
            return ids;
        } else if (messageType_ == MessageType.SENT) {
            // In the case of Sent Message
            return sentMessageIds[who_];
        } else {
            // Any other case, revert.
            revert("Reverted: Unexpected MessageType was given.");
        }
    }

    /**
     * @dev Get Message By ID. Construct MessageResponse DTO.
     */
    function getMessageById(uint id_) external view virtual override returns (MessageResponseDto memory) {
        address sender = messageSenderById[id_];
        address recipient = ownerOf(id_);
        MessageStatus status = (isMessageSentFromSenderToRecipient[recipient][sender])
            ? MessageStatus.REPLIED 
            :  MessageStatus.WAITING_FOR_REPLY;
        bool isResonanced = selectedWordId[sender] == selectedWordId[recipient];
        
        MessageResponseDto memory dto = MessageResponseDto(
            id_,
            sender,
            recipient,
            greetingWords[selectedWordId[sender]],
            tokenURI(id_),
            status,
            isResonanced
        );

        return dto;

    }

    function onRegistered() external pure virtual override returns (string memory) {
        // Not Implemented Yet
        return '';
    }



    function supportsInterface(bytes4 interfaceId)
        public
        view
        virtual
        override(IERC165, ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

    function tokenURI(uint256 tokenId) public view override(ERC721, ERC721URIStorage) returns (string memory) {
        return super.tokenURI(tokenId);
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal  override(ERC721, ERC721Enumerable) {
        require(from == address(0), "Err: This Token is SOUL BOUND!");
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
    }

}