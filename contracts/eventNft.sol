// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
contract eventNft is ERC721URIStorage, Ownable{
    uint256 public nexttokenId;
    address public eventManager;

    constructor(address _address) ERC721("eventNft", "ENFT") Ownable(msg.sender){
        
    }

     function claimNFT(string memory tokenURI) public {
        uint256 tokenId = nexttokenId;
        _safeMint(msg.sender, tokenId);
        _setTokenURI(tokenId, tokenURI);
        nexttokenId++;
    }

    
    function setEventManager(address _eventManager) external onlyOwner {
        eventManager = _eventManager;
    }


}