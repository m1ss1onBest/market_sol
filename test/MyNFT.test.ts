import { ethers } from "hardhat";
import { expect } from "chai";
import { parseUnits, Signer, Contract } from "ethers";

describe("MyNFT", function () {
    let MyNFT: any;
    let myNFT: any;

    let owner: Signer;
    let user: Signer;

    beforeEach(async function () {
        [owner, user] = await ethers.getSigners();
        MyNFT = await ethers.getContractFactory("MyNFT");

        myNFT = await MyNFT.deploy();
    });

    describe("Deployment", async function () {
        it("Should set the right owner", async function () {
            expect(await myNFT.owner()).to.equal(await owner.getAddress());
        });
    });

    describe("Minting", async function () {
        it("Should allow the owner to mint NFT for free", async function () {
            await myNFT.connect(owner).mint();
            expect(await myNFT.ownerOf(1)).to.equal(await owner.getAddress());
        });
    
        it("Shouldn't allow user to mint NFT for free", async function () {
            expect(await myNFT.connect(user).mint({ value: parseUnits("1", "wei")}))
            .revertedWith("NotEnoughFunds");
        });
    
        it("Should allow user to mint NFT", async function () {
            let mintPrice: bigint = await myNFT.mintPrice();
    
            await myNFT.connect(user).mint({value: mintPrice.toString()});
            expect(await myNFT.ownerOf(1)).to.equal(await user.getAddress());
        });
    });

    describe("Price management", async function () {
        it("Should allow owner to set new NFT mint price", async function () {
            let newPrice: bigint = parseUnits("15", "gwei");
            await myNFT.connect(owner).setMintPrice(newPrice.toString());

            expect(await myNFT.mintPrice()).to.equal(newPrice.toString());
        });

        it("Shouldn't allow user to set new NFT mint price", async function () {
            let newPrice: bigint = parseUnits("15", "gwei");
            await expect(myNFT.connect(user).setMintPrice(newPrice.toString()))
                .to.be.reverted;
        });
    });

    describe("Withdraw", async function () {
        it("Should allow owner to withdraw funds", async function () {
            let mintPrice: bigint = await myNFT.mintPrice();

            await myNFT.connect(user).mint({ value: mintPrice.toString() });

            const withdraw: any = await myNFT.connect(owner).withdraw();
            await withdraw.wait();

            const contractBalanceAfter: bigint = await ethers.provider.getBalance(myNFT.getAddress());
            expect(contractBalanceAfter).to.equal(0);    
        });

        it("Shouldn't allow user to withdraw funds", async function () {
            await expect(myNFT.connect(user).withdraw())
            .to.be.reverted;
        });
    });
});
