// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/extensions/ERC20PausableUpgradeable.sol";



contract SparkToken is ERC20Upgradeable, ERC20PausableUpgradeable, OwnableUpgradeable, UUPSUpgradeable {
    uint256 public maxTransferLimit;
    uint256 public transcationFees;

    mapping(address => bool) public blacklisted; // enable or disable feature

    event BlacklistUpdated(address indexed account, bool isBlacklisted);
    event MaxTransferLimitUpdated(uint256 Limit);
    event FeesWithdrawn(address indexed to, uint256 amount);

    modifier notBlacklisted(address addr) {
        require(!blacklisted[addr], "Account is Blacklisted");
        _;
    }

    modifier underLimit(address from , uint256 amount) {
        if ( from != address(0)){
        require(amount <= maxTransferLimit, "Can transfer limited amount only");
        }
        _;
    }

    function initialize() public initializer {
        __ERC20_init("Spark", "SOT");
        __ERC20Pausable_init();
        __Ownable_init();
        __UUPSUpgradeable_init();

        _mint(msg.sender, 1000000 * 10 ** decimals());// 1M
        maxTransferLimit = 1000 * 10 ** decimals(); // limit 1000
    }

    function _authorizeUpgrade(address newImplementation) internal override onlyOwner {} // to upgrade the functions only by owner

    function pause() external onlyOwner {
        _pause();
    }

    function unpause() external onlyOwner {
        _unpause();
    }

    function updateBlacklist(address user, bool status) external onlyOwner { // to update blacklist mapping
        blacklisted[user] = status;
        emit BlacklistUpdated(user, status);
    }

    function updateMaxTransferLimit(uint256 Limit) external onlyOwner {
        maxTransferLimit = Limit;
        emit MaxTransferLimitUpdated(Limit);
    }

    function withdrawFees(address to) external onlyOwner { // can directly send tokens to owner without using 'to'
        uint256 fees = transcationFees;
        transcationFees = 0;
        _transfer(address(this), to, fees); // instead of 'to' - owner()
        emit FeesWithdrawn(to, fees);// instead of 'to' - owner()
    }

    function _beforeTokenTransfer(address from, address to, uint256 amount)
        internal virtual
        override(ERC20Upgradeable, ERC20PausableUpgradeable)
        whenNotPaused
        notBlacklisted(from)
        notBlacklisted(to)
        underLimit(from , amount) 
    {
        super._beforeTokenTransfer(from, to, amount);
    }

    function _transfer(address from, address to, uint256 amount)internal override{
        
        uint256 transactionfee = (amount * 2) / 100;
        uint256 remainingamount = amount - transactionfee;

        super._transfer(from, address(this), transactionfee);
        super._transfer(from, to, remainingamount);
        transcationFees += transactionfee;
    }
}
