// SPDX-License-Identifier: GPL-3.0

pragma solidity >= 0.7.0 <0.9.0;

contract Ex3_15{    
    
    uint public a =3;

    function myfun() external view returns(uint ,uint)
    {
        uint b = 4;
        return(a,b);
    }



    /*
    function myfun() extrenal pure returns(uint){
        
        return b;
        }

    */
}
