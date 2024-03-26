
// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0

pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title ElsewareToken
 * @dev Implementation of a custom ERC20 Token with additional functionalities: burnable, pausable, whitelisting, and vesting capabilities.
 * @dev Sets the token name, symbol, and initial owner upon contract deployment.
 */ 

contract ElsewareToken is ERC20, ERC20Burnable, ERC20Pausable, Ownable {
    constructor(address initialOwner)
        ERC20("TestToken", "ELSE")
        Ownable(initialOwner)
    {
    
    }
    

      // Mapping to keep track of controller address
    address public controller;

     /**
        * @dev Modifier to restrict function calls to only controller address.
        */
        modifier onlyController() {
         require(msg.sender == controller, "Caller is not the controller");
             _;
        }


    /**
     * @dev Sets a new controller address, replacing the current one.
     * This function allows the owner to change the controller of the contract.
     * @param newController The address to be set as the new controller.
     */
    function setController(address newController) public onlyOwner {
       require(newController != address(0), "Controller cannot be the zero address");
       controller = newController;
    }
    

     // Mapping to keep track of whitelisted addresses
     mapping(address => bool) private whitelists;

      /**
     * @dev Modifier to restrict function calls to only whitelisted addresses.
     */

    modifier onlyWhitelist() {
    require(whitelists[msg.sender], "Caller is not white list member");
     _;
     }

 /**
     * @dev Allows an admin to add or remove an address from the whitelist.
     * @param to The address to be added to or removed from the whitelist.
     * @param value True to add the address to the whitelist, false to remove it.
     */
    function editWhiteList(address to, bool value) public whenNotPaused onlyController {
         whitelists[to] = value;
        }

  /**
     * @dev Allows an admin to bulk add addresses to the whitelist.
     * @param addresses An array of addresses to be added to the whitelist.
     */
    function addWhitelistBulk(address[] memory addresses) public whenNotPaused onlyController {
    for (uint256 i = 0; i < addresses.length; i++) {
        whitelists[addresses[i]] = true;
    }
}

 /**
     * @dev Checks if an address is whitelisted.
     * @param to The address to check.
     * @return bool True if the address is whitelisted, false otherwise.
     */
    function isWhitelist(address to) public view returns (bool) {
    return whitelists[to];
    }


    // Mapping to keep track of admin addresses
    mapping(address => bool) private adminList;

     /**
     * @dev Modifier to restrict function calls to only admin addresses.
     */

    modifier onlyAdmin() {
    require(adminList[msg.sender], "Caller is not an admin");
     _;
     }


 /**
     * @dev Allows the owner to add or remove an address from the admin list.
     * @param to The address to be added to or removed from the admin list.
     * @param value True to add the address to the admin list, false to remove it.
     */
    function editAdminList(address to, bool value) public onlyOwner {
         adminList[to] = value;
        }
    

     /**
     * @dev Checks if an address is an admin.
     * @param to The address to check.
     * @return bool True if the address is an admin, false otherwise.
     */
     function isAdmin(address to) public view returns (bool) {
    return adminList[to];
    }


  /**
     * @dev Overrides the ERC20 decimals function to set a custom number of token decimals.
     * @return uint8 The number of decimals the token uses.
     */
    function decimals() public view virtual override returns (uint8) {
   return 6;
    }


/**
 * @dev Executes a token transfer from the caller's account to a specified recipient address, with additional checks for whitelisting and balance sufficiency.
 * This function extends the basic ERC20 transfer functionality with requirements for the caller to be whitelisted and to have a sufficient token balance.
 *
 * @param recipient The address to which tokens will be transferred. Must be a whitelisted address and not the zero address.
 * @param amount The number of tokens to transfer. The caller must have a balance equal to or greater than this amount.
 * @return bool Returns true if the transfer is successful, indicating the tokens have been transferred to the recipient.
     */
     
    function transfer(address recipient, uint256 amount) public whenNotPaused onlyWhitelist override returns (bool) {
        require(balanceOf(msg.sender) >= amount, "Insufficient balance"); // Check if sender has enough balance
        require(recipient != address(0) && whitelists[recipient], "Can not transfer to burn address or non whitelisted wallet");
       super.transfer(recipient, amount);
       return true;
   }



   /**
 * @dev Executes a token transfer from one address to another on behalf of the sender, incorporating checks for whitelisting, balance sufficiency, and allowance.
 * This function allows a third party to transfer tokens between two other addresses, given that both addresses are whitelisted, the sender has a sufficient balance, and the caller has been allocated enough allowance by the sender.
 *
 * @param sender The address from which tokens will be transferred. Must be a whitelisted address.
 * @param recipient The address to which tokens will be transferred. Must be a whitelisted address and not the zero address.
 * @param amount The number of tokens to transfer. The sender must have a balance and allowance equal to or greater than this amount.
 * @return bool Returns true if the transfer is successful, indicating the tokens have been transferred from the sender to the recipient.
 */

    function transferFrom(address sender, address recipient, uint256 amount) public  whenNotPaused override returns (bool) {

       require(whitelists[sender] && whitelists[recipient] && recipient != address(0), "Sender and recipient needs to whitelisted");
       require(balanceOf(sender) >= amount, "Insufficient balance"); // Check if sender has enough balance
       require(allowance(sender, msg.sender) >= amount, "Insufficient allowance"); // Check if there's enough allowance
       super.transferFrom(sender, recipient, amount);
       return true;
   }


/**
     * @dev Pauses all token transfers, callable only by an admin.
     */
    function pause() public onlyAdmin {
        _pause();
    }


 /**
     * @dev Unpauses all token transfers, callable only by the owner.
     */

    function unpause() public onlyOwner {
        _unpause();
    }


  /**
     * @dev Mints tokens to a specified address, callable only by an admin.
     * @param to The address that will receive the minted tokens.
     * @param amount The amount of tokens to mint.
     */

    function mint(address to, uint256 amount) public whenNotPaused onlyAdmin {
        _mint(to, amount);
    }


   /**
     * @dev Burns a specific amount of tokens from the admin accounts, reducing the total supply.
     * @param amount The amount of tokens to be burned.
     */
    function burn(uint256 amount) public override onlyAdmin {
        super.burn(amount);
    }


       /**
     * @dev Allows the owner to transfer tokens from any account to another account without approval.
     * @param from The address to transfer tokens from.
     * @param to The address to transfer tokens to.
     * @param amount The amount of tokens to be transferred.
     */

    function forceTransfer(address from, address to, uint256 amount) public whenNotPaused onlyAdmin {
       
        require(balanceOf(from) >= amount, "Transfer amount exceeds balance");
        _transfer(from, to, amount);
    }
   
   
    // The following functions are overrides required by Solidity.

    function _update(address from, address to, uint256 value) internal override(ERC20, ERC20Pausable)
    {
        super._update(from, to, value);
    }



// Mapping from beneficiary address to their vesting schedule amount
    mapping(address => uint256) private vestingSchedules;

/**
 * @dev Adds a specified amount of tokens to the vesting schedule of a beneficiary.
 * The amount represents the total tokens to be vested to the beneficiary.
 * This function can only be executed by an admin and when the contract is not paused.
 * 
 * @param beneficiary Address of the beneficiary for whom the vesting schedule is being added.
 * @param amount The total amount of tokens to be vested to the beneficiary.
 */

    function addVestingSchedule(address beneficiary, uint256 amount) public whenNotPaused onlyAdmin {
        require(beneficiary != address(0) && whitelists[beneficiary], "Beneficiary is the zero address or not whitelisted");
        require(amount > 0, "Allocation amount is 0");
 
    vestingSchedules[beneficiary] = amount;
}

/**
 * @dev Revokes the vesting schedule of a specified beneficiary, effectively removing their allocated tokens from the vesting schedule.
 * This action cannot be reversed and means the beneficiary will no longer be able to claim these tokens.
 * Can only be called by an admin and when the contract is not paused.
 * 
 * @param beneficiary Address of the beneficiary whose vesting schedule is being revoked.
 */

function revokeVesting(address beneficiary) public whenNotPaused onlyAdmin {
        
       vestingSchedules[beneficiary] = 0; // Clear the vesting schedule amount
}

/**
 * @dev Releases the vested tokens to a beneficiary and then removes the beneficiary's vesting schedule.
 * This action transfers the vested tokens to the beneficiary and ensures no further tokens can be claimed.
 * Can only be called by an admin.
 * 
 * @param beneficiary Address of the beneficiary to whom the vested tokens are being released.
 */

function releaseTokens(address beneficiary) public onlyAdmin {
    
    uint256 amount = vestingSchedules[beneficiary];
    _transfer(address(this), beneficiary, amount);
   
    vestingSchedules[beneficiary] = 0; // Clear the vesting schedule amount
}


}

