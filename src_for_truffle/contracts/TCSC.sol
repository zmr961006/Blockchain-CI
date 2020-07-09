pragma solidity >=0.4.0 <0.7.0;
import './UCSC.sol';


contract TCSC{
    
    address payable public thistcsc;   //This TCSC address
    address payable public owner;      //The owner address
    uint256 public state;              //online?close
    uint256 public skill;              //require of skill
    address[] public Set_work;         //Set of workers
    address[] public Set_prework;      //Set of worker's prework
    address[] public Set_verify;       //Set of verify's address
    uint256[] public now_flag;         //Set of worker online
    uint256[] public update_flag;      //Set of update flag,change by worker,block.number
    uint256[] public verify_flag;      //Set of verify flag,change by verifyer
    uint256[] public require_res;      //require verify result for each worker
    uint256[] public real_res;         //real verify result for each worker
    uint256 public Dm;                //Data module
    int256  public Trust;             //require of trust
    int256  public reward_trust;      //reward trust value
    int256  public M;                 //reward coin value
    uint256 public time_ddl;          //time of upload result deadline
    uint256 public time_pddl;         //time of payment result deadline
    uint256 public count;             //need number of workers
    uint256 public ccount;            //current number of workers
    string  public addr_data;         //read data IP
    string  public addr_updata;       //updata data IP 
    string  public fun_verify;        //verify function
    uint256 public complete_count;    //current complete work number
    uint256 public stand;             //count of verify finish
    int256  public coin;              //This contract coin
    address payable public paytest;
    
    //constructor
    constructor() public payable{
        state = 0;
        skill = 10;                   //test skill set 10
        Dm = 0;
        Trust = 10;                   //test trust set 10
        reward_trust = 10;
        M = 10;
        time_ddl = 100;
        time_pddl = 100;
        count = 10;
        ccount = 0;
        complete_count = 0;
        stand  = 0;
        coin = 1000;
        addr_data = "127.0.0.1";     //default IP 
        addr_updata = "192.168.0.1"; //default IP
        owner = msg.sender;
        //thistcsc = address(this);
        thistcsc = address(uint160(address(this)));   //for tuffle
    }
    //init
    function init_tcsc(uint256 index) public returns(uint256){   //after constructor, init this tcsc 
        Set_work    = new address[](index);
        Set_prework = new address[](index);
        Set_verify  = new address[](index);
        verify_flag = new uint256[](index);
        update_flag = new uint256[](index);
        require_res = new uint256[](index);
        real_res    = new uint256[](index);
        
        for(uint256 i = 0; i < index;i++ ){
            verify_flag[i] = 0;
            update_flag[i] = 0;
            require_res[i] = 0;
            real_res[i]    = 0;
        }
        count = index;
        return 0;
    }
    //set require res for task  owner
    function init_requireres(uint256 index,uint256 res) private returns(uint256){
        require_res[index] = res;
        return 0;
    }
    //set work information
    function set_Dm(uint256 newdm) public returns (uint256){
        Dm = newdm;
        return 0;
    }
    //worker get work
    function Getwork_task(address payable user) payable public returns(uint256){
        
        uint256 res = check_condition(user);  //check require
        address temp = UCSC(user).get_prework();
        
        if(res == 0){
              Set_work[ccount]    = user;
              Set_prework[ccount] = temp;
              ccount++;
        }else{
            return 1;
        }
        uint256 result = ccount-1;
        
        return result;
    }
    //check task require
    function check_condition(address payable addr) public returns(uint256){
        uint256 test1 = UCSC(addr).get_skill();
        int256 test2 = UCSC(addr).get_trust();
        
        if(ccount <= count){           //check the number of worker
            //work number engough
        }else{
            return 1;
        }
        
        if(test1 >= skill){             //check skill level require
            //pass
        }else{
            return 2;
        }
        
        if(test2 >= Trust){            //check trust level require
            //pass
        }else{
            return 2;
        }
        return 0;
        
    }
    //upload data after worker finish task
    function Upload_by_ucsc(address addr) public returns(int256){
        int256 res = verify_id(addr);
        uint256 resindex = uint256(res);
        if(res >= 0){
            update_flag[resindex] = block.number;
            verify_flag[resindex] = 1;
        }else{
            return -1;
        }
        
        return 0;
    }
    //upload data after worker_dccsc finish task
    function Upload_by_dccsc(address payable addr) public returns(int256){
        address payable addr  = address(uint160(DCCSC(addr).get_oucscaddr()));
        int256 res = verify_id(addr);
        uint256 resindex = uint256(res);
        if(res >= 0){
            update_flag[resindex] = block.number;       //different flag 
            verify_flag[resindex] = 1;   
        }else{
            return -1;
        }
        
        return 0;
    }
    //check id 
    function verify_id(address addr) public returns(int256){
        for(uint256 i = 0;i < count;i++){
            if(Set_work[i] == addr){
                return int256(i);
            }else{
                return -1;           // set 9: wrong id
            }
        }
        return -1;
    }
    //verify data using open fun by miner or other worker
    function verify_data_by_Third(address addr,uint256 index) public returns(int256){
        
        if(verify_flag[index] == 1){
            Set_verify[index] = addr;
            verify_flag[index] = 3;
        }
        return 0;
    }
    //verifyer upload the result
    function verify_uploadres_by_Third(address addr,uint256 index,uint256 res) public returns(int256){
        int256 checkid = verify_vid(addr);
        if((checkid >= 0) && (index <= count)){
            stand++;
            real_res[index] = res;
            Payment_Task();
        }
        return 0;
        
    }
    //check verify id 
    function verify_vid(address addr) public returns(int256){
        for(uint256 i = 0;i < count;i++){
            if(Set_verify[i] == addr){
                return int256(i);
            }else{
                return -1;           // set 9: wrong id
            }
        }
        return -1;
    }
    
    //get work information
    function get_addr_from()public returns(string memory){
        return addr_data;
    }
    function get_addr_upload()public returns(string memory){
        return addr_updata;
    }
    function get_time_ddl()public returns(uint256){
        return time_ddl;
    }
    function get_time_pddl()public returns(uint256){
        return time_pddl;
    }
    //pay ment 
    function Payment_Task() payable public returns(uint256){
        
        uint256 flag  = check_complete();
        if(flag == 1){
            for(uint256 i = 0; i < count;i++){
                if((real_res[i] >= require_res[i]) && (update_flag[i] <=time_ddl)){
                    paytest = address(uint160(Set_work[i]));
                    UCSC(paytest).pay_ment_by_other(thistcsc,reward_trust,M);
                    //paytest.transfer(5*10**18);
                }
                if((real_res[i] < require_res[i])||(update_flag[i] > time_ddl)){
                    paytest = address(uint160(Set_work[i]));
                    UCSC(paytest).pay_ment_by_other(thistcsc,-reward_trust,-M);
                }
            }
        }
        if(flag == 2){
            for(uint256 i = 0; i < count;i++){
                paytest = address(uint160(Set_work[i]));
                UCSC(paytest).pay_ment_by_other(thistcsc,reward_trust,M);
                paytest.transfer(5*10**18);
            }
        }
        state = 1;     //after payment, close this task
        
        return 0;
    }
    //check the task finish wether or not 
    function check_complete() public returns(uint256){
        uint256 t = block.number;
        if((stand == count) && (t <= time_ddl)){
            return 1;       //all data verify finish,in paytime ddl
        }
        
        if(t > time_pddl){
            return 2;        //task pay out of time, task fail 
        }
        return 0;           //test set 1
    }

    //return count;
    function get_count() public returns(uint256){
        return count;
    }

    //create a TCSC for testing Pay_ment();
    function init_tcsc_ideal(uint256 temp) public returns(uint256){
    	init_tcsc(temp);
        stand = temp;
        return 0;
    }     

    function init_ideal_evn(address payable addr) public returns(uint256){
        for(uint256 index = 0;index < count;index++){
            Set_work[index]    = addr;
            real_res[index]    = 100;
            update_flag[index] = 0;
	}
        return 0;
    }



    fallback() external payable{}
 
    
}
