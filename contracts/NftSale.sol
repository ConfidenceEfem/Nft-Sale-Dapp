//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./WhiteListInterface.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";

contract NftSale is ERC721Enumerable, Ownable{
    WhiteListInterface whiteList;

    uint256 public tokenId;

    string baseTokenURI;

    bool public paused;

    uint public maxTokenIds = 20;

    uint public presaleEnded;

    bool public presaleStarted;

    uint public NFTprice = 0.01 ether;


    constructor(string memory _baseURI, address whiteListContract) ERC721 ("CryptoDev", "CDE") {
            baseTokenURI = _baseURI;
            whiteList = WhiteListInterface(whiteListContract);
    }

    modifier onlyWhenPaused {
        require(!paused, "Contract currently paused");

        _;
    }

    function startPresale() public {
             presaleStarted = true;
            
            presaleEnded = block.timestamp + 5 minutes;
    }

    function preSaleMint() public payable onlyWhenPaused{
            require(presaleStarted, "Presale hasn't started");
            require(presaleEnded >= block.timestamp, "Presale time hasn't reached");
                 require(whiteList.whiteListAddress(msg.sender), "you are not on the waitlist");
            require(tokenId <= maxTokenIds, "Maximum crypto dev supply exceeded");
            require(msg.value >= NFTprice, "Incorrect amount, Please input correct amount");

            tokenId += 1;

            _safeMint(msg.sender, tokenId);
    }


    function saleMint() public payable onlyWhenPaused{
        require(presaleStarted, "Presale hasn't started");
        require(presaleEnded <= block.timestamp, "Presale is still running");
        require(tokenId <= maxTokenIds, "Maximum crypto dev supply exceeded");
        require(NFTprice <= msg.value, "Incorrect Price, please send the correct ethers");

        tokenId += 1;

        _safeMint(msg.sender, tokenId);
    }

    function setPaused(bool val) public onlyOwner{
            paused = val;
    }


    // function withdrawEthers() public onlyOwner {
    //     address _owner = owner();

    //     uint256 amount = address(this).balance;

    //     (bool sent,) = _owner.call{value: amount}("");

    //     require(sent, "Failed to send ether");
    // }

    // receive() external payable{}

    // fallback() external payable{}


}