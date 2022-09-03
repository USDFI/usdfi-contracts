/**
 * @title Interface USDFI
 * @dev IUSDFI contract
 *
 * @author - <USDFI TRUST>
 * for the USDFI Trust
 *
 * SPDX-License-Identifier: GNU GPLv2
 *
 **/

pragma solidity 0.6.12;

interface USDFI {
    /**
     * @dev Returns the amount of tokens in existence.
     */
    function mint(address account, uint256 amount) external;
}
