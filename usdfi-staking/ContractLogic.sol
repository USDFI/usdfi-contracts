/**
 * @title Contract Logic
 * @dev ContractLogic contract
 *
 * @author - <USDFI TRUST>
 * for the USDFI Trust
 *
 * SPDX-License-Identifier: Business Source License 1.1
 *
 **/

import "./SafeERC20.sol";
import "./SafeMath.sol";
import "./IReferrals.sol";
import "./IWhitelist.sol";

pragma solidity 0.6.12;

contract ContractLogic {
    using SafeMath for uint256;
    using SafeERC20 for IERC20;

    // outputs the external contracts.
    IWhitelist public whitelist; // external whitelist contract
    IReferrals public referrals; // external referrals contract

    uint256 public constant DURATION = 1 days; // distribution time
    uint256 public nextRewardTime; // time between new rewards

    address public stakingCoinAddress; // coin that can be staked
    address public rewardCoinAddress; // the coin distributed for staking
    address public vaultAddress; // where the rewards come from

    uint256 private _totalSupply; // total deposited staking coins

    mapping(address => uint256) private balances; // address deposited staking coins
    mapping(address => uint256) public requestedWithdrawTime; // address requested Payout Time
    mapping(address => uint256) public userRewardPerTokenPaid; // how many coins did an address get per staked token
    mapping(address => uint256) public rewards; // how much did an address get paid

    uint256[] public refLevelReward = [40000, 30000, 10000, 10000, 5000, 5000]; // Allocation of ref fees over the ref level
    uint256 public minReferralAmount = 990000000000000000; // set the min staking amount to set a new referral | 0.99 tokens

    uint256 public lockTime = 30 days; // how long are the coins locked | 30 days
    uint256 public rewardCoinFee = 10000; // tranfer fee from the reward coin (10000 = 0%)
    uint256 public stakingCoinFee = 10000; // If a coin has a transfer fee, this can be compensated with it. (10000 = 0%)
    uint256 public refRewardFee = 5000; // ref reward from the staking (5000 = 5%)
    uint256 internal normalPercent = 100000 - refRewardFee; // Payout percentage without refs
    uint256 public emergencyTimeframe = 7 days; // how long you can make a free instant emergency withdrawal
    uint256 public emergencyTime; // how long is the emergency Withdawal
    uint256 public freeTime = 2 days; // how long you have to make a withdrawal after the lock time has expired | 2 days
    uint256 public periodFinish; // when is the drop finished
    uint256 public rewardRate; // how many coins are credited
    uint256 public lastUpdateTime; // when was the last update
    uint256 public rewardPerTokenStored; // how many coins did a Token get
    uint256 public ReceivedRewardCoins; // How many reward coins the contract has received

    // return total deposited staking coins
    function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }

    // return deposited staking coins from address
    function balanceOf(address account) public view returns (uint256) {
        return balances[account];
    }

    // stake "staking coin" to the pool
    function stake(uint256 _amount, address _sponsor) public virtual {
        requestedWithdrawTime[msg.sender] = 1;
        _totalSupply = _totalSupply.add(_amount.mul(stakingCoinFee).div(10000));
        balances[msg.sender] = balances[msg.sender].add(
            _amount.mul(stakingCoinFee).div(10000)
        );
        IERC20(stakingCoinAddress).safeTransferFrom(
            msg.sender,
            address(this),
            _amount
        );

        if (
            _amount >= minReferralAmount &&
            referrals.isMember(msg.sender) == false &&
            referrals.isMember(_sponsor) == true
        ) {
            referrals.addMember(msg.sender, _sponsor);
        }
    }

    // withdraw "staking coin" from the pool (when the address is in the withdraw time)
    function withdraw(uint256 _amount) public virtual {
        require(
            block.timestamp > requestedWithdrawTime[msg.sender].add(lockTime) &&
                block.timestamp <
                requestedWithdrawTime[msg.sender].add(lockTime).add(freeTime),
            "You must wait until the lock ends"
        );
        _totalSupply = _totalSupply.sub(_amount);
        balances[msg.sender] = balances[msg.sender].sub(_amount);
        IERC20(stakingCoinAddress).safeTransfer(msg.sender, _amount);
    }

    // emergency withdraw "staking coin" from the pool #SAFU
    function emergencyWithdraw(uint256 _amount) public virtual {
        require(block.timestamp < emergencyTime, "no emergency");
        _totalSupply = _totalSupply.sub(_amount);
        balances[msg.sender] = balances[msg.sender].sub(_amount);
        IERC20(stakingCoinAddress).safeTransfer(msg.sender, _amount);
    }
}
