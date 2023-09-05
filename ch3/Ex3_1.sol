// SPDX-License-Identifier: GPL-3.0

pragma solidity >= 0.7.0 <0.9.0;

contract Ex3_1{
    uint a = 5;  //가시성 지정자 사용 한하면 internal이 기본적용이되어 deploy시 버튼 생성이 되지 않는다. private의 약화버젼젼
    uint public b = 5; //누구나 접근가능능
    uint public constant c =5;  // 절대상수 접근은 가능하지만 변경은 불가능하다.

}



