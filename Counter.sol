// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

contract Counter {
// ether 낼 때마다 숫자 올라감
// 최초로 만든 사람 eoa account만 reset가능. 출금도 가능.
    // TX = 1) Invocation, 2) Payment
    // 1. DATA
    //   * value: private 
    //   * owner: public
    // 2. ACTIONS
    //   * getValue: public
    //   * increment: public, payable (TX 1,2 모두 해당)
    //   * reset: public, 그런데 owner만 호출 가능 (eoa 도 외부. + 제약조건)
    //   * withdraw: public, owner만 호출 가능
    // 3. EVNETS
    //   * Reset 기록

    uint private value = 0;
    address public owner;
    
    event Reset(address owner, uint currentValue);

    // contract 배포 시 최초 실행
    constructor() {
        // contract 배포한 owner 저장
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only Owner");
        _; // modifier가 있는 함수들은 먼저 require실행 후 밑에 함수 실행
    }

    modifier costs(uint amount) {
        require(msg.value >= amount * 1 ether);
        _;
    }

    function getValue() public view returns (uint) {
        return value;
        // view, pure, constant, payable
        // private이기 때문에 getter, setter함수 생성 필요 x
    }

    // function increment() public payable {
    //     // 1) Global Variable:msg, 2) Error (assert,revert,require)
    //     require(msg.value == 1 ether, "only 1 ETH");
    //     value = value + 1;
    // }


    function increment() public payable costs(1) {
        // 1) Global Variable:msg, 2) Error (assert,revert,require)
        value = value + 1;
    }

    function reset() public onlyOwner {
        // 특정 owner만 reset
        // require(msg.sender == owner);
        // 최종 값이 얼마일때 실행 시켰는지 기록
        emit Reset(msg.sender, value);
        value = 0;
    }

    function withdraw() public onlyOwner {
        // require(msg.sender == owner);
        // address.transfer 사용
        payable(owner).transfer(address(this).balance);
    }

}