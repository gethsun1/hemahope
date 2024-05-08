// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title UtilityToken
 * @dev A utility token contract for governance, rewards, and access to platform features.
 */



    contract UtilityToken is ERC20, Ownable {
        /**
        * @dev Constructor to initialize the token contract.
        * @param _name The name of the token.
        * @param _symbol The symbol of the token.
        * @param _initialSupply The initial supply of tokens.
        */
        constructor(
            string memory _name,
            string memory _symbol,
            uint256 _initialSupply,
            address initialOwner // Add initialOwner argument
        ) ERC20(_name, _symbol) Ownable(initialOwner) { // Pass initialOwner to Ownable constructor
            _mint(initialOwner, _initialSupply);
        }



    /**
     * @dev Issue new tokens to a recipient.
     * @param _recipient The address of the recipient.
     * @param _amount The amount of tokens to issue.
     */
    function issueTokens(address _recipient, uint256 _amount) external onlyOwner {
        _mint(_recipient, _amount);
        emit TokensIssued(_recipient, _amount);
    }

    /**
     * @dev Burn tokens from the owner's balance.
     * @param _amount The amount of tokens to burn.
     */
    function burnTokens(uint256 _amount) external onlyOwner {
        _burn(msg.sender, _amount);
        emit TokensBurned(msg.sender, _amount);
        
    }
    event TokensIssued(address indexed recipient, uint256 amount);
    event TokensBurned(address indexed owner, uint256 amount);

    /**
     * @dev Transfer tokens from one account to another.
     * @param _from The address to transfer tokens from.
     * @param _to The address to transfer tokens to.
     * @param _amount The amount of tokens to transfer.
     */
    function transferTokens(address _from, address _to, uint256 _amount) external onlyOwner {
        _transfer(_from, _to, _amount);
    }

    /**
     * @dev Approve another address to spend tokens on behalf of the owner.
     * @param _spender The address to approve.
     * @param _amount The amount of tokens to approve.
     */
    function approveTokens(address _spender, uint256 _amount) external onlyOwner {
        _approve(msg.sender, _spender, _amount);
    }

    /**
     * @dev Increase the allowance for another address to spend tokens on behalf of the owner.
     * @param _spender The address to increase allowance for.
     * @param _addedValue The amount of increase in allowance.
     */
    function increaseAllowance(address _spender, uint256 _addedValue) external onlyOwner {
        _approve(msg.sender, _spender, allowance(msg.sender, _spender) + _addedValue);
    }

    /**
     * @dev Decrease the allowance for another address to spend tokens on behalf of the owner.
     * @param _spender The address to decrease allowance for.
     * @param _subtractedValue The amount of decrease in allowance.
     */
    function decreaseAllowance(address _spender, uint256 _subtractedValue) external onlyOwner {
        uint256 currentAllowance = allowance(msg.sender, _spender);
        require(currentAllowance >= _subtractedValue, "Decreased allowance below zero");
        _approve(msg.sender, _spender, currentAllowance - _subtractedValue);
    }
}
