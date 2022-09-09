// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "forge-std/Test.sol";
import "../../../src/levels/20-Denial/DenialFactory.sol";
import "../../../src/core/Ethernaut.sol";
import "./DenialAttack.sol";

contract DenialTest is Test {
    Ethernaut ethernaut;
    address attacker = address(0xabcd);

    function setUp() public {
        ethernaut = new Ethernaut();
        vm.deal(attacker, 10 ether);
    }

    function testDenialHack() public {
        /////////////////
        // LEVEL SETUP //
        /////////////////
        DenialFactory denialFactory = new DenialFactory();
        ethernaut.registerLevel(denialFactory);
        vm.startPrank(attacker);
        address levelAddress = ethernaut.createLevelInstance{value: 1 ether}(
            denialFactory
        );
        Denial ethernautDenial = Denial(payable(levelAddress));

        //////////////////
        // LEVEL ATTACK //
        //////////////////
        DenialAttack attackerContract = new DenialAttack(
            payable(address(ethernautDenial))
        );
        attackerContract.attackDenial();

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
