pragma solidity >=0.4.0 <0.7.0;
import './DCCSC.sol';

contract UCSC{
    address payable public thisucsc;     //address of this ucsc contract
    address payable public owner;        //owner address of this UCSC contract
    uint256 public state;                //online ? close
    uint256 public skill;                //level of user skill
    address public pre_work;             //previous work DCCSC address
    uint256 public Um;                   //active or passive
    int256  public Trust;                //Value of Trust
    int256  public Coin;                 //Coin  
    uint256 public Coin_eth;             //Coin_eth
    uint256 public block_number;
    
    uint256 public flag_dccsc;
    address payable public addr_dccsc;
    
    constructor() public payable{       //construct function; set basic user info
        state = 0;
        skill = 50;                      //test set skill = 20
        Um = 0;
        Trust = 50;                      //test set trust = 20
        Coin = 0;
        Coin_eth = 0;
        flag_dccsc = 0;                 //test set 1
        owner = msg.sender;
        thisucsc = address(this);
        
    }
    function getblocknum() public returns(uint256){
        block_number = block.number;
        return 0;
    }
   
    function pay_ment_by_other(address temp_task,int256 temp_trust,int256 temp_coin) payable public returns(uint256){  //payment functionmethods
            set_prework(temp_task);
            set_trust(temp_trust);
            set_coin(temp_coin);
            pay_for_dccsc();
            return 0;
    }
    function set_prework(address addr) public returns(uint256){   //set the previous work address
            pre_work = addr;
            return 0;
    }
    function set_trust(int256 temp) public returns(uint256){    //set trust just call by others
            if(msg.sender != owner){
                Trust += temp; 
            }
            return 0;
    }
    function set_coin(int256 temp) public returns(uint256){    //transfer coin just call by others
            if(msg.sender != owner){
                Coin += temp; 
            }
            return 0;
    }
    function get_skill()public  returns(uint256){               //return current skill
            return skill;
    }
    function get_state()public  returns(uint256){              //return current state
            return state;
    }
    function get_trust()public  returns(int256){               //return current trust
            return Trust;
    }
    function get_prework()public returns(address){            //return previous work address
            return pre_work;
    }
    
    function set_state(uint256 temp_state)public returns(uint256){
            state = temp_state;
            return 0;
    }
    function set_UM(uint256 temp_UM)public returns(uint256){
            Um = temp_UM;
            return 0;
    }
    
    function svalue(address payable addr)public payable{
        
        addr.transfer(10000);
    }
    
    function getblance(address payable addr)public payable{
        Coin_eth = addr.balance;
    }
    //add a DCCSC construct
    function add_dccsc(address payable addr)public payable returns(uint256){
        flag_dccsc = 1;
        addr_dccsc = addr;
        return 0;
    }
    
    function pay_for_dccsc()public payable returns(uint256){
        if(flag_dccsc == 1){
            int256 ttrust =  DCCSC(addr_dccsc).get_rewardt();
            int256 ccoin  =  DCCSC(addr_dccsc).get_rewardc();
            address payable addr = address(uint160(DCCSC(addr_dccsc).get_ucscaddr()));
            UCSC(addr).set_trust(ttrust);
            UCSC(addr).set_coin(ccoin);
            addr.transfer(5*10**18);
        }
        flag_dccsc = 0;
        return 0;
    }
    
    fallback() external payable{}
}
