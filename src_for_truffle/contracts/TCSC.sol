pragma solidity >=0.4.0 <0.7.0;
import './UCSC.sol';

//群智任务控制合约
//将群智任务内容进行初始化，并且接受其他参与者进行承包任务工作

contract TCSC{
    
    address payable public thistcsc;   //This TCSC address                                   ；本合约地址
    address payable public owner;      //The owner address                                   ；部署合约的外部账户地址
    uint256 public state;              //online?close                                        ；当前合约的状态；在线？关闭
    uint256 public skill;              //require of skill                                    ；要求用户的技能等级
    address[] public Set_work;         //Set of workers                                      ；参与者合约地址等级集合，动态扩展
    address[] public Set_prework;      //Set of worker's prework                             ；参与者上一次完成任务地址记录，形成参与者的参与任务地址链条
    address[] public Set_verify;       //Set of verify's address                             ；验证状态为，被设置后，即为当前的index用户的数据处理完成，等待处理完成
    uint256[] public now_flag;         //Set of worker online                                ；当前已经完成任务的参与者标志
    uint256[] public update_flag;      //Set of update flag,change by worker,block.number    ；记录用户参与者完成任务的时间（区块标号）
    uint256[] public verify_flag;      //Set of verify flag,change by verifyer               ；验证符号，验证者请求验证相关数据，并设置参与位置
    uint256[] public require_res;      //require verify result for each worker               ；要求的数据最低标准
    uint256[] public real_res;         //real verify result for each worker                  ；由验证者上传的最终的数据验证结果
    uint256 public Dm;                //Data module                                          ；当前的数据模式，是否支持边缘处理
    int256  public Trust;             //require of trust                                     ；对参与者信誉值的要求
    int256  public reward_trust;      //reward trust value                                   ；信誉值报酬
    int256  public M;                 //reward coin value                                    ；信誉值代币奖励
    uint256 public time_ddl;          //time of upload result deadline                       ；任务完成的截止时间
    uint256 public time_pddl;         //time of payment result deadline                      ；任务支付完成的截止时间
    uint256 public count;             //need number of workers                               ；当前群智任务需要的工人数量
    uint256 public ccount;            //current number of workers                            ；当前参与任务的工人数量
    string  public addr_data;         //read data IP                                         ；任务数据来源IP地址
    string  public addr_updata;       //updata data IP                                       ；任务数据上传IP地址
    string  public fun_verify;        //verify function　　　　　　　　　　　　　　　　　　　　　；任务发布者提供的验证函数与方法
    uint256 public complete_count;    //current complete work number　　　　　　　　　　　　　　；已经完成任务的用户数量
    uint256 public stand;             //count of verify finish　　　　　　　　　　　　　　　　　；已经完成验证的数量
    int256  public coin;              //This contract coin　　　　　　　　　　　　　　　　　　　；合约余额
    address payable public paytest;
    
    //constructor
    //合约构造函数
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
    //init 合约初始化函数，设定群智任务的参与人数，并动态扩展存储状态变量
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
    //设定要求的任务最低完成标准
    function init_requireres(uint256 index,uint256 res) private returns(uint256){
        require_res[index] = res;
        return 0;
    }
    //set work information
    //设定群智任务信息
    function set_Dm(uint256 newdm) public returns (uint256){
        Dm = newdm;
        return 0;
    }
    //worker get work
    //工人承包群智任务
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
    //检测工人是否有参与群智任务的资格
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
    //由任务工人直接上传任务数据标识
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
    //由边缘节点上传任务完成标识
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
    //检查ID时候为承包任务工人
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
    //验证者请求验证已经上传的群智任务数据
    function verify_data_by_Third(address addr,uint256 index) public returns(int256){
        
        if(verify_flag[index] == 1){
            Set_verify[index] = addr;
            verify_flag[index] = 3;
        }
        return 0;
    }
    //verifyer upload the result
    //验证者上传群智任务结果
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
    //验证当前的ID是否为参与验证者地址
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
    //获得当前的任务数据地址
    function get_addr_from()public returns(string memory){
        return addr_data;
    }
    //获取任务数据上传地址
    function get_addr_upload()public returns(string memory){
        return addr_updata;
    }
    //获取最终的完成时间
    function get_time_ddl()public returns(uint256){
        return time_ddl;
    }
    //获取结算的最终完成时间
    function get_time_pddl()public returns(uint256){
        return time_pddl;
    }
    //pay ment 
    //支付函数，向完成任务的参与者结算报酬
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
    //检查当前是否所有的参与者都完成了任务
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
    //返回任务需要的参与人数
    function get_count() public returns(uint256){
        return count;
    }

    //create a TCSC for testing Pay_ment();
    //创建一个测试支付函数的理想状态，测试用
    function init_tcsc_ideal(uint256 temp) public returns(uint256){
    	init_tcsc(temp);
        stand = temp;
        return 0;
    }     
    //初始化测试用理想的状态
    function init_ideal_evn(address payable addr) public returns(uint256){
        for(uint256 index = 0;index < count;index++){
            Set_work[index]    = addr;
            real_res[index]    = 100;
            update_flag[index] = 0;
	}
        return 0;
    }


    //默认回调函数
    fallback() external payable{}
 
    
}
