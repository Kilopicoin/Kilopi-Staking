pragma solidity >=0.5.4 <0.6.0;

contract LOPStakingMainX {
	

	event Deposit(address indexed dst, uint sadd);
	event Withdrawal(address indexed src, uint sadw);
	event GetRewards(address indexed srcgr, uint sadwgr);
	
	uint256 internal totalSupply_;
	uint256 internal rewardFactor_ = 317 ;
	
	mapping(address => uint256) internal balanceOf_;
	mapping(address => uint256) internal startTimeOf_;
	mapping(address => uint256) internal rewardsOf_;
	
	function() external payable {
        deposit();
    }

	function deposit() payable public {
		require(msg.tokenid == 1002482, "only kilopi token");
		rewards(msg.sender);
		balanceOf_[msg.sender] += msg.tokenvalue;
		totalSupply_ += msg.tokenvalue;
		emit Deposit(msg.sender, msg.tokenvalue);
	}

	function withdraw(uint256 trnsmnt) payable public {
		require(balanceOf_[msg.sender] >= trnsmnt, "balance must gt request");
		rewards(msg.sender);
		balanceOf_[msg.sender] -= trnsmnt;
		msg.sender.transferToken(trnsmnt, 1002482);
		totalSupply_ -= trnsmnt;
		emit Withdrawal(msg.sender, trnsmnt);
	}
	
	function rewards(address _address) internal {
		rewardsOf_[_address] = rewardsOf_[_address] + ((( block.timestamp - startTimeOf_[_address] ) * ( (rewardFactor_) * balanceOf_[_address] )) / 1000000000000 );
		startTimeOf_[_address] = block.timestamp;
    }
	
	function rewardscheck(address _address) public view returns (uint256) {
		return rewardsOf_[_address] + ((( block.timestamp - startTimeOf_[_address] ) * ( (rewardFactor_) * balanceOf_[_address] )) / 1000000000000 );
	}
	
	function getRewards() payable public {
		rewards(msg.sender);
		require(rewardsOf_[msg.sender] > 0, "rewards must gt 0");
		msg.sender.transferToken(rewardsOf_[msg.sender], 1002482);
		emit GetRewards(msg.sender, rewardsOf_[msg.sender]);
		rewardsOf_[msg.sender] = 0;
	}
	
	
	function totalSupply() public view returns (uint) {
	return totalSupply_;
	}

	function balanceOf(address guy) public view returns (uint){
	return balanceOf_[guy];
	}
	

}