// jscode for 32Bytes -> String 
const ethers =  require('ethers');

 async function createBytes (args) {
    const bytes = args[0];
    const name = ethers.decodeBytes32String(bytes);
    console.log('name: ',name);
}

createBytes(process.argv.slice(2)); // process.argv is when node.js execute, array that have cmd's arguments

// 1) bsdev - > 0x6273646576000000000000000000000000000000000000000000000000000000
// 2) changho -> 0x6368616e67686f00000000000000000000000000000000000000000000000000
// 3) chaemin -> 0x636861656d696e00000000000000000000000000000000000000000000000000

