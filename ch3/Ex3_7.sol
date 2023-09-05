// SPDX-License-Identifier: GPL-3.0

pragma solidity >= 0.7.0 <0.9.0;

contract Ex3_7{    
 
    function myfun() public pure returns(uint age,uint weight) { //이름 있는 반환값,  pure사용시 외부변수 못받아옴 모두 함수내의 것으로 해결결
        age=20;
        weight=50;

    }

}
