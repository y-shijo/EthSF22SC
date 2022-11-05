const hre = require("hardhat");

async function main() {

    const HelloFactory = await hre.ethers.getContractFactory("Hello");
    const helloContract = await HelloFactory.deploy();

    await helloContract.deployed();

    console.log(`
    Contract Deployed to ${helloContract.address}
    `)

}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
