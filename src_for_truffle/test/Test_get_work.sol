pragma solidity >=0.4.25 <0.7.0;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/DCCSC.sol";
import "../contracts/TCSC.sol";
import "../contracts/UCSC.sol";

contract Test{
    UCSC doo;
    TCSC foo;
    DCCSC coo;
    function Get_init() public {
         foo = UCSC();
         coo = DCCSC();
    }
    
    function Getwork_task() public{
        
    }

    function Getwork_edge() public{
        
    }
    

}
