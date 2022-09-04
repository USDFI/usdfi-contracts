pragma solidity =0.5.16;

interface IUSDFIFactory {
    event PairCreated(
        address indexed token0,
        address indexed token1,
        address pair,
        uint256
    );

    function owner() external view returns (address);

    function feeAmountOwner() external view returns (address);

    function getPair(address tokenA, address tokenB)
        external
        view
        returns (address pair);

    function allPairs(uint256) external view returns (address pair);

    function allPairsLength() external view returns (uint256);

    function createPair(address tokenA, address tokenB)
        external
        returns (address pair);

    function baseFeeAmount() external view returns (uint256);

    function baseOwnerFeeShare() external view returns (uint256);

    function baseProtocolFeeShare() external view returns (uint256);

    function baseFeeTo() external view returns (address);

    function baseProtocolVault() external view returns (address);
}
