//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

interface IProxy {

    // Set new implementation address.
    function setImplementationAddress(address newAddress) external;

    // Return the current Implementation Address
    // ex. 0x976EA74026E726554dB657fA54763abd0C3a0aa9
    function getImplementationAddress() external view returns (address);
}