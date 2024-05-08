// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title UserManagement
 * @dev A smart contract for managing users, roles, and contributions on a blockchain-based charity platform.
 */
contract UserManagement {
    // Define user roles
    enum UserRole { Donor, NGO }

    // Define user structure to store user data
    struct User {
        address payable userAddress;
        string username;
        UserRole role;
        mapping(string => uint) contributions; // Mapping to track user contributions by type
    }

    // Mapping to store users by their address
    mapping(address => User) public users;

    // Events for logging user registration, contributions, and role updates
    event UserRegisteredEvent(address indexed userAddress, string username, UserRole role);
    event ContributionRecordedEvent(address indexed userAddress, string contributionType, uint amount);
    event UserRoleUpdatedEvent(address indexed userAddress, UserRole newRole);

    // Modifier to restrict functions to registered users
    modifier onlyRegistered() {
        require(users[msg.sender].userAddress != address(0), "User not registered");
        _;
    }

    // Modifier to restrict functions to specific user roles
    modifier onlyRole(UserRole role) {
        require(users[msg.sender].role == role, "Unauthorized access");
        _;
    }

    /**
     * @dev Register a new user on the platform.
     * @param _username The username of the user.
     * @param _role The role of the user (Donor or NGO).
     */
    function registerUser(string memory _username, UserRole _role) public {
        require(users[msg.sender].userAddress == address(0), "User already registered");

        // Initialize user data
        users[msg.sender].userAddress = payable(msg.sender);
        users[msg.sender].username = _username;
        users[msg.sender].role = _role;

        emit UserRegisteredEvent(msg.sender, _username, _role);
    }

    /**
     * @dev Simulated login function to retrieve user information.
     */
    function loginUser() public view returns (address payable userAddress, string memory username, UserRole role) {
        require(users[msg.sender].userAddress != address(0), "User not registered");
        return (users[msg.sender].userAddress, users[msg.sender].username, users[msg.sender].role);
    }

    /**
     * @dev Record a user's contribution.
     * @param _contributionType The type of contribution (e.g., campaign1, general).
     * @param _amount The amount contributed.
     */
    function contribute(string memory _contributionType, uint _amount) public payable onlyRegistered {
        require(_amount > 0, "Invalid amount");

        users[msg.sender].contributions[_contributionType] += _amount;
        emit ContributionRecordedEvent(msg.sender, _contributionType, _amount);
    }

    /**
     * @dev Get a user's contribution history for a specific contribution type.
     * @param _contributionType The type of contribution to retrieve history for.
     * @return The total amount contributed for the specified type.
     */
    function getContributionHistory(string memory _contributionType) public view onlyRegistered returns (uint) {
        return users[msg.sender].contributions[_contributionType];
    }

    /**
     * @dev Update a user's role (only accessible to NGO role).
     * @param _userAddress The address of the user to update.
     * @param _newRole The new role to assign to the user.
     */
    function updateRole(address _userAddress, UserRole _newRole) public onlyRole(UserRole.NGO) {
        require(users[_userAddress].userAddress != address(0), "User not found");
        users[_userAddress].role = _newRole;
        emit UserRoleUpdatedEvent(_userAddress, _newRole);
    }

    /**
     * @dev Get the role of a user.
     * @param _userAddress The address of the user.
     * @return The role of the user.
     */
    function getUserRole(address _userAddress) public view returns (UserRole) {
        return users[_userAddress].role;
    }

    /**
     * @dev Get user information (address, username, role).
     * @param _userAddress The address of the user.
     * @return userAddress The address of the user.
     * @return username The username of the user.
     * @return role The role of the user.
     */
    function getUserInfo(address _userAddress) public view returns (address payable userAddress, string memory username, UserRole role) {
        return (users[_userAddress].userAddress, users[_userAddress].username, users[_userAddress].role);
    }
}
