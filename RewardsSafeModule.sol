// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

interface IGnosisSafe {
    enum Operation { Call, DelegateCall }

    function execTransactionFromModule(
        address to, 
        uint256 value, 
        bytes calldata data, 
        Operation operation
    ) external returns (bool success);
}

contract RewardsSafeModule {
    IGnosisSafe public immutable safe;
    address public rewardsContract;  // Address of the Rewards contract authorized to call this module
    address public owner;  // Owner of the contract

    constructor(address _safeAddress) {
        safe = IGnosisSafe(_safeAddress);
        owner = msg.sender;  // Setting the deployer as the initial owner
    }

    modifier onlyRewardsContractOrOwner() {
        require(msg.sender == rewardsContract || msg.sender == owner, "Unauthorized: caller is not the rewards contract or owner");
        _;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Unauthorized: caller is not the owner");
        _;
    }

    function setRewardsContract(address _rewardsContract) external onlyOwner {
        rewardsContract = _rewardsContract;
    }

    function setOwner(address _newOwner) external onlyOwner {
        require(_newOwner != address(0), "Invalid address: new owner cannot be the zero address");
        owner = _newOwner;
    }

    // Function to execute a native currency transfer using a Gnosis Safe-like module
    function executeRewardsTransfer(address payable recipient, uint256 amount) public onlyRewardsContractOrOwner {
        // Empty data for a simple native currency transfer
        bytes memory data = "";

        // Executing native currency transfer through the Gnosis Safe-like module
        require(safe.execTransactionFromModule(recipient, amount, data, IGnosisSafe.Operation.Call), "Native Currency Transfer failed");
    }
}
