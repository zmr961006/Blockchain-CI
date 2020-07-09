const UCSC = artifacts.require("UCSC");
const TCSC = artifacts.require("TCSC");
const DCCSC = artifacts.require("DCCSC");

contract("Test", accounts => {
    let instance1;
    it("Get Instance !",async()=>{
       instance1 = await TCSC.at('0x2c0B7B7A0C51048456B5d06ecf52e20716a25e76');
    });    
   
    it("Init ideal TCSC",async()=>{
       const res1 = await instance1.init_tcsc_ideal(60);
       const res2 = await instance1.init_ideal_evn('0xc9E17Be6d5eef05358f5Cf94043aBe2C241e9380');
    });

    it("Call Payment",async()=>{
       const res = await instance1.Payment_Task();
    });

});

