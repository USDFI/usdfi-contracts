/**
 * @title Stability Check
 * @dev StabilityCheck contract
 *
 * @author - <USDFI TRUST>
 * for the USDFI Trust
 *
 * SPDX-License-Identifier: Business Source License 1.1
 *
 **/

pragma solidity 0.6.12;

contract StabilityCheck {

    bool public check = true; 

    // Pre-Check how many tokens can be created.
    function isStabilityOK() public view returns (bool) {
        return(check);
    }

}