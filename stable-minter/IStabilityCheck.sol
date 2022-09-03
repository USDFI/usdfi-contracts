/**
 * @title Interface Stability Check
 * @dev IStabilityCheck contract
 *
 * @author - <USDFI TRUST>
 * for the USDFI Trust
 *
 * SPDX-License-Identifier: Business Source License 1.1
 *
 **/

pragma solidity 0.6.12;

interface IStabilityCheck {
    function isStabilityOK() external view returns (bool);
}
