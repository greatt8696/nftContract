// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract TestTransition {
    // Tranfer 이벤트
    event Transfer(
        address indexed sender,
        address indexed reiciver,
        uint256 indexed amount
    );

    // Mint 이벤트
    event Mint(address indexed minter, uint256 indexed amount);

    // Burn 이벤트
    event Burn(
        address indexed burner,
        address indexed zeroAddress,
        uint256 indexed amount
    );

    /*
      _balances 모든 지갑의 잔액을 담을수 있는 저장소 (오브젝트)
      자바스크립트 예)
      const _balances = {,
        "0x10h...235" : 10,
        "0x4d1...1ff" : 100,
        "0x251...sd3" : 1000,
        "0xaaa...ah3" : 10000,
        "0xb0d...222" : 100000, ...
                        }
    */

    mapping(address => uint256) private _balances;

    // 총발행량
    uint256 private _totalAmount;

    // 총발행량 리턴하는 함수
    function totalAmount() public view returns (uint256) {
        return _totalAmount;
    }

    // 지갑의 잔액을 확인해주는 함수
    function balanceOf(address account) public view returns (uint256) {
        return _balances[account];
    }

    // 이더리움을 갖고 민팅하는 함수
    function mintWithEth() public payable returns (bool) {
        uint256 amount = msg.value;
        _balances[msg.sender] += amount;
        _totalAmount += amount;
        emit Mint(msg.sender, amount);
        return true;
    }

    // 간단한 민트함수
    function faucetMint(uint256 amount) public returns (bool) {
        require(amount <= 2**88);
        _balances[msg.sender] += amount;
        _totalAmount += amount;
        emit Mint(msg.sender, amount);
        return true;
    }

    // 소각함수
    function burn(uint256 amount) public returns (bool) {
        require(_balances[msg.sender] > amount, "not available amount");
        _balances[msg.sender] -= amount;
        _totalAmount -= amount;
        emit Burn(msg.sender, address(0), amount);
        return true;
    }

    function transfer(address to, uint256 amount) public returns (bool) {
        require(_balances[msg.sender] > amount, "not available amount");
        _balances[msg.sender] -= amount;
        _balances[to] += amount;
        emit Transfer(msg.sender, to, amount);
        return true;
    }
}
