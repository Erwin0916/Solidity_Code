// SPDX-License-Identifier: GPL-3.0

pragma solidity >= 0.7.0 <0.9.0;

contract Ex3_3{
    uint public a = 3;  
    
    function myfun(uint b) public { //매개변수 deploy후 생긴 myfun버튼에 숫자 입력 후 클릭 시 매개변수가 들어가서 실행된다.
       a=b;
    }


}
