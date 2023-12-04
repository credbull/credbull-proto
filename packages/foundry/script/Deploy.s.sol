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

         MockToken token = new MockToken();




        vm.startBroadcast(deployerPrivateKey);
        YourContract yourContract = new YourContract(
            vm.addr(deployerPrivateKey)
        );

            token.mint(vm.addr(deployerPrivateKey),1000);
          TestContract testContract = new TestContract(
            vm.addr(deployerPrivateKey),token,"CBL","Campaign Share"
        );


        console.logString(
            string.concat(
                "YourContract deployed at: ",
                vm.toString(address(yourContract))
            )
        );

        console.logString(
            string.concat(
                "TestContract deployed at: ",
                vm.toString(address(testContract))
            )
        );

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
