# Elseware-Smart-Contract
ElsewareToken: A Commercial Real Estate Tokenization Solution

Overview

The ElsewareToken smart contract is designed to tokenize commercial real estate assets on the Ethereum blockchain, leveraging the ERC-20 standard for broader compatibility and ease of integration with the ecosystem. It incorporates advanced features such as burnable tokens, pausable transactions, whitelist-based access control, and vesting schedules, providing a comprehensive framework for managing digital securities backed by real-world properties.

Features:

ERC-20 Compliance: Fully compatible with the ERC-20 standard, facilitating integration with wallets, exchanges, and other DeFi applications.

Burnable Tokens: Allows for the reduction of the token supply, enabling mechanisms like buy-backs or token scarcity models.

Pausable Transactions: Admins can pause and unpause token transfers, providing emergency controls to respond to security threats or comply with legal requirements.

Whitelist Management: Enforces transfer restrictions to comply with regulatory requirements, ensuring that only verified participants can hold or transact with the tokens.

Admin and Controller Roles: Separates administrative privileges for managing the contract's operational aspects and controlling sensitive functions.

Vesting Schedules: Supports time-locked token release, enabling phased distributions or employee incentive plans tied to the tokenized assets.

Force Transfer: Grants the admin the ability to transfer tokens between accounts without requiring allowance, for use in exceptional circumstances.

Functions

Administrative Controls

setController(address newController): Assigns a new controller address.

editWhiteList(address to, bool value): Adds or removes addresses from the whitelist.

addWhitelistBulk(address[] memory addresses): Bulk adds addresses to the whitelist.

editAdminList(address to, bool value): Adds or removes addresses from the admin list.

pause(): Pauses all token transfers.

unpause(): Unpauses all token transfers.

Token Management

mint(address to, uint256 amount): Mints new tokens to a specified address.

burn(uint256 amount): Burns tokens from the caller's balance.

forceTransfer(address from, address to, uint256 amount): Transfers tokens between accounts without allowance, in compliance with whitelisting rules.

Whitelisting and Vesting

isWhitelist(address to): Checks if an address is whitelisted.

isAdmin(address to): Checks if an address has admin privileges.

addVestingSchedule(address beneficiary, uint256 amount): Adds a vesting schedule for a beneficiary.

revokeVesting(address beneficiary): Clears a beneficiary's vesting schedule.

releaseTokens(address beneficiary): Releases vested tokens to a beneficiary.

Development

This contract is developed with Solidity ^0.8.20 and is compatible with OpenZeppelin Contracts ^5.0.0, ensuring a high standard of security and functionality. It is designed for deployment on the Ethereum blockchain but can be adapted for other EVM-compatible networks.
