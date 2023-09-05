// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 < 0.9.0; 

contract Ex2_3 {



    uint a = 5+2;
    uint b = 5-2;
    uint c = 5*2;
    uint d = 5/5;
    uint e = 5%2;
    uint f = 5**2;

    function arithmetic() public view returns(uint,uint,uint,uint,uint,uint){

        return(a,b,c,d,e,f);
    }


    //행 단위 주석
    /*
        블록 단위 주석석

    */


}