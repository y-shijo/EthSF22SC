const { ethers } = require("hardhat");
const hre = require("hardhat");

async function main() {
    // Addresses
    const [owner, addr1, addr2] = await ethers.getSigners();

    // Get Contract Factories
    const CampaignFactory = await hre.ethers.getContractFactory("Campaign");
    const GreetingFactory = await hre.ethers.getContractFactory("TheGreeting");
    const ProxyFactory = await hre.ethers.getContractFactory("Proxy");

    // Deploy Campaign
    const campaign01 = await CampaignFactory.deploy(
        // 
        ["LGTM", "GREAT", "COOL"],
        5000000000000000, // 0.005ETH
        "ETH SF 2022",
        "ES22"
    );
    await campaign01.deployed();
    const campaign01Address = campaign01.address;
    console.log(`[Campaign01] Contract Deployed to ${campaign01Address}`);

    // Deploy TheGreeting
    const theGreeting = await GreetingFactory.deploy();
    await theGreeting.deployed();
    const theGreetingAddress = theGreeting.address;
    console.log(`[TheGreeting] Contract Deployed to ${theGreetingAddress}`);

    // SendMessage without verification and fee.
    try {
        await theGreeting.connect(owner).send(campaign01Address, addr1.address, "https://example.com/");
    } catch (e) {
        console.log(e);
    }

    const previousBalance = await owner.getBalance();
    console.log(`previousBalance: ${previousBalance}`);
    await theGreeting.connect(owner).send(campaign01Address, addr1.address, "https://example.com/", { value: ethers.utils.parseEther("10") });
    const newBalance = await owner.getBalance();
    console.log(`newBalance: ${newBalance}`);
    console.log(`BalanceDiff: ${previousBalance - newBalance}`);

    // Test Verify
    let status;
    status = await theGreeting.isHumanityVerified(owner.address);
    console.log(`[TheGreeting] Owner is verified?: ${status}`)

    await theGreeting.connect(owner).verifyHumanity()

    status = await theGreeting.isHumanityVerified(owner.address);
    console.log(`[TheGreeting] Owner is verified?: ${status}`)

    // Now can send message for free because it's verified.
    await theGreeting.connect(owner).send(campaign01Address, addr2.address, "https://example.com/");

}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
