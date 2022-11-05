//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "./interfaces/IProxy.sol";

contract Proxy is IProxy{
    address implementationAddress;

    constructor(address implementationAddress_) {
        implementationAddress = implementationAddress_;
    }

    function setImplementationAddress(address newAddress) external override {
        implementationAddress = newAddress;
    }

    function getImplementationAddress() external view override returns (address) {
        return implementationAddress;
    }
}