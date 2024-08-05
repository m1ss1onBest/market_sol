// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity 0.8.24;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MyToken is ERC20, Ownable {

    // _______________VARIABLES_______________
    uint256 public mintPrice = 0.001 ether;

    // _______________ERRORS_______________
    error NotEnoughMoney(uint256 required, uint256 amount);

    // _______________EVENTS_______________  
    event Minted(uint256 amount, address reiever);

    //_______________CONSTRUCTOR_______________  
    constructor()
        ERC20("MyToken", "MTK")
        Ownable(msg.sender) {}

    //_______________EXTERNAL_______________   
    function mint(uint256 amount) external payable {
        uint256 totalPrice = mintPrice * amount;

        if (msg.sender != owner() && msg.value < totalPrice)
            revert NotEnoughMoney(totalPrice, amount);
            
        _mint(msg.sender, amount);
        emit Minted(amount, msg.sender);
    }

    function setMintPrice(uint256 _mintPrice) external onlyOwner {
        mintPrice = _mintPrice;
    }

    function withdraw() external onlyOwner {
        payable(owner()).transfer(address(this).balance);
    }
}

