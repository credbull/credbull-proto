//SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import { ERC20 } from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract MockCBL is ERC20 {
    constructor() ERC20("MockCBL", "MCBL") { }

    function mint(address to, uint256 amount) public {
        _mint(to, amount);
    }
}
