# Blockchain-CI
### A Blockchain-based Framework for Crowd Intelligence
### 一种基于区块链的群体智能网络框架

版本号：V0.1（智能合约原理验证与测试版本） 
--------------------------------------------------------
remixIDE 测试版本
<br>
src\_for\_remixIDE:   
remixIDE  
solc+0.6.6


运行环境:<br>
    RemixIDE MetaMask

--------------------------------------------------------

Truffle 测试版本(中文注释)
<br>
src\_for\_truffle:    
truffle   
ganache-cli
solc+0.6.7


运行环境:<br>
    Truffle   V5.1.33(core:5.1.33)<br>
    Solidity  V0.5.16(solc-js)<br>
    Node      V12.16.1<br>
    Web3.js   V1.2.1<br>
    
--------------------------------------------------------

V0.1 版本 主流程测试步骤：
主流程测试，分为两个部分：
第一种没有DCCSC边缘处理模块参与，任务发布后，由任务工人直接获取，并完成数据处理后，由其他参与者或者矿工验证后，返回结果，并支付报酬。
第二种有DCCSC边缘处理模块参与，任务发布后，由任务工人首先承包，并继续发布DCCSC合约，由其他人承接DCCSC任务，由承接DCCSC任务者传送数据结果，矿工将验证数据填写于区块链上，并启动结算方法，首先由TCCSC向UCSC结算，最后由UCSC向DCCSC结算。
第一种测试：
1.	部署UCSC1；
2.	部署TCCSC1；并设置为该任务需要一个参与者；
3.	调用TCCSC.getwork_task 发起承包任务交易；
4.	检查Set_work[0],Set_prework[0]，是否成功承包任务；
5.	调用TCCSC.upload_by_ucsc(),设置任务完成标志；
6.	检查update_flag[0] 为当前区块个数，verify_flag[0] 设置可以效验数据位；
7.	其他参与者，发现可验证任务，调用verify_data_by_third()，请求效验数据任务；
8.	检查Set_verify[0] 设置为效验工人地址，verify_flag[0]设置为3，表示已经有验证者；
9.	验证者调用TCSC.verify_uploadres_by_third()，上传验证结果。
10.	检查real_res[index] 为验证者填写的效验数据，stand表示当前效验完成数据个数。
11.	进一步检查支付方法被调用，Payment_Task();
12.	检查承包任务者是否获得信誉值奖励以及代币、以太币奖励；
13.	检查承包任务的UCSC，得到应得信誉值奖励，代币、以太币奖励；
14.	第一种仅仅由工人参与任务流程测试完成；

第二种测试：
1.	部署UCSC1；
2.	部署TCSC1；并设置为该任务需要一个参与者；
3.	调用TCCSC.getwork_task()发起承包任务交易，并设置UCSC1为工人；
4.	检查Set_work[0],Set_prework[0] ,是否成功承包任务；
5.	部署DCCSC；
6.	调用DCCSC.set_info() 明确DCCSC合约的所有者以及相关的TCCSC信息；
7.	检查owner_dccsc, tcsc 的两个地址，是否设置成功；
8.	部署UCSC2作为另一个新的参与者，新参与者调用DCCSC.getwork_edge()，承包数据处理任务；
9.	检查owner_ucsc对应的UCSC地址中flag_dccsc 是否设置为1，addr_dccsc 是否设置；
10.	新的参与者调用TCSC.upload_by_dccsc() 上传数据结果；
11.	检查TCSC 中update_flag[0]，verify_flag[0] 是否被设置成功；
12.	其他参与者，或者矿工调用TCCSC.verify_data_by_Third()请求验证任务结果数据；
13.	检查TCSC中Set_verify[0],verify_flag[0] 是否被设置成功。
14.	当验证者在线下效验完成数据后，调用TCCSC.verify_uploadres_by_Third()，上传验证数据，并尝试调用Payment_Task()结算。
15.	检查real_res[0] 是否被成功设置；
16.	查看是否承包任务者UCSC1，是否获得奖励值；
17.	进一步，查看DCCSC关联的UCSC2是否获得奖励值；
18.	第二种情景具有DCCSC参与的任务流程结束；

