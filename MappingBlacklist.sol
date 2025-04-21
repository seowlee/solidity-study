// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

contract MappingsBlacklist {
    // key값: address, value값: bool(true/false)
    mapping (address => bool) blacklist;
    // 주소에 숫자가 매칭된 경우. ex) balance, 토큰 컨트랙트일 경우 balances주소의 토큰 개수
    mapping(address => uint) balances;
    // a주소를 찾아가 mapping 데이터타입을 따라 다시 b라는 주소를 찾아가 숫자 확인. allowances
    mapping (address => mapping(address => uint)) allowances;

    function setBlacklist(address _address) public {
        blacklist[_address] = true;
    }

}