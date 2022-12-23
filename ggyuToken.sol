// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract GgyuToken is ERC20, Ownable {
    uint256 private _exchangeRate = 1000;

    constructor() ERC20("GgyuToken", "GYU") {
    }

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }

    function mintForEther() external payable {
        uint256 exchangedAmount = msg.value * _exchangeRate;
        _mint(msg.sender, exchangedAmount);
    }

    function getExchangeRate() public view returns (uint256) {
        return _exchangeRate;
    }

    function setExchangeRate(uint256 _exchangeRate_) public onlyOwner {
        _exchangeRate = _exchangeRate_;
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal virtual override {}
}
