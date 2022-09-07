// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "forge-std/Test.sol";
import "../../../src/levels/11-Elevator/ElevatorFactory.sol";
import "../../../src/core/Ethernaut.sol";
import "./ElevatorAttack.sol";

contract ElevatorTest is Test {
    Ethernaut ethernaut;
    address attacker = address(0xabcd);

    function setUp() public {
        ethernaut = new Ethernaut();
        vm.deal(attacker, 1 ether);
    }

    function testElevatorHack() public {
        /////////////////
        // LEVEL SETUP //
        /////////////////
        ElevatorFactory elevatorFactory = new ElevatorFactory();
        ethernaut.registerLevel(elevatorFactory);
        vm.startPrank(attacker);
        address levelAddress = ethernaut.createLevelInstance(elevatorFactory);
        Elevator ethernautElevator = Elevator(payable(levelAddress));

        //////////////////
        // LEVEL ATTACK //
        //////////////////
        ElevatorAttack attackerContract = new ElevatorAttack(
            address(ethernautElevator)
        );

        attackerContract.attackElevator();

        assertEq(ethernautElevator.top(), true);
        //////////////////////
        // LEVEL SUBMISSION //
        //////////////////////
        bool levelSuccessfullyPassed = ethernaut.submitLevelInstance(
            payable(levelAddress)
        );
        vm.stopPrank();
        assert(levelSuccessfullyPassed);
    }
}
