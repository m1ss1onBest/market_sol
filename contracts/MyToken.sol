// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity 0.8.24;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MyToken is ERC20, Ownable {

    // _______________VARIABLES_______________
    uint256 public mintPrice = 15 gwei; // Price to mint one token

    // _______________EVENTS_______________  
    event Minted(uint256 amount, address reiever); // When new Tokens are minted

    // _______________ERRORS_______________

    /// @notice If there are insufficent funds to mint Tokens
    /// @param required Required funds to mint Tokens
    /// @param amount Function caller balance
    error NotEnoughFunds(uint256 required, uint256 amount);

    //_______________CONSTRUCTOR_______________  
    constructor()
        ERC20("MyToken", "MTK") //Initializing ERC20 Token with name `MyToken` and symbol `MTK`
        Ownable(msg.sender) { // Setting contract owner

    }

    //_______________EXTERNAL_______________   

    function mint(uint256 amount) external payable {
        // Calculating total price
        uint256 totalPrice = mintPrice * amount;

        // Checking if not owner and if sent funds are enough to mint Tokens
        if (msg.sender != owner() && msg.value < totalPrice)
            // Not enough funds!
            revert NotEnoughFunds(totalPrice, amount);
            
        _mint(msg.sender, amount);
        // When successfully minted Tokens
        emit Minted(amount, msg.sender);
    }

    // Set new mint price (only contract owner)
    function setMintPrice(uint256 _mintPrice) external onlyOwner {
        mintPrice = _mintPrice;
    }

    // Function to widhtraw the funds (only contract owner)
    function withdraw() external onlyOwner {
        payable(owner()).transfer(address(this).balance);
    }
}

