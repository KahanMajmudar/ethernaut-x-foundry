// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "forge-std/Test.sol";
import "../../../src/levels/10-Reentrancy/ReentranceFactory.sol";
import "../../../src/core/Ethernaut.sol";
import "./ReentrancyAttack.sol";

contract ReentrancyTest is Test {
    Ethernaut ethernaut;
    address attacker = address(0xabcd);

    function setUp() public {
        ethernaut = new Ethernaut();
        vm.deal(attacker, 2 ether);
    }

    function testReentrancyHack() public {
        /////////////////
        // LEVEL SETUP //
        /////////////////
        ReentranceFactory reentranceFactory = new ReentranceFactory();
        ethernaut.registerLevel(reentranceFactory);
        vm.startPrank(attacker);
        address levelAddress = ethernaut.createLevelInstance{value: 1 ether}(
            reentranceFactory
        );
        Reentrance ethernautReentrance = Reentrance(payable(levelAddress));

        //////////////////
        // LEVEL ATTACK //
        //////////////////
        ReentrancyAttack attackerContract = new ReentrancyAttack{
            value: 0.1 ether
        }(payable(address(ethernautReentrance)));

        attackerContract.startAttack();

        assertEq(address(ethernautReentrance).balance, 0);

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
