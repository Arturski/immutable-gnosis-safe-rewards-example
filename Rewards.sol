// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

interface ISafeModule {
    function executeRewardsTransfer(address recipient, uint256 amount) external;
}

contract Rewards {
    address public owner;
    address public safeModule;
    ISafeModule public safeModuleInstance;

    mapping(address => uint256) public rewardsBalance;

    modifier onlyOwner() {
        require(msg.sender == owner, "Rewards: Caller is not the owner");
        _;
    }

    event RewardRequested(address indexed user, uint256 amount);
    event RewardsAdded(address indexed user, uint256 amount);
    event SafeModuleChanged(address indexed newSafeModule);

    constructor() {
        owner = msg.sender;
    }

    // Allows the current owner to update the owner address
    function setOwner(address newOwner) external onlyOwner {
        require(newOwner != address(0), "Rewards: New owner address cannot be zero");
        owner = newOwner;
    }

    // Set or update the Safe module instance
    function setSafeModule(address _safeModule) external onlyOwner {
        require(_safeModule != address(0), "Rewards: Invalid Safe module address");
        safeModule = _safeModule;
        safeModuleInstance = ISafeModule(safeModule);
        emit SafeModuleChanged(_safeModule);
    }

    // Add rewards to a user's balance (incremental)
    function addReward(address user, uint256 amount) external onlyOwner {
        require(user != address(0), "Rewards: User address cannot be zero");
        require(amount > 0, "Rewards: Amount must be greater than zero");
        rewardsBalance[user] += amount;
        emit RewardsAdded(user, amount);
    }

    // Claim all rewards due for the caller by calling the Safe module
    function claimReward() external {
        uint256 amount = rewardsBalance[msg.sender];
        require(amount > 0, "Rewards: No rewards available to claim");
        require(address(safeModuleInstance) != address(0), "Rewards: Safe module is not set");

        // Reset balance after claiming
        rewardsBalance[msg.sender] = 0;

        // Call the Safe module to execute the transfer
        safeModuleInstance.executeRewardsTransfer(msg.sender, amount);

        emit RewardRequested(msg.sender, amount);
    }
}
