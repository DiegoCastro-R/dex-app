/* eslint-disable no-undef */

const EthSwap = artifacts.require('EthSwap');
const DevToken = artifacts.require('DevToken')

module.exports = async function (deployer) {
    //Deploy Dev Token
    await deployer.deploy(DevToken)
    const token = await DevToken.deployed()
    //Deploy EthSwap
    await deployer.deploy(EthSwap, token.address);
    const ethSwap = await EthSwap.deployed()


    // Transfer all tokens to EthSwap (1 million)
    await token.transfer(ethSwap.address, '1000000000000000000000000')
};
