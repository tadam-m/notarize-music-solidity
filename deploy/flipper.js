const { Connection, LAMPORTS_PER_SOL, Keypair } = require('@solana/web3.js');
const { Contract, Program } = require('@solana/solidity');
const { readFileSync } = require('fs');

const FLIPPER_ABI = JSON.parse(readFileSync('/home/tadam/EIP/smart_contracts/compile/compiled_contracts/flipper.abi', 'utf8'));
const PROGRAM_SO = readFileSync('/home/tadam/EIP/smart_contracts/compile/compiled_contracts/bundle.so');

(async function () {
    console.log('Connecting to your local Solana node ...');
    const connection = new Connection('http://localhost:8899', 'confirmed');

    const payer = Keypair.generate();

    const signature = await connection.requestAirdrop(payer.publicKey, LAMPORTS_PER_SOL);
    await connection.confirmTransaction(signature, 'confirmed');

    const program = Keypair.generate();
    const storage = Keypair.generate();

    const contract = new Contract(connection, program.publicKey, storage.publicKey, FLIPPER_ABI, payer);

    await contract.load(program, PROGRAM_SO);

    console.log('Program deployment finished, deploying the flipper contract ...');

    await contract.deploy('flipper', [true], program, storage, 17);

    const res = await contract.functions.get();
    console.log('test deploy contract : successfull');

    console.log('current state: ' + res.result);

    console.log('test flip state function: ');


    await contract.functions.flip();

    const res2 = await contract.functions.get();

    console.log('Succefull new state: ' + res2.result);

})();