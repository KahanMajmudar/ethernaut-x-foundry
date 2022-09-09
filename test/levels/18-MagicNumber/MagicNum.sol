// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "forge-std/Test.sol";
import "../../../src/levels/18-MagicNumber/MagicNumFactory.sol";
import "../../../src/core/Ethernaut.sol";
import "./MagicNumAttack.sol";

contract MagicNumTest is Test {
    Ethernaut ethernaut;
    address attacker = address(0xabcd);

    function setUp() public {
        ethernaut = new Ethernaut();
        vm.deal(attacker, 1 ether);
    }

    function testMagicNumHack() public {
        /////////////////
        // LEVEL SETUP //
        /////////////////
        MagicNumFactory magicNumberFactory = new MagicNumFactory();
        ethernaut.registerLevel(magicNumberFactory);
        vm.startPrank(attacker);
        address levelAddress = ethernaut.createLevelInstance(
            magicNumberFactory
        );
        MagicNum ethernautMagicNum = MagicNum(payable(levelAddress));

        //////////////////
        // LEVEL ATTACK //
        //////////////////
        // // init code : 0x600a600c600039600a6000f3
        // // runtime code : 0x602a60005260206000F3
        // bytes
        //     memory bytecode = "\x60\x0a\x60\x0c\x60\x00\x39\x60\x0a\x60\x00\xf3\x60\x2a\x60\x00\x52\x60\x20\x60\x00\xF3";

        // address solverAddr;
        // assembly {
        //     solverAddr := create(0, add(bytecode, 0x20), mload(bytecode))
        // }

        MagicNumAttack solver = new MagicNumAttack();
        address solverAddr = address(solver);

        ethernautMagicNum.setSolver(solverAddr);
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
