// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

Contract Fundrasing {  // all the wallet of the owner
	unit256 public targetAmount;
	address public owner // adress는 string이 아니라 이더리움 adrress 형식이다.
	mapping(address=> unit256) public donations; // like hash tables
	// key(address) : value(donations' value)

	// 캠페인에 모금한 금액을 다 더하고, 0으로 초기화한다.
	unit256 public raisedAmount = 0;
	
	// block? -> 사전에 정의하지 않은 객체
	// 컨트랙트 배포할 때 , EVM에 의해 정의될 객체.
	// block에 컨트랙트를 (네트워크에)업로드하는 [블록]의 정보를 포함한다.
	// block이 생성되는 날짜를 '초'로 기록한다. 그 날짜에 2주를 더했다. ( 그 뜻은 2주간 지속되는 
	// 프로젝트다.
	// block은 돈을 보낼 때 생성된 트랜잭션을 보관  
	unit256 public finishTime = block.timestamp + 2 weeks;

	// Constructor : { TargetAmount , owner of property haven been initailize} 
	// 사용자 프로퍼티를 초기화 하는 곳 
	constructor(unit256 _targetAmount) { 
		targetAmount = _targetAmount;_ // owner가 targetAmount를 결정한다.
		owner = msg.sender; // msg 는 block glober 변수와 유사하다.
		// EVM 안에서 실행될 때 정의된다. msg.sender 는 행위자의 주소
	} 

	receive() external payable{  // external 은 컨트랙의 외부에서만 호출 할 수 있다.
	// payable 은 이 함수가 돈을 받을 수 있다는 것을 나타내기 위함이다.
	// 누가 돈을 보내면 (내가 이더를 받을때)receive 함수가 [자동으로] 실행된다.

		require(block.timstamp < finishTime, "this campaign is over"); // require은 조건이 참인지 여부를 확인하는 함
		// 참이 아니면 오류보내고 코드 실행중지
		donations[msg.sender] += msg.value; // 누가 얼마나 보냈는지를 저장.
		raisedAmount += msg.value; // totalAmount 증가
	}

	function withdrawDonations() external { 
		require(msg.sender == owner , "Fund will only be released to the owner");
		require(raisedAmount >= targetAmount, "The project did not reach the goal");
		require(block.timstamp > finishTime, "this campaign is not over yet"); 
		payable(owner).transfer(raisedAmount); // payable func 으로 owner에게 송
	}

	function refund() external { 
		require(block.timestamp > finishTime, "Campaign is not over yet");
		require(raiseAmount < targetAmount , "Campaign reached the goal");
		require(donations[msg.sender] >0 , "You did not doante to this campaign);
		unit256 toRefund = donations[msg.sender];
		donations[msg.sender] = 0; // 2번 환불 못 받게하기
		payable(msg.sender).transfer(toRefund); // 환불 진행
	}
	
}
