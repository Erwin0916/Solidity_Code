// SPDX-License-Identifier: GPL-3.0

pragma solidity >= 0.7.0 <0.9.0;

contract Ex4_4{

  function fun1(uint a) public pure returns(uint){
      if(a>=10){
          a=9;
      }else if(a>4 && a<6){
          a=5;
      }else a=3;
      return a;
  }
}