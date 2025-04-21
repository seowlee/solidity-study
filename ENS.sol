// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

// contract ENS {
//     // string -> address
//     // xxx.eth => 0x219...
//     mapping(string => address) public names;

//     // string이 들어갔을 때 주소값이 등록 안되어 있으면 address = 0x000.. 저장되어 있음
//     // 한 번도 저장하지 않은 상태이면 name을 key로 address 저장
//     function register(string memory _name, address _address) public {
//         if (names[_name] == address(0)) {
//             names[_name] = _address;
//         }
//     }

//     // Register, Reset
//     // string에 따라 가격 다름. 짧을 수록 희귀
//     // Registry, Resolvers : 2 Structure ( dns와 동일)
//     // namehash
//     // ERC721
// }


/// @title 간단한 ENS 네임 서비스 컨트랙트 예제
contract ENS {
    // 도메인 이름(예: "seowoo.eth")을 이더리움 주소에 매핑
    mapping(string => address) public names;

    // 도메인 등록 이벤트
    event Registered(string indexed name, address indexed owner);

    // 도메인 소유자 변경 이벤트
    event Updated(string indexed name, address indexed newOwner);

    /// @notice 도메인 이름을 이더리움 주소에 등록
    /// @param _name 도메인 이름 (예: "seowoo.eth")
    /// @param _address 등록할 이더리움 주소
    function register(string memory _name, address _address) public {
        // 아직 등록되지 않은 이름만 등록 가능
        require(names[_name] == address(0), "Name is already registered");
        names[_name] = _address;
        emit Registered(_name, _address);
    }

    /// @notice 기존 도메인에 대한 주소를 변경 (소유자만 가능하도록 하지 않음)
    /// 향후 이 기능은 소유자만 접근 가능하도록 권한 제한 필요
    function update(string memory _name, address _newAddress) public {
        require(names[_name] != address(0), "Name not registered yet");
        names[_name] = _newAddress;
        emit Updated(_name, _newAddress);
    }

    /// @notice 도메인 주소 반환
    /// @param _name 조회할 도메인 이름
    /// @return 이더리움 주소
    function resolve(string memory _name) public view returns (address) {
        return names[_name];
    }
}


