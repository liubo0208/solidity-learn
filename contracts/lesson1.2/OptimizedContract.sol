// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;


contract OptimizedContract {
    uint[] public numbers;
    
    function addNumber(uint[] calldata _nums) public {
        uint len = _nums.length;
        for(uint i= 0; i<len ; i++){
            numbers.push(_nums[i]);
        }
    }

    function getSum() public view returns (uint){
        uint sum  = 0;
        uint len = numbers.length;
        
        for (uint i=0; i<len; i++){
            sum += numbers[i];
        }
        return sum;
        
    }
}