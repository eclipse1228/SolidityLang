// jscode for  String -> 32Bytes 
const ethers =  require('ethers');

 async function createBytes (args) {
    const name = args[0];
    const bytes = ethers.encodeBytes32String(name); // ethereum smart-contract use byte32 data-type. 
    console.log('name: ',bytes)
}

createBytes(process.argv.slice(2)); // process.argv is when node.js execute, array that have cmd's arguments

// 1) bsdev - > 0x6273646576000000000000000000000000000000000000000000000000000000
// 2) changho -> 0x6368616e67686f00000000000000000000000000000000000000000000000000
// 3) chaemin -> 0x636861656d696e00000000000000000000000000000000000000000000000000

/* 
you can use your terminal
- Let's Deploy.
["0x6273646576000000000000000000000000000000000000000000000000000000","0x6368616e67686f00000000000000000000000000000000000000000000000000"] 
    -> vote between "bsdev" and "changho"   
*/