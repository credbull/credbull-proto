//SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

// Useful for debugging. Remove when deploying to a live network.
import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import { ERC20 } from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import { ERC4626 } from "@openzeppelin/contracts/token/ERC20/extensions/ERC4626.sol";
import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";

contract TestContract is Ownable, ERC4626 {
    address public campaignOwner;

    constructor(address _campaignOwner, IERC20 _asset, string memory _shareName, string memory _shareSymbol)
        Ownable(_campaignOwner)
        ERC4626(_asset)
        ERC20(_shareName, _shareSymbol)
    {
        campaignOwner = _campaignOwner;
    }

    function deposit(uint256 _amount) public {
        super.deposit(_amount, _msgSender());
    }

    function withdraw() public onlyOwner {
        uint256 amount = IERC20(super.asset()).balanceOf(address(this));

        IERC20(super.asset()).approve(address(this), amount);
        IERC20(super.asset()).transferFrom(address(this), msg.sender, amount);
    }

    function withdraw(uint256 assets, address receiver, address owner)
        public
        virtual
        override
        onlyOwner
        returns (uint256)
    {
        return super.withdraw(assets, receiver, owner);
    }

    function redeem(uint256 shares, address receiver, address owner)
        public
        virtual
        override
        onlyOwner
        returns (uint256)
    {
        return super.redeem(shares, receiver, owner);
    }
}