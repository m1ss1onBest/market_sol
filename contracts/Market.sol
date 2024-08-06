// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity 0.8.24;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Market {
    
    // _______________VARIABLES_______________
    uint256 private _offerIdCount; // Offers ID counter

    /// @notice Structure to represent offer
    /// @param nftId Is a unique identifier of each NFT
    /// @param seller Address of seller/offerer who created the offer
    /// @param token Token required to buy the NFT
    /// @param sellPrice Amount of tokens required to buy the NFT
    struct Offer {
        uint256 nftId; // NFT ID
        address seller; // Address of the offerer

        address token; // Token address
        uint256 sellPrice; // Price in Tokens
    }

    /// @notice Mapping from `offer ID` to `offer details`
    /// @dev The key is a unique identifier for each offer, and a value is an instance of `Offer` struct
    mapping(uint256 => Offer) public offers; // (offerId -> offer) mapping to offer details by their ID

    ERC721 public NFT; // NFT contract
    ERC20 public Token; // Token contract

    // _______________ERRORS_______________
    error AddressZero();

    // _______________EVENTS_______________

    /// @notice Event emmited when offer created
    /// @param offerId Unique identifier of offer
    /// @param nftId NFT ID
    /// @param sellPrice Selling price in Tokens
    event OfferCreated(uint256 offerId, uint256 nftId, address seller, uint256 sellPrice);

    /// @notice Event emmited when offer canceled
    /// @param offerId Unique identifier of offer
    /// @param nftId NFT ID
    /// @param seller Addres of seller/offerer
    event OfferCanceled(uint256 offerId, uint256 nftId, address seller);

    /// @notice Event emmited when transaction is successful
    /// @param offerId Unique identifier of offer
    /// @param buyer Address of the buyer (completed the transaction)
    /// @param price Transaction at which the offer was completed
    event TransactionSucceed(uint256 offerId, address buyer, uint256 price);

    //_______________CONSTRUCTOR_______________
    /// @notice Market constructor, requires NFT and Token addres
    /// @param _NFT NFT contract address
    /// @param _Token Token contract address
    constructor(address _NFT, address _Token) {
        /// Checking if NFT or Token is address zero
        if (_NFT == address(0) || _Token == address(0)) revert AddressZero();

        // Setting NFT and Token contracts
        NFT = ERC721(_NFT);
        Token = ERC20(_Token);
    }

    //_______________EXTERNAL_______________
    /// @notice Function to create new offer
    /// @param _nftId Id of NFT to offer
    /// @param _sellPrice Price to buy the NFT in Tokens
    function createOffer(uint256 _nftId, uint256 _sellPrice) external {
        // Transfering NFT from function caller to Market
        NFT.transferFrom(msg.sender, address(this), _nftId);

        // Incrementing offer id and saving current offer to offers
        uint256 offerId = ++_offerIdCount;
        offers[offerId] = Offer ({
            nftId: _nftId,
            seller: msg.sender,
            token: address(Token),
            sellPrice: _sellPrice
        });

        // When successfully created an offer
        emit OfferCreated(offerId, _nftId, msg.sender, _sellPrice);
    }

    /// @notice Function to cancel offer by offerId
    /// @param offerId Id of offer to cancel
    function cancelOffer(uint256 offerId) external {
        Offer memory currentOffer = offers[offerId];

        // Transfering NFT back to owner
        NFT.transferFrom(address(this), currentOffer.seller, currentOffer.nftId);

        // Delete the offer from offers
        delete offers[offerId];
        // When successfully canceled the offer
        emit OfferCanceled(offerId, currentOffer.nftId, msg.sender);
    }

    /// @notice Function to buy the NFT
    /// @param offerId Offer identifier
    function buyNFT(uint256 offerId) external payable {
        Offer memory currentOffer = offers[offerId];

        // Checking for address zero
        if (msg.sender == address(0)) revert AddressZero();

        // Transfering Tokens from buyers to seller
        Token.transferFrom(msg.sender, currentOffer.seller, currentOffer.sellPrice);
        // Transfering NFT from market to buyer
        NFT.transferFrom(address(this), msg.sender, currentOffer.nftId);

        // Delete the offer from Offers
        delete offers[offerId];
        // When the transaction is successful
        emit TransactionSucceed(offerId, msg.sender, currentOffer.sellPrice);
    }
}
