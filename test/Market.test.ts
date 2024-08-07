
import { ethers } from "hardhat";
import { expect } from "chai";
import { parseUnits, Signer, Contract } from "ethers";

describe("Market", function () {
    let Market: any;
    let market: any;
    let nft: any;
    let token: any;

    let owner: Signer;
    let seller: Signer;
    let buyer: Signer;

    beforeEach(async function () {
        [owner, seller, buyer] = await ethers.getSigners();

        const ERC721 = await ethers.getContractFactory("MyNFT");
        nft = await ERC721.deploy();
        await nft.waitForDeployment();
    
        const ERC20 = await ethers.getContractFactory("MyToken");
        token = await ERC20.deploy();
        await token.waitForDeployment();

        Market = await ethers.getContractFactory("Market");
        const nftAddr: any = await nft.getAddress();
        const tokenAddr: any = await token.getAddress();

        market = await Market.deploy(nftAddr, tokenAddr);
        await market.waitForDeployment();
    });

    describe("Deployment", async function () {
        it("Test", async function () {
            expect(2 + 2 === 4);
        });
    });

});
