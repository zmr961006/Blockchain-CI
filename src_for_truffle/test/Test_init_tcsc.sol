pragma solidity >=0.4.25 <0.7.0;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/DCCSC.sol";
import "../contracts/TCSC.sol";
import "../contracts/UCSC.sol";

contract Test{
    TCSC foo;
    function Get_init() public {
         foo = TCSC(0xa7FCb75aC6CDDF51b6707D5830A10E24262d82Dc);
         foo.init_tcsc(10);
         uint256 T1 = foo.get_count();
         Assert.equal(T1,10,"Test equal");
    }
    
    function Getwork_task() public{
        
    }

    function Getwork_edge() public{
        
    }
    

}
