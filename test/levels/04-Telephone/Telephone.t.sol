// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "forge-std/Test.sol";
import "../../../src/levels/04-Telephone/TelephoneFactory.sol";
import "../../../src/core/Ethernaut.sol";
import "./TelephoneAttack.sol";

contract TelephoneTest is Test {
    Ethernaut ethernaut;
    address attacker = address(0xabcd);

    function setUp() public {
        ethernaut = new Ethernaut();
        vm.deal(attacker, 1 ether);
    }

    function testTelephoneHack() public {
        /////////////////
        // LEVEL SETUP //
        /////////////////
        TelephoneFactory telephoneFactory = new TelephoneFactory();
        ethernaut.registerLevel(telephoneFactory);
        vm.startPrank(attacker);
        address levelAddress = ethernaut.createLevelInstance(telephoneFactory);
        Telephone ethernautTelephone = Telephone(payable(levelAddress));

        //////////////////
        // LEVEL ATTACK //
        //////////////////
        TelephoneAttack attackContract = new TelephoneAttack(
            ethernautTelephone
        );

        attackContract.telephoneAttack(attacker);

        assertEq(ethernautTelephone.owner(), attacker);

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
