// SPDX-License-Identifier: GPL-3.0

pragma solidity >= 0.7.0 <0.9.0;

contract Ex3_12{    
 
    uint public a =4;
    function myfun() public view returns(uint) { //이름 있는 반환값,  pure사용시 외부변수 못받아옴 모두 함수내의 것으로 해결결
        
        uint b = a+5;

        return b;

    }

}
