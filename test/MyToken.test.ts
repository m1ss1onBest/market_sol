import { ethers } from "hardhat";
import { expect } from "chai";
import { parseUnits, Signer, Contract } from "ethers";

describe("MyToken", function () {
    let MyToken: any;
    let myToken: any;

    let owner: Signer;
    let user: Signer;

    beforeEach(async function () {
        [owner, user] = await ethers.getSigners();
        MyToken = await ethers.getContractFactory("MyToken");

        myToken = await MyToken.deploy();
        await myToken.waitForDeployment();
    });

    describe("Deployment", async function () {
        it("Should set the right owner", async function () {
            expect(await myToken.owner()).to.equal(await owner.getAddress());
        });
    });

    describe("Minting", async function () {
        it("Should allow owner to mint tokens for free", async function () {
            await myToken.connect(owner).mint(10);
            expect (await myToken.balanceOf(owner.getAddress())).to.equal(10);
        });

        it("Shouldn't allow user to mint Tokens for free",  async function () {
            await expect (myToken.connect(user).mint(1))
            .to.be.revertedWithCustomError(myToken, "NotEnoughFunds");
        });

        it("Should allow user to mint Tokens", async function () {
            await myToken.connect(user).mint(10, { value: parseUnits("150", "gwei" )});
            expect (await myToken.balanceOf(user.getAddress())).to.equal(10);
        });
    });

    describe("Price Management", async function () {
        it("Should allow owner to set new mint price", async function () {
            let newPrice: bigint = parseUnits("3", "gwei");
            await myToken.connect(owner).setMintPrice(newPrice.toString());
            expect (await myToken.mintPrice()).to.equal(newPrice);
        });

        it("Shouldn't allow user to set new mint price", async function () {
            let newPrice: bigint = parseUnits("3", "gwei");
            await expect(myToken.connect(user).setMintPrice(newPrice.toString()))
                .to.be.reverted;
        });
    });

    describe("Withdraw", async function () {
        it("Should allow owner to withdraw funds", async function () {
            await myToken.connect(owner).mint(10);
            await myToken.connect(owner).withdraw();
            const ownerBalance = await myToken.balanceOf(owner.getAddress());
            expect (ownerBalance).to.equal(10);
        });

        it("Shouldn't allow user to withdraw funds", async function () {
            await expect(myToken.connect(user).withdraw())
            .to.be.reverted;
        });
    });
});