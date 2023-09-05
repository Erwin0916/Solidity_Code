// SPDX-License-Identifier: GPL-3.0

pragma solidity >= 0.7.0 <0.9.0;

contract Ex3_5{
    uint public a = 3;  
    
    function myfun() public returns(uint) { //반환형 함수
        a=100;

       return a;
    }


}
