pragma solidity >=0.4.0 <0.7.0;

import './UCSC.sol';
import './TCSC.sol';


contract DCCSC{
    
    address payable public thisdccsc;    //address of this DCCSC
    address payable public owner;        //address of owner
    
    string  public Datain;               //address of data input  
    string  public Dataout;              //address of data output
    
    address payable public owner_ucsc;
    address payable public Ucsc;                 //ucsc address
    address payable public tcsc;                 //tcsc address
    
    uint256 public state;                //online ? offline
    uint256 public skill;                //Compute power
    int256 public Trust;                //Trust value
    int256 public M;                    //reward value
    uint256 public timedll;              //upload  deadline
    uint256 public timepdll;             //payment deadline
    int256  public rewardt;
    uint256 public test;
    address payable public testaddr;
    constructor() payable public{
        state = 0;
        skill = 30;
        Trust = 30;
        M = 8;
        rewardt = 12;
        owner = msg.sender;
        //thisdccsc = address(this);
        thisdccsc = address(uint160(address(this))); //for turffle
    }
    
    function set_info(address payable addrtcsc,address payable addrucsc)public returns (uint256){
        tcsc = addrtcsc;
        Datain = TCSC(addrtcsc).get_addr_from();
        Dataout = TCSC(addrtcsc).get_addr_upload();
        timedll = TCSC(addrtcsc).get_time_ddl();
        timepdll = TCSC(addrtcsc).get_time_pddl();
        owner_ucsc = addrucsc;
        return 0;
    }
    
    function Getwork_edge(address payable ucsc)public returns(uint256){
        testaddr = address(uint160(ucsc));
        uint256 t1 = UCSC(testaddr).get_skill();
        int256 t2 = UCSC(testaddr).get_trust();
        
        if((t1 >= skill) && (t2 >= Trust)){
            Ucsc = testaddr;
            UCSC(owner_ucsc).add_dccsc(thisdccsc);
        }
        return 0;
    }

    
    
    function get_rewardt()public returns(int256){
        return rewardt;
    }
    
    function get_rewardc()public returns(int256){
        return M;
    }
    
    function get_ucscaddr()public returns(address){
        return Ucsc;
    }
    function get_oucscaddr()public returns(address){
        return owner_ucsc;
    }
    
    fallback() external payable{}
    
}
