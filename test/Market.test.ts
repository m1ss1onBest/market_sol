import { ethers } from "hardhat";
import { expect } from "chai";
import { parseUnits, Signer, Contract } from "ethers";

describe("Market", function () {
    let Market: any;
    let market: any;
    let nft: any;
    let token: any;

    let owner: Signer;
    let user: Signer;

    beforeEach(async function () {
        [owner, user] = await ethers.getSigners();

        const ERC721 = await ethers.getContractFactory("MyNFT");
        nft = await ERC721.deploy();
    
        const ERC20 = await ethers.getContractFactory("MyToken");
        token = await ERC20.deploy();
        await token.waitForDeployment();

        Market = await ethers.getContractFactory("Market");
        const nftAddr: any = await nft.getAddress();
        const tokenAddr: any = await token.getAddress();

        market = await Market.deploy(nftAddr, tokenAddr);
        await market.waitForDeployment();
    });

    describe("Sell offer", async function () {
        it("Should allow to create offer", async function () {
            await nft.connect(owner).mint();
            await nft.connect(owner).approve(market.getAddress(), 1);
            await market.connect(owner).createOffer(1, 50);
        
            const offer = await market.offers(1);
            expect (offer.nftId == 1);
            expect (offer.sellPrice).to.equal(50);
            expect (offer.seller).to.equal(await owner.getAddress());
        });

        it("Shoukd allow to cancel offer", async function () {
            await nft.connect(owner).mint();
            await nft.connect(owner).approve(market.getAddress(), 1);
            await market.connect(owner).createOffer(1, 50);

            await market.connect(owner).cancelOffer(1);
            const offer = await market.offers(1);
            expect(offer.nftId == 0);
        });
    });

    describe("Buy NFT", async function () {
        it("Should allow to buy an nft", async function () {
            await nft.connect(owner).mint();
            await nft.connect(owner).approve(market.getAddress(), 1);
            await market.connect(owner).createOffer(1, 100);

            await token.connect(user).mint(100, { value: (100n * await token.mintPrice()).toString() });
            await token.connect(user).approve(market.getAddress(), 100);
            await market.connect(user).buyNFT(1);

            expect (await nft.ownerOf(1)).to.equal(await user.getAddress());
        });

        it("Shouldn't allow to buy nft if insufficent funds", async function () {
            await nft.connect(owner).mint();
            await nft.connect(owner).approve(market.getAddress(), 1);
            await market.connect(owner).createOffer(1, 100);

            await token.connect(user).mint(100, { value: (100n * await token.mintPrice()).toString() });
            // only 99 tokens allowed when 100 are required
            await token.connect(user).approve(market.getAddress(), 99); 
            expect (market.connect(user).buyNFT(1)).to.be.reverted;
        });
    });
});
