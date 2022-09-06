# Summary

The DEX contract relies on a centralized price oracle based on its own reserves.

> This is both one of the most common methods used to attack protocols and one of the easiest DeFi security attack vectors to prevent. If you’re using `getReserves()` as a way to quantify price, this should be a red flag. This centralized price oracle exploit occurs when a user manipulates the spot price of an order book or automated market maker-based decentralized exchange (DEX), often through the use of a flash loan. The protocol then uses the price reported by the DEX as their price oracle, causing distortions in the smart contract’s execution in the form of triggering false liquidations, issuing excessively large loans, or triggering unfair trades. Due to this vulnerability, even popular DEXs such as Uniswap don’t recommend using their reserves alone as a pricing oracle.

_Ref: https://blog.chain.link/defi-security-best-practices/_

![](https://user-images.githubusercontent.com/19994887/161902944-7f06e721-08fe-4e55-a005-620a3e31be0f.png)

# Objective

The goal of this level is for you to hack the basic DEX contract below and steal the funds by price manipulation.

You will start with 10 tokens of token1 and 10 of token2. The DEX contract starts with 100 of each token.

You will be successful in this level if you manage to drain all of at least 1 of the 2 tokens from the contract, and allow the contract to report a "bad" price of the assets.

Quick note

Normally, when you make a swap with an ERC20 token, you have to approve the contract to spend your tokens for you. To keep with the syntax of the game, we've just added the approve method to the contract itself. So feel free to use contract.approve(contract.address, <uint amount>) instead of calling the tokens directly, and it will automatically approve spending the two tokens by the desired amount. Feel free to ignore the SwappableToken contract otherwise.

Things that might help:

-   How is the price of the token calculated?
-   How does the swap method work?
-   How do you approve a transaction of an ERC20?
