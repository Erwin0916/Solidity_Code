// SPDX-License-Identifier: GPL-3.0

pragma solidity >= 0.7.0 <0.9.0;

contract Ex3_6{
    uint public a = 3;  
    
    uint public b = 5;
    
    function myfun() public returns(uint,uint) { //반환형 함수 2반환값값
        a=100;
        b=0;
       return(a,b);
    }

}
