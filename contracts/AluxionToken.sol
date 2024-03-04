// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/finance/PaymentSplitter.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract CustomPaymentSplitter is PaymentSplitter {
    using SafeERC20 for IERC20;

    address private constant FIXED_ADDRESS = 0x6135A5e92E9e29eA7d105DcBB56d70C3f1BC7dc8;
    uint256 private constant FIXED_ADDRESS_SHARE = 1; // 0.1%
    uint256 private constant SENDER_SHARE = 999; // 99.9%

    mapping(address => bool) private isApproved;

    constructor() PaymentSplitter(
        _getPayees(),
        _getShares()
    ) {}

    function splitBill() public payable {
        require(msg.value > 0, "Bill amount must be greater than zero");
        // Calculate the amounts to be split
        uint256 fixedAmount = (msg.value * FIXED_ADDRESS_SHARE) / 1000;
        uint256 senderAmount = msg.value - fixedAmount;

        // Release the payment to the fixed address
        release(payable(FIXED_ADDRESS));

        // Transfer the remaining amount back to the caller
        payable(msg.sender).transfer(senderAmount);
    }


    function splitTokenBill(IERC20 token, uint256 amount) public {
        require(amount > 0, "Token bill amount must be greater than zero");
        //require(isApproved[msg.sender], "User must approve the contract first");
        require(token.balanceOf(msg.sender) >= amount, "Insufficient token balance");

        // Split the token bill
        _splitTokenBill(token, amount);
    }
    function getDecimals(IERC20 token) public view returns (uint) {
  ERC20 erc20token = ERC20(address(token));
  return erc20token.decimals();
}

    function _splitTokenBill(IERC20 token, uint256 amount) internal {
        // Transfer the tokens from the caller to the contract
        token.safeTransferFrom(msg.sender, address(this), amount);
        uint decimals = getDecimals(token);

       // Calculate amounts
    uint256 fixedAmount = (amount * FIXED_ADDRESS_SHARE) / 1000;
    uint256 senderAmount = amount - fixedAmount;

    // Scale amounts
    uint256 scaledFixedAmount = fixedAmount * (10 ** decimals);
    uint256 scaledSenderAmount = senderAmount * (10 ** decimals);

    // Transfer tokens 
    token.transfer(FIXED_ADDRESS, scaledFixedAmount);
    token.transfer(msg.sender, scaledSenderAmount);

    }

    function _getPayees() private view returns (address[] memory) {
        address[] memory payees = new address[](2);
        payees[0] = FIXED_ADDRESS;
        payees[1] = msg.sender;
        return payees;
    }

    function _getShares() private pure returns (uint256[] memory) {
        uint256[] memory shares = new uint256[](2);
        shares[0] = FIXED_ADDRESS_SHARE;
        shares[1] = SENDER_SHARE;
        return shares;
    }
}