// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;
pragma experimental ABIEncoderV2;
/** 
 * @title Transaction test
 * @dev Test to do some transaction on the ethereum blokchain
 */

contract MusicStorage {
    
    event FileNotarized(uint fileId, string fileName, uint time, address indexed owner, string hash);
    event FileChecked(uint fileId, string givenFileName, uint time, address indexed checker, string givenHash);

    struct NotarizedFile {
        uint id;
        address owner;
        string fileName;
        uint time;
        string hash;
    }
    
    NotarizedFile[] public files;
    mapping(address => NotarizedFile[]) public notarizedFiles;
    constructor()  {
    }
    
    /*
        Accept ether from anyone that sends ether 
    */
 
    receive () payable external {
    }

     /*
        Take the address of the person that as initiated the transaction and it's going to send it back a certain amount of ether to the person you want to remunerate 
     */
     
    function send_transaction(uint send_amount) public {
         require(send_amount <= 100000000000000000, "ERROR with the amount"); // = 0.1 ether so we require te payment to be less than 0.1 ether 
         payable(msg.sender).transfer(send_amount); // cast the msg.sender as a payable object 
         
    }
    
    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }
    
    function notarizeFile(string memory _fileName, string memory _hash) public {
        uint id = files.length;
        NotarizedFile memory file = NotarizedFile(id, msg.sender, _fileName, block.timestamp, _hash);
        files.push(file);
        notarizedFiles[msg.sender].push(file);
        emit FileNotarized(file.id, file.fileName, file.time, file.owner, file.hash);
    }
    
    function checkFile(uint _fileId, string memory _hash, string memory _fileName) public returns(bool) {
        emit FileChecked(_fileId, _fileName, block.timestamp, msg.sender, _hash);
        string memory fileHash = files[_fileId].hash;
        string memory fileName = files[_fileId].fileName;
        return keccak256(abi.encodePacked(fileHash)) == keccak256(abi.encodePacked(_hash)) &&
                keccak256(abi.encodePacked(fileName)) == keccak256(abi.encodePacked(_fileName));
    }
    
    function getFilesByAddress(address  _address) public view returns(NotarizedFile[] memory) {
        return notarizedFiles[_address];
    }
    function getHashMusic(uint _fileId) public payable returns(string memory) {
        if (address(this).balance >= 100000000000000000) {
            return files[_fileId].hash;
        } else
            return "";
    }
}