const hre = require("hardhat");

async function main() {
    // Addresses
    const [owner, addr1, addr2] = await ethers.getSigners();

    // Get Contract Factories
    const CampaignFactory = await hre.ethers.getContractFactory("Campaign");
    const GreetingFactory = await hre.ethers.getContractFactory("TheGreeting");
    const ProxyFactory = await hre.ethers.getContractFactory("Proxy");

    const deployConfig = {
        campaign01: false,
        campaign02: false,
        theGreeting: true,
        proxy: false,
        setupScript: false
    }

    // Deploy Campaign - 01
    if (deployConfig.campaign01) {
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
    }

    // Deploy Campaign - 02
    if (deployConfig.campaign02) {
        const campaign02 = await CampaignFactory.deploy(
            // 
            ["NEW YEAR!", "HAPPY"],
            5000000000000000, // 0.005ETH
            "New Year 2023",
            "NY23"
        );
        await campaign02.deployed();
        const campaign02Address = campaign02.address;
        console.log(`[Campaign02] Contract Deployed to ${campaign02Address}`);
    }

    // Deploy TheGreeting
    if (deployConfig.theGreeting) {
        const theGreeting = await GreetingFactory.deploy();
        await theGreeting.deployed();
        const theGreetingAddress = theGreeting.address;
        console.log(`[TheGreeting] Contract Deployed to ${theGreetingAddress}`);
    }


    // Deploy Proxy
    if (deployConfig.proxy) {
        const proxy = await ProxyFactory.deploy(`${theGreeting.address}`);
        await proxy.deployed();
        const proxyAddress = proxy.address;
        console.log(`[Proxy] Contract Deployed to ${proxyAddress}`)
    }

    //-----------
    // Get important information to check
    // ----------

    if (!deployConfig.setupScript) {
        // fast-return if the setupScript = false
        return;
    }

    // For Greeting

    await theGreeting.registerCampaign(campaign01Address);
    await theGreeting.registerCampaign(campaign02Address);

    const campaignList = await theGreeting.getCampaignList();
    console.log(`Campaigns: ${campaignList}`);

    const campaignListAndName = await theGreeting.getCampaignListAndName();
    console.log(`Campaigns(w/ Name): ${campaignListAndName}`);


    // For Campaign - Campaign01
    console.log(`+++ Campaign 01 +++`);

    const wordList = await theGreeting.getGreetingWordList(campaign01Address);
    console.log(`WordList: ${wordList}`);

    try {
        await theGreeting.connect(owner).selectGreetingWord(campaign01Address, 0);
    } catch (e) {
        console.log(e.reason);
    }
    await theGreeting.connect(owner).selectGreetingWord(campaign01Address, 1);

    const selectedWord = await theGreeting.getSelectedGreetingWord(campaign01Address, owner.address);
    console.log(`Selected Word: ${selectedWord}`);

    const gasPricePerMessage = await theGreeting.getPricePerMessageInWei(campaign01Address);
    console.log(`GasPricePerMessage: ${gasPricePerMessage}`);

    await theGreeting.connect(owner).send(campaign01Address, addr1.address, "https://example.com/");
    await theGreeting.connect(owner).send(campaign01Address, addr2.address, "https://example.com/");

    const incomingMessageIds = await theGreeting.getMessageIdsOfCampaign(campaign01Address, owner.address, 0);
    const sentMessageIds = await theGreeting.getMessageIdsOfCampaign(campaign01Address, owner.address, 1);
    console.log(`InomingMsgIds: ${incomingMessageIds} // SentMsgIds: ${sentMessageIds}`)

    Array.from(sentMessageIds).forEach(async i => {
        const message = await theGreeting.getMessageByIdOfCampaign(campaign01Address, i);
        console.log(message);
    })


    // For Proxy
    // const currentImplAddr = await proxy.getImplementationAddress();
    // await proxy.connect(owner).setImplementationAddress(owner.address);
    // const newImplAddr = await proxy.getImplementationAddress();
    // console.log(`CurrentImplAddr: ${currentImplAddr} // NewImplAddr: ${newImplAddr}`);

}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
