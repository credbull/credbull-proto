//SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "../contracts/YourContract.sol";
import "../contracts/TestContract.sol";
import {MockToken} from "../contracts/mocks/MockToken.sol";

import "./DeployHelpers.s.sol";
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract DeployScript is ScaffoldETHDeploy {
    error InvalidPrivateKey(string);

    function run() external {
        uint256 deployerPrivateKey = setupLocalhostEnv();
        if (deployerPrivateKey == 0) {
            revert InvalidPrivateKey(
                "You don't have a deployer account. Make sure you have set DEPLOYER_PRIVATE_KEY in .env or use `yarn generate` to generate a new random account"
            );
        }

        vm.startBroadcast(deployerPrivateKey);
        // MockToken token = new MockToken();
        YourContract yourContract = new YourContract(
            vm.addr(deployerPrivateKey)
        );
        TestContract testContract = new TestContract(
            address(0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266),token,"CBL","Campaign Share"
        );
        MockToken mockToken = new MockToken();

        console.logString(string.concat("YourContract deployed at: ", vm.toString(address(yourContract))));
        console.logString(string.concat("Deployer Private Key: ", vm.toString(deployerPrivateKey)));

        console.logString(string.concat("TestContract deployed at: ", vm.toString(address(testContract))));

        vm.stopBroadcast();

        /**
         * This function generates the file containing the contracts Abi definitions.
         * These definitions are used to derive the types needed in the custom scaffold-eth hooks, for example.
         * This function should be called last.
         */
        exportDeployments();
    }

    function test() public {}
}
