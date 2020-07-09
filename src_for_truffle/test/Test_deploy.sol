pragma solidity >=0.4.25 <0.7.0;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/DCCSC.sol";
import "../contracts/TCSC.sol";
import "../contracts/UCSC.sol";

contract Test{

    /*function test_deploy_ucsc() public {
        UCSC foo = UCSC(DeployedAddresses.UCSC());
    }*/
    
    function test_deployed_tcsc() public{
        TCSC foo = TCSC(DeployedAddresses.TCSC());
    }

    function test_deployed_dccsc() public{
        DCCSC foo = DCCSC(DeployedAddresses.DCCSC());
    }
    

}
