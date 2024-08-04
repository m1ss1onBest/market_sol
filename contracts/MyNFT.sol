// SPDX-License-Identifier: MIT
// Compatible with OpelZeppelin Contracts ^5.0.0

pragma solidity 0.8.24;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MyNFT is ERC721, Ownable {

    // _______________ VARIABLES _______________
    uint256 private nftIdCounter;
    uint256 public mintPrice = 0.1 ether;

    // _______________ EVENTS _______________
    event Minted(uint256 nftID, address sender);

    // _______________ ERRORS _______________
    error AddressZero();
    error NotEnoughMoney(uint256 required, uint256 balance);

    constructor()
    ERC721("MyNFT", "MNT")
    Ownable(msg.sender) {

    }

    // _______________ EXTERNAL _______________
    function mint() external payable {
        if (msg.sender != owner()) {
            if (msg.value > mintPrice) revert NotEnoughMoney(mintPrice, msg.value);
        }
        
        uint256 newNFTId = ++nftIdCounter;
        _safeMint(msg.sender, newNFTId);
        
        emit Minted(newNFTId, msg.sender);
    }

    function setMintPrice(uint256 newPrice) external onlyOwner {
        mintPrice = newPrice;
    }

    function withdraw() external onlyOwner {
        payable(owner()).transfer(address(this).balance);
    }
}
