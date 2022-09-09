// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract MagicNumAttack {
    constructor() {
        assembly {
            // PUSH1
            // 0x2a
            // PUSH1
            // 0
            // MSTORE
            // PUSH1
            // 32
            // PUSH1
            // 0
            // RETURN

            // 0x602a60005260206000F3
            mstore(0, 0x602a60005260206000F3)
            return(0x16, 0x0a)
        }
    }
}
