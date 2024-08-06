// SPDX-License-Identifier: MIT
// Compatible with OpelZeppelin Contracts ^5.0.0

pragma solidity 0.8.24;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MyNFT is ERC721, Ownable {

    // _______________ VARIABLES _______________
    uint256 private nftIdCounter; // Counter for NFT ID
    uint256 public mintPrice = 100 gwei; // Price to mint one NFT

    // _______________ EVENTS _______________
    /// @notice When successfully minted NFT
    /// @param nftId Unique ID of minted NFT
    event Minted(uint256 nftId); // When a new NFT is minted

    // _______________ ERRORS _______________
    error AddressZero(); 
    
    /// @notice When there are insufficent funds to mint an NFT
    /// @param required Required funds to mint NFT
    /// @param balance Function caller balance
    error NotEnoughFunds(uint256 required, uint256 balance);
    //_______________CONSTRUCTOR_______________  
    constructor()
    ERC721("MyNFT", "MNFT") // Initializing an ERC721 token with name `MyNFT` and symbol `MNFT`
    Ownable(msg.sender) { // Setting contract owner
        
    } 

    // _______________ EXTERNAL _______________
    function mint() external payable {
        // Owner can mint for free
        // Otherwise checking if sent funds are enough to mint the NFT
        if (msg.sender != owner()) {
            if (msg.value > mintPrice) revert NotEnoughFunds(mintPrice, msg.value);
        }
        
        // Incrementing NFT ID
        uint256 newNFTId = ++nftIdCounter;
        _safeMint(msg.sender, newNFTId);

        // When successfully minted an NFT
        emit Minted(newNFTId);
    }

    // Set new mint price (only contract owner)
    function setMintPrice(uint256 newPrice) external onlyOwner {
        mintPrice = newPrice;
    }

    // Function to withdraw the funds (only contract owner)
    function withdraw() external onlyOwner {
        payable(owner()).transfer(address(this).balance);
    }
}
