const UCSC = artifacts.require("UCSC");
const TCSC = artifacts.require("TCSC");
const DCCSC = artifacts.require("DCCSC");

contract("Test", accounts => {
    let instance1;
    it("Get Instance !",async()=>{
       instance1 = await TCSC.at('0xa7FCb75aC6CDDF51b6707D5830A10E24262d82Dc');
    });    
   
    it("Call function",async()=>{
       const res = await instance1.init_tcsc(10);
    });
});

