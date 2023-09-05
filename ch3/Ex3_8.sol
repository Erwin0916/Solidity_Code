// SPDX-License-Identifier: GPL-3.0

pragma solidity >= 0.7.0 <0.9.0;

contract Ex3_8{    
    uint public a=3;
    uint public b = myfun();
 
    function myfun() public returns(uint) { 
        a=20;
        
        return 100;

    }

}
