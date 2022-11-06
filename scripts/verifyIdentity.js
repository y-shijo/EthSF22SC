const hre = require("hardhat");

async function main() {
    // Addresses
    const [owner, addr1, addr2] = await ethers.getSigners();

    // Get Contract Factories
    const CampaignFactory = await hre.ethers.getContractFactory("Campaign");
    const GreetingFactory = await hre.ethers.getContractFactory("TheGreeting");
    const ProxyFactory = await hre.ethers.getContractFactory("Proxy");

    // Deploy TheGreeting
    const theGreeting = await GreetingFactory.deploy();
    await theGreeting.deployed();
    const theGreetingAddress = theGreeting.address;
    console.log(`[TheGreeting] Contract Deployed to ${theGreetingAddress}`);

    // Test Verify
    let status;
    status = await theGreeting.isHumanityVerified(owner.address);
    console.log(`[TheGreeting] Owner is verified?: ${status}`)

    await theGreeting.connect(owner).verifyHumanity()

    status = await theGreeting.isHumanityVerified(owner.address);
    console.log(`[TheGreeting] Owner is verified?: ${status}`)

}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
