const UCSC = artifacts.require("UCSC");
const TCSC = artifacts.require("TCSC");
const DCCSC = artifacts.require("DCCSC");

contract("Test", accounts => {
    let instance1;
    let instance2;
    it("Get Instance !",async()=>{
       instance1 = await TCSC.at('0xa7FCb75aC6CDDF51b6707D5830A10E24262d82Dc');
       instance2 = await DCCSC.at('0x632eFfAb768CF6903d3e369255cA3b9FD9d2282e');
    });    
   
    it("Call function",async()=>{
       const res1 = await instance1.Getwork_task('0xF16801403Ec4b5091659dEf9917911e00Df34f64');
    });

   it("Call function2",async()=>{
       const res2 = await instance2.Getwork_edge('0xF16801403Ec4b5091659dEf9917911e00Df34f64');
    });
});

