pragma solidity >=0.4.0 <0.7.0;
import './DCCSC.sol';

//参与者身份控制智能合约
//记录用户身份以及用户的相关信息

contract UCSC{
    address payable public thisucsc;     //address of this ucsc contract                   ；本合约地址
    address payable public owner;        //owner address of this UCSC contract             ；部署合约的外部账户地址
    uint256 public state;                //online ? close                                  ；指示当前的合约状态，在线？关闭
    uint256 public skill;                //level of user skill                             ；用户技能等级
    address public pre_work;             //previous work DCCSC address                     ；上一次参与群智任务的地址，其中
    uint256 public Um;                   //active or passive                               ；用户参与模式，主动/被动参与
    int256  public Trust;                //Value of Trust                                  ；用户信誉值
    int256  public Coin;                 //Coin                                            ；合约余额（代币）
    uint256 public Coin_eth;             //Coin_eth                                        ；合约余额（以太币）
    uint256 public block_number;         //Block number                                    ；当前区块编号
    
    uint256 public flag_dccsc;           //flag of dccsc                                   ；DCCSC合约设置标志
    address payable public addr_dccsc;   //address of dccsc                                ；DCCSC合约地址
    
    constructor() public payable{       //construct function; set basic user info          ;智能合约构造函数
        state = 0;
        skill = 50;                      //test set skill = 20
        Um = 0;
        Trust = 50;                      //test set trust = 20
        Coin = 0;
        Coin_eth = 0;
        flag_dccsc = 0;                 //test set 1
        owner = msg.sender;
        thisucsc = address(uint160(address(this)));
        
    }
    //获取当前区块编号
    function getblocknum() public returns(uint256){
        block_number = block.number;
        return 0;
    }
    //支付函数，由任务发布者调用，结算任务，并且触发该合约的DCCSC合约结算方法
    function pay_ment_by_other(address temp_task,int256 temp_trust,int256 temp_coin) payable public returns(uint256){  //payment functionmethods
            set_prework(temp_task);
            set_trust(temp_trust);
            set_coin(temp_coin);
            pay_for_dccsc();
            return 0;
    }
    //设置当前上一次参与任务地址
    function set_prework(address addr) public returns(uint256){   //set the previous work address
            pre_work = addr;
            return 0;
    }
    //结算任务信誉值，不能由该合约自身进行调用
    function set_trust(int256 temp) public returns(uint256){    //set trust just call by others
            if(msg.sender != owner){
                Trust += temp; 
            }
            return 0;
    }
    //结算任务代币奖励，不能由合约自身进行调用
    function set_coin(int256 temp) public returns(uint256){    //transfer coin just call by others
            if(msg.sender != owner){
                Coin += temp; 
            }
            return 0;
    }
    //获得用户技能信息
    function get_skill()public  returns(uint256){               //return current skill
            return skill;
    }
    //获取用户合约当前的状态
    function get_state()public  returns(uint256){              //return current state
            return state;
    }
    //获取用户当前的信誉值
    function get_trust()public  returns(int256){               //return current trust
            return Trust;
    }
    //获取用户上一次参与的智能合约地址
    function get_prework()public returns(address){            //return previous work address
            return pre_work;
    }
    //设置用户合约的状态
    function set_state(uint256 temp_state)public returns(uint256){
            state = temp_state;
            return 0;
    }
    //设置用户参与模式
    function set_UM(uint256 temp_UM)public returns(uint256){
            Um = temp_UM;
            return 0;
    }
    //转账以太币方法
    function svalue(address payable addr)public payable{
        
        addr.transfer(10000);
    }
    //获取当前账户余额方法
    function getblance(address payable addr)public payable{
        Coin_eth = addr.balance;
    }
    //add a DCCSC construct
    //增加该用户部署的DCCSC信息
    function add_dccsc(address payable addr)public payable returns(uint256){
        flag_dccsc = 1;
        addr_dccsc = addr;
        return 0;
    }
    //向部署的DCCSC边缘任务工人结算任务奖励
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
    //默认回调函数
    fallback() external payable{
    }
}
