pragma solidity >=0.4.0 <0.7.0;

import './UCSC.sol';
import './TCSC.sol';

//数据流控制合约，主要是记录各个边缘节点参与记录

contract DCCSC{
    
    address payable public thisdccsc;    //address of this DCCSC                          ；本合约地址         
    address payable public owner;        //address of owner                               ；部署该合约的外部地址
    
    string  public Datain;               //address of data input                          ；数据输入IP地址
    string  public Dataout;              //address of data output　　　　　　　　　　　　　  ；数据输出IP地址
    
    address payable public owner_ucsc;　　　　　　// owner_ucsc address                    ；部署当前合约的所有者UCSC地址
    address payable public Ucsc;                 //ucsc address                           ；部署当前承包该数据处理任务的UCSC地址
    address payable public tcsc;                 //tcsc address                           ；群智任务地址
    
    uint256 public state;                //online ? offline                               ；当前合约状态，在线？关闭
    uint256 public skill;                //Compute power                                  ；对边缘节点的能力要求
    int256 public Trust;                //Trust value                                     ；对边缘节点的信誉值要求
    int256 public M;                    //reward value                                    ；任务的报酬值
    uint256 public timedll;              //upload  deadline                               ；完成任务的最晚截至时间
    uint256 public timepdll;             //payment deadline                               ；完成任务支付的最晚截至时间
    int256  public rewardt;              //                                               ；当前任务的信誉值奖励
    uint256 public test;             
    address payable public testaddr;
    
    //合约构造函数
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
    
    //设置当前合约的信息，明确 <部署者，群智任务> 二元关系
    //设置当前的任务信息，发布者信息
    function set_info(address payable addrtcsc,address payable addrucsc)public returns (uint256){
        tcsc = addrtcsc;
        Datain = TCSC(addrtcsc).get_addr_from();
        Dataout = TCSC(addrtcsc).get_addr_upload();
        timedll = TCSC(addrtcsc).get_time_ddl();
        timepdll = TCSC(addrtcsc).get_time_pddl();
        owner_ucsc = addrucsc;
        return 0;
    }
    
    //其他边缘节点获取任务的方法
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

    
    //获取当前的信誉奖励值
    function get_rewardt()public returns(int256){
        return rewardt;
    }
    //获取当前的代币奖励值
    function get_rewardc()public returns(int256){
        return M;
    }
    //获取当前合约任务承包者UCSC地址
    function get_ucscaddr()public returns(address){
        return Ucsc;
    }
    //获取合约所有者UCSC地址
    function get_oucscaddr()public returns(address){
        return owner_ucsc;
    }
    //默认回调函数
    fallback() external payable{}
    
}
