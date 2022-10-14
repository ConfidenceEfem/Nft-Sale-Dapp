// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./WhiteListInterface.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";

contract CryptoDevNft is ERC721Enumerable, Ownable {
    WhiteListInterface whitelist;

    uint public maxTokenId = 20;

    uint public tokenid = 1;

    bool public presaleStarted;

    uint public Presalended;

    uint public pricePerNft = 0.0001 ether; 


    constructor(address whitelistContractaddr) ERC721("CryptoDevNft", "CDNFT"){
        whitelist = WhiteListInterface(whitelistContractaddr);
    }

    modifier checkPresaleStarted() {
        require(presaleStarted, "Presale hasn't started yet");
        _;
    }
    modifier checkIfSenderisOnwhitelist() {
        require(whitelist.whiteListAddress(msg.sender), "You don't have right for this operation; you are not on whitelist");
        _;
    }
    modifier checknftPrice() {
        require(msg.value >= pricePerNft, "Incorrect ether amount");
        _;
    }
    modifier checkIfNftIsAvailable() {
        require(tokenid < maxTokenId, "Out of Nft, Check later");
        _;
    }

    function presaleMinting() public payable checkPresaleStarted checkIfSenderisOnwhitelist checknftPrice checkIfNftIsAvailable {
        require(Presalended >= block.timestamp, "Presale ended already");

        _safeMint(msg.sender, tokenid);

        tokenid++;
    }

    function startPresale() public onlyOwner checkPresaleStarted {
        presaleStarted = true;
        Presalended = block.timestamp + 5 minutes;
    }

    function saleMinting() public payable checkIfNftIsAvailable checknftPrice {
        require(Presalended<=block.timestamp,"Presale is still ongoing");

        _safeMint(msg.sender, tokenid);

        tokenid++;
    }

    function withdrawEtherToContract() onlyOwner payable public {
        address contractOwner = owner();
        uint balance = address(this).balance;

        (bool sent,) = contractOwner.call{value:balance }(" ");

        require(sent, "Failed to send ethers");
    }

    receive() external payable {}
    fallback() external payable {}
}