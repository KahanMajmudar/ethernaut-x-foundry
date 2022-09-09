// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "forge-std/Test.sol";
import "../../../src/levels/16-Preservation/PreservationFactory.sol";
import "../../../src/core/Ethernaut.sol";
import "./PreservationAttack.sol";

contract PreservationTest is Test {
    Ethernaut ethernaut;
    address attacker = address(0xabcd);

    function setUp() public {
        ethernaut = new Ethernaut();
        vm.deal(attacker, 1 ether);
    }

    function testPreservationHack() public {
        /////////////////
        // LEVEL SETUP //
        /////////////////
        PreservationFactory preservationFactory = new PreservationFactory();
        ethernaut.registerLevel(preservationFactory);
        vm.startPrank(attacker);
        address levelAddress = ethernaut.createLevelInstance(
            preservationFactory
        );
        Preservation ethernautPreservation = Preservation(
            payable(levelAddress)
        );

        //////////////////
        // LEVEL ATTACK //
        //////////////////
        PreservationAttack attackerContract = new PreservationAttack(
            address(ethernautPreservation)
        );
        attackerContract.attackPreservation(attacker);

        assertEq(ethernautPreservation.owner(), attacker);
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
