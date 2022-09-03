/**
 * @title Interface STABLE
 * @dev ISTABLE contract
 *
 * @author - <USDFI TRUST>
 * for the USDFI Trust
 *
 * SPDX-License-Identifier: Business Source License 1.1
 *
 **/

pragma solidity 0.6.12;

interface STABLE {
    /**
     * @dev Returns the amount of tokens in existence.
     */
    function mint(address account, uint256 amount) external;
}
