// SPDX-License-Identifier: CC0

// $FDM                                   |
//                                      \ _ /
//                                    -= (_) =-
//   .\/.                               /   \
// .\\//o\\                     ,\/.      |               ,~
// //o\\|,\/.   ,.,.,   ,\/.  ,\//o\\                     |\
//   |  |//o\  /###/#\  //o\  /o\\|                      /| \
// ^^|^^|^~|^^^|' '|:|^^^|^^^^^|^^|^^^""""""""("~~~~~~~~/_|__\~~~~~~~~~~
//  .|'' . |  '''""'"''. |`===`|''  '"" "" " (" ~~~~ ~ ~======~~  ~~ ~
// ^^^^^   ^^^ ^ ^^^ ^^^^ ^^^ ^^ ^^ "" """( " ~~~~~~ ~~~~~  ~~~ ~

pragma solidity ^0.8.4;

//import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "./@rarible/royalties/contracts/impl/RoyaltiesV2Impl.sol"; 
import "./@rarible/royalties/contracts/LibPart.sol";
import "./@rarible/royalties/contracts/LibRoyaltiesV2.sol";

contract fdmKey is ERC721Enumerable, Pausable, Ownable, RoyaltiesV2Impl  {

    using Counters for Counters.Counter;
    Counters.Counter private _TokenId;
    uint public constant MAX_SUPPLY = 128;

    bytes4 private constant _INTERFACE_ID_ERC2981 = 0x2a55205a;
    constructor() ERC721("Super Ancient Key of Super Duper Dopeness","FKEYA") {}

//Mint Function
    function mint(address _to) public onlyOwner {
        super._mint(_to,_TokenId.current());
        _TokenId.increment();
        //Define Total Supply
        
    }

//Royalty Functions for NoFud Games

    function setRoyalties(uint _tokenId, address payable _royaltiesReceipientAddress, uint96 _percentageBasisPoints) public onlyOwner {
    LibPart.Part[] memory _royalties = new LibPart.Part[](1);
    _royalties[0].value = _percentageBasisPoints;
    _royalties[0].account = _royaltiesReceipientAddress;
    _saveRoyalties(_tokenId, _royalties);
    }
    function royaltyInfo(uint256 _tokenId, uint256 _salePrice) external view returns (address receiver, uint256 royaltyAmount) {
        LibPart.Part[] memory _royalties = royalties[_tokenId];
        if(_royalties.length > 0) {
            return (_royalties[0].account, (_salePrice * _royalties[0].value)/10000);
        }
        return (address(0), 0);
    }
    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721Enumerable) returns (bool) {
        if(interfaceId == LibRoyaltiesV2._INTERFACE_ID_ROYALTIES) {
            return true;
        }
        if(interfaceId == _INTERFACE_ID_ERC2981) {
            return true;
        }
        return super.supportsInterface(interfaceId);
    } 

//Pausable Code - For NoFudGames Admin Purposes
    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }

    function _beforeTokenTransfer(address from, address to, uint256 tokenId)
        internal
        whenNotPaused
        override
    {
        super._beforeTokenTransfer(from, to, tokenId);
    }

// Base URI for Image + Metadata
   /* function _baseURI() internal view virtual override returns (string memory) {
        return "ipfs://bafkreifw4grmixodhtiux2i25ocoeiwaspseme7gcuilsqlntedl5n3bi4";
    }*/
    function setTokenURI(uint256 tokenId, string memory metadataURI)
    public
    {
        setTokenURI(tokenId, metadataURI);
    }

//Expose NFT to FDM.land for Utility 
    function tokensOfOwner(address _owner) 
         external 
         view 
         returns (uint[] memory) {
     uint tokenCount = balanceOf(_owner);
     uint[] memory tokensId = new uint256[](tokenCount);
     for (uint i = 0; i < tokenCount; i++) {
          tokensId[i] = tokenOfOwnerByIndex(_owner, i);
     }

     return tokensId;
    }
} 