// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

contract MyFirstToken {
    // name, symbol, decimals -> 변수 정의만.
    string public name = "Seowoo Wrapped Ether";
    string public symbol = "swWETH";
    uint public decimals = 18;
    // totalSupply
    uint public totalSupply = 0; //mint 시 증가 burn 시 감소
    
    //balanceOf
    // 타입과 변수명 같이 명시
    mapping(address owner => uint amount) public balances;
    // 특수한 경우(매년 토큰의 갯수가 리셋)
    // (1) Contract를 매년 배포(2025TokenContract, 2026TokenContract)
    // (2) 단일 Contract로 매년/모든 해의 토큰을 관리
    // mapping(uint year => mapping(address owner => uint amount)) public balancesOfYears;
    // balancesOfYears[2023][auser.eth] = 10;

    // 누가, 누구에게, 얼마만큼 권한을 주었는가? 라는 data type
    mapping(address owner => mapping(address spender => uint)) public allowances;

    //Event
    event Transfer(address indexed from, address indexed to, uint256 amount);
    event Approval(address indexed owner, address indexed spender, uint256 amount);

    // transfer, balanceOf
    function balanceOf(address owner) public view returns (uint amount) {
        return balances[owner];
    }

    // 실행 주체: owner(from)
    // 1.Error 2.Data Update 3.Event 4.Return true
    function transfer(
        address to, 
        uint amount
    ) public returns (bool success) {
        // 1. 예외: 내가 가진 잔고보다 많은 금액을 출금하려고 하면 에러!
        address owner = msg.sender;
        require(balances[owner] >= amount);
        // 2. 잔고/데이터를 업데이트
        // from (-)
        balances[owner] -= amount;
        balances[to] += amount;
        // 3. transfer Event
        emit Transfer(owner, to, amount);
        return true;
    }

    // 실행 주체: spender(Uniswap Pair/Exchange) 나 대신 내 토큰을 사용하는 주체. contract
    function transferFrom(
        address owner,
        address to,
        uint amount
    ) public returns (bool success) {
        // spender : 실행주체
        address spender = msg.sender;
        // 1. Error 
        //    (1) 잔액이 충분한가? owner's balance >= amount
        require(balances[owner] >= amount);
        //    (2) 권한이 있는가? spender's allowance >= amount
        //    owner가 spender에게 위임한 값이 보내려는 값보다 큰가
        require(allowances[owner][spender] >= amount);

        // 2. Data Update 
        //    (1) balances
        //    (2) allowances: 1000-500=500
        balances[owner] -= amount;
        balances[to] += amount;
        allowances[owner][spender] -= amount;
 
        //3.Event 
        emit Transfer(owner, to, amount);
        //4.return true
        return true;
    }

    // approve
    // 실행 주체 : owner. 어떤 spender에게 얼만큼 줄거냐. amount만큼 allowances 변경
    function approve(
        address spender, 
        uint amount
    ) public returns (bool success) {
        address owner = msg.sender;
        allowances[owner][spender] = amount; // 덮어쓰기
        // unapprove() == approve(0)
        emit Approval(owner, spender, amount);
        return true;
    }

    // allowance
    function allowance(
        address owner, 
        address spender
    ) public view returns (uint amount) {
        return allowances[owner][spender];
    }

    // ethToToken()
    // payable : ether 받을 수 있는 함수
    function deposit() payable public returns (bool success) {
    // 얼마를 받아서(payable, msg.value) 누구에게 WETH를 민팅 해줄까? (현재 구현은 본인에게 민팅)
        address owner = msg.sender;
        uint amount = msg.value;

        // 받은만큼 minting (deposit)
        balances[owner] += amount;
        totalSupply += amount;

        // 새로운 토큰 발행 : account에게 eth 발송. 
        // 새로 minting 한 경우 address 0x0. 0주소에서 발송됐다
        emit Transfer(address(0x0), owner, amount);

        return true;
    }

}