- The following contract implements the simplest form of a cryptocurrency. 
- The contract allows only its creator to create new coins (different issuance schemes are possible). 
- Anyone **can send coins to each other** without a need for registering with a username and password, all **you need is an** **Ethereum keypair.** 

```cpp
// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.4;

contract Coin {
    // The keyword "public" makes **variables**
    // accessible from other contracts
    address public minter; // declares a state variable of type address 
    /* ethereum's address 20 bites value.
    - EOA 주소, Contract Account 의 해시 저장하는데 적합하다.(public)
    - without keyword public , No one Can access.  

then, compiler generate this code.
function minter() external view returns (address) { return minter; }

    */
    mapping(address => uint) public balances;
    // a public state variable but it is a more complex datatype. The [mapping] type maps addresses to [unsigned integers].
    /* mapping 함수를 사용하면 아래 함수가 자동으로 생성됩니다.
    function balances(address account) external view returns (uint) {
    return balances[account];
}
->You can use this function to query the balance of a single account.
    */


    // Events allow clients to react to specific
    // contract changes you declare
    event Sent(address from, address to, uint amount);

    // Constructor code is only run when the contract
    // is created
    constructor() {
        minter = msg.sender;
    } 
    // msg.sender는 현재 함수를 호출한 주소(외부 소유 계정 혹은 contract 계약)

    // Sends an amount of newly created coins to an address
    // Can only be called by the contract creator
    function mint(address receiver, uint amount) public {
        require(msg.sender == minter);
        balances[receiver] += amount;
    }

    // Errors allow you to provide information about
    // why an operation failed. They are returned
    // to the caller of the function.
    error InsufficientBalance(uint requested, uint available);

    // Sends an amount of existing coins
    // from any caller to an address
    function send(address receiver, uint amount) public {
        if (amount > balances[msg.sender])
            revert InsufficientBalance({
                requested: amount,
                available: balances[msg.sender]
            });

        balances[msg.sender] -= amount;
        balances[receiver] += amount;
        emit Sent(msg.sender, receiver, amount);
    }
}
```

## Mapping ? 
- Mappings can be seen as [hash tables](https://en.wikipedia.org/wiki/Hash_table) which are virtually initialised such that every possible key exists from the start and is mapped to a value whose byte-representation **is all zeros**
- what is the difference between Regular Variables.?
	- 지역변수(local): 함수 내에서 저장되며 블록체인에 기록되지 않는다.
	- 상태변수(state) : 함수 외부에서 선언되며 블록체인에 저장되어 영속성을 가진다. 어디에서든 접근가능하다. (지금 코드상에서 state 변수라고 볼 수 있다.)
	- global 변수: 블록체인에 관한 정보를 제공한다.

- 현재 코드에서는 balances 는 상태변수로 address 를 키로 사용해서 토큰(unit)을 저장하는 매핑이다. 이를 통해서 각 주소에 대응하는 토큰 잔액을 관리할 수 있다. -> hash Tables 라고 생각해라! 

## mapping Generate Funciton
-  when you define a **mapping**, a default **getter function** is automatically generated for it
```cpp 
function balances(address account) external view returns (uint) {
    return balances[account];
}
```
- You can use this function to query the balance of a single account.

## Event on BlockChain
- event Sent(address from, address to, uint amount);
	- 해당 이벤트 코드는 이벤트를 정의한 것이다.
- 클라이언트는 블록체인에서 이벤트가 발생하는것을 수신할 수 있다.
- 발생한 이벤트를 통해서 **트랜잭션을 추적할 수 있다.**

### Listen to event 

- web3.js 를 사용해서 js 코드로 contract object를 생성한다.
```js
Coin.Sent().watch({}, '', function(error, result) {
    if (!error) {
        console.log("Coin transfer: " + result.args.amount +
            " coins were sent from " + result.args.from +
            " to " + result.args.to + ".");
        console.log("Balances now:\n" +
            "Sender: " + Coin.balances.call(result.args.from) +
            "Receiver: " + Coin.balances.call(result.args.to));
    }
})
```
- 모든 사용자 인터페이스는 위에서 자동으로 생성된 balances() 함수를 호출한다.
	- balances() 함수는 Smart-contract 에서 UI 클릭해서 호출한다. 
- js 코드는 Coin.Sent() 라는 이벤트를 watch 하는거다. 

## constructor 
- transaction 생성 될 때 한 번만 실행되는 함수
- Smart-contract를 생성한 사람의 주소를 영구적으로 저장한다.

- msg.sender: 현재 함수 호출이 발생한 주소를 나타내며, 이는 외부에서 호출된 함수의 주소입니다
- 위의 코드에서는 msg.sender를 썼고, smart - contract 에서는 보통 msg.sender를 사용한다.
	- msg.sender : 메세지의 발신자 ,(ex 이를 통해 메세지를 전달한 컨트랙트를 확인가능) 
	- tx.origin : 트랜잭션의 원래 발신자 주소를 나타낸다. ( 초기 트랜잭션 발생시킨 사용자의 주소) (보안 취약)
- [[special global variable of Solidity]]
	- solidity에서 특별히 제공되는 전역 변수
	- 스마트 컨트랙트 내에서 언제나 네임스페이스(global namespace)에 존재한다.
	- 목적: 블록 체인에 관한 정보를 제공하거나 일반적인 유틸리티 기능을 수행하는데 사용된다.
	- ex ) 
		- msg.sender: 메시지의 직접적인 발신자 주소
			 , block.timestamp: 현재 블록의 타임스탬프를 초 단위로 나타냄
			 , block.number: 현재 블록의 번호


# mint() , send()
- mint  와 send() 함수는 솔리디티 기본 제공함수는 아니다. 
- 하지만 contract를 구성한다. 사용자와 컨트랙트가 호출 할 수 있는 함수이기도 하다.

## mint() 

- The [require](https://docs.soliditylang.org/en/v0.8.24/control-structures.html#assert-and-require) function call defines conditions that reverts all changes if not met. 
- 보통 민트를 스마트 컨트랙트를 배포할 때 초기 토큰을 생성하고자 할 때 사용된다.
### overFlow 가능 
- In general, the creator can mint as many tokens as they like, but at some point, this will lead to a phenomenon called “overflow” 
	-  디폴트가 오버플로우 나면 require() 실행하게 되어있어서 되돌아감. [Checked arithmetic](https://docs.soliditylang.org/en/v0.8.24/control-structures.html#unchecked),

# Error 처리 
### revert 사용 
- Errors are used together with the [revert statement](https://docs.soliditylang.org/en/v0.8.24/control-structures.html#revert-statement). The statement unconditionally aborts and reverts all changes similar to the function, but it also allows you to provide the name of an error and additional data which will be supplied to the caller 
	  -> 되돌리는건 함수 (require() )하고 같은데, 다른 점으로 오류난 데이터나 호출자를 알려준다.
	  -> easy to debugging
