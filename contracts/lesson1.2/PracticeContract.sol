// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;


contract PracticeContract {
    uint256[] public numbers;
    address public immutable ADMIN;
    uint256 public constant MULTIPLIER = 2;
    
    constructor(){
        ADMIN = msg.sender;
    }

    function batchProcess(
        uint256[] calldata inputs
    ) external {
        require(msg.sender == ADMIN);

        uint len = inputs.length;

        for (uint i = 0; i < len; i++) {
            uint256 result = inputs[i] * MULTIPLIER;  // ✅ 使用constant
            numbers.push(result);
        }
    }
    
    function getSum() external view returns (uint256) {
        require(msg.sender == ADMIN);
        uint256 sum = 0;
        uint len = numbers.length;
        for (uint i = 0; i < len; i++) {
            sum += numbers[i];
        }
        return sum;
    }
}