// SPDX-License-Identifier: GPL-3.0

pragma solidity >= 0.7.0 <0.9.0;

contract Ex3_2{
    uint public a = 3;  //가시성 지정자 사용 한하면 internal이 기본적용이되어 deploy시 버튼 생성이 되지 않는다. private의 약화버젼젼

    function myfun() public {
        a=5;
    }

}
