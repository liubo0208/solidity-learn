// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract OptimizedCode{
    uint[] public data;

    function process(uint[] calldata values) external {
        uint len = values.length;
        uint currentLen = data.length;
        uint count = 0;

        // 第一次循环：统计符合条件的数量
        for (uint i = 0; i < len; i++) {
            if(values[i] > 10){
                count ++;
            }
        }
        if(count > 0){
            uint newLen = currentLen + count;
            assembly{
                // 直接修改数组长度，为后续赋值预留空间
                sstore(add(data.slot, 0), newLen)
            }
        }
        uint index = currentLen;
        // 第二次循环：直接赋值，不使用 push 省 gas
        for(uint i = 0; i < len; i++) {
            if(values[i] > 10) {
                data[index] = values[i];
                index++;
            }
        }

    }
}