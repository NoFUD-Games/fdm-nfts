const fdmKey = artifacts.require("fdmKey");
 
contract ("ERC721 with Royalties", contract => {
    const [deployerAddress, tokenAddr1] = accounts;

    it ("is possible to mint tokens", async () => {
            let token = await fdmKey.deployed();
            await token.mint(tokenAddr1);
    });
})