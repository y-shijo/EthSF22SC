//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

contract Proxy {
    address implementationAddress;

    constructor(address implementationAddress_) {
        implementationAddress = implementationAddress_;
    }

    function setImplementationAddress(address newAddress) external {
        implementationAddress = newAddress;
    }

    function getImplementationAddress() external view returns (address) {
        return implementationAddress;
    }
}