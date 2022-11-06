//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

interface IPUSHCommInterface {
    // Send Notification via Channel to Recipient with Identity.
    function sendNotification(address _channel, address _recipient, bytes calldata _identity) external;

    // Subscribe the Channel by msg.sender.
    function subscribe(address _channel) external returns (bool);
}