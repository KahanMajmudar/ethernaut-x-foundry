// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "forge-std/Test.sol";
import "../../../src/levels/21-Shop/ShopFactory.sol";
import "../../../src/core/Ethernaut.sol";
import "./ShopAttack.sol";

contract ShopTest is Test {
    Ethernaut ethernaut;
    address attacker = address(0xabcd);

    function setUp() public {
        ethernaut = new Ethernaut();
        vm.deal(attacker, 1 ether);
    }

    function testShopHack() public {
        /////////////////
        // LEVEL SETUP //
        /////////////////
        ShopFactory shopFactory = new ShopFactory();
        ethernaut.registerLevel(shopFactory);
        vm.startPrank(attacker);
        address levelAddress = ethernaut.createLevelInstance(shopFactory);
        Shop ethernautShop = Shop(payable(levelAddress));

        //////////////////
        // LEVEL ATTACK //
        //////////////////
        ShopAttack attackerContract = new ShopAttack(
            payable(address(ethernautShop))
        );
        attackerContract.attackShop();

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
