```cpp
// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.4.16 <0.9.0;

contract SimpleStorage {
    uint storedData;

    function set(uint x) public {
        storedData = x;
    }

    function get() public view returns (uint) {
        return storedData;
    }
}
```

## 1. Member에 엑세스 하는 방법이 다르다. ( 의존성 주입이 this를 하지 않고 이름 그자체로 이뤄진다! )
- To access a member (like a state variable) of the current contract, you do not typically add the `this.` prefix, you just access it directly via its name.
	- -> 이름 자체에 주입해버리네~ 
	- 원래라면 `this.storeData = x ;`'

- This contract does not do much yet apart from (due to the infrastructure built by Ethereum) allowing anyone to store a single number that is accessible by anyone in the world without a (feasible) way to prevent you from publishing this number.
	- -> 전세계 누구나 엑세스할 수 있는 숫자를 저장할 수 있다.
	- ! 근데 아직 이 숫자를 공개하는 것을 막을 수 있는 방법이 없어서 아주 완벽하진 않다.

### set 
- set 으로 계속 overWrite 가능하다. 하지만 기록은 BlockChain에 남는다.
- Later, you will see how you can impose access restrictions so that only you can alter the number.
	- -> 접근 제한 부과할 수 도 있다.
