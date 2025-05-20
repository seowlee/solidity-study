// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

contract SeowooMemeToken {
    // name, symbol, decimals -> 변수 정의만.
    string public name = "SeowooMemeToken";
    string public symbol = "SMT";
    uint public decimals = 18;
    // totalSupply
    uint public totalSupply = 0; //mint 시 증가 burn 시 감소

    //balanceOf
    // 타입과 변수명 같이 명시
    mapping(address owner => uint amount) public balances;

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

        // ** 
        uint fee = amount / 10;
        uint amountWithoutFee = amount - fee;
        // 2. 잔고/데이터를 업데이트
        // from (-)
        balances[owner] -= amount;
        balances[to] += amountWithoutFee;
        balances[0x5B38Da6a701c568545dCfcB03FcB875f56beddC4] += fee;
        // balances["0x..."] += fee;
        // 3. transfer Event
        // emit Transfer(owner, to, amount);
        // ** 더 정확히. 구현 선택의 문제
        emit Transfer(owner, to, amountWithoutFee);
        emit Transfer(owner, 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4, fee);


        // ** 기존 transfer(to, 100) 
        // ** 변경사항 개발자에게 10% 주고 나머지 90%만 전송
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

}