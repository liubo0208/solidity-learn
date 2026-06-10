// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract NFTMarket {

    struct Nft {
        uint256 id;
        uint256 price;
        address owner;
        bool forSale;
    }

    uint256 public count;
    uint256[] public saleIds;

    uint public constant ADDRESS_LIMIT = 10; //发布合约的用户列表
    uint public constant MAX_NFT = 10; //每个用户的合约数
    uint public constant MAX_SALE = 100; //在售合约数

    mapping (address => uint256[] ) public ids;
    mapping (uint256 => Nft) public nftInfos;
    
    

    event CreatedNft(address indexed owner, uint256 id);
    event NftOnSale(address indexed owner, uint256 id);
    event NftUnSale(address indexed owner, uint256 id);

    //创建合约
    function creatNft(uint256 price) public returns(address, uint256){
        address owner = msg.sender;
        uint countNft = ids[owner].length;
        require(countNft < MAX_NFT,"owner nft count over limit");

        uint256 id = count++;
        nftInfos[id] = Nft({
            id: id,
            price: price,
            owner: owner,
            forSale: false
        });

        ids[owner].push(id);
        emit CreatedNft(owner,id);

        return(owner,id);
    }
    
    //上架
    function onSale(uint256 id) public returns(address,uint256){
        require(saleIds.length < MAX_SALE,"max sale num over");
        address owner = msg.sender;
        require (nftInfos[id].owner == owner ,"user have no right");
        require (!nftInfos[id].forSale ,"already onsale");

        nftInfos[id].forSale = true;
        saleIds.push(id);

        emit NftOnSale(owner,id);

        return(owner,id);
    }

    //下架
    function unSale(uint256 id) public returns(address,uint256){
        address owner = msg.sender;
        require (nftInfos[id].owner == owner ,"user have no right");
        require (nftInfos[id].forSale ,"already unsale");
        nftInfos[id].forSale = false;
        
        delSaleId(id);
        emit NftUnSale(owner,id);
        return(owner,id);
    }

    function buy(uint256 id, uint256 balance) public returns(address,address,uint256){
        address buyer = msg.sender;
        address owner = nftInfos[id].owner;
        require(buyer != owner, "can not buy your own nft");
        require(nftInfos[id].price < balance, " balance not enough");

        nftInfos[id].forSale = false;
        nftInfos[id].owner = buyer;

        delSaleId(id);
        return(buyer,owner,id);
    }

    function delSaleId(uint256 id) private {
        uint len = saleIds.length;
        for(uint i= 0 ; i < len ;){

            if(saleIds[i] == id){
                saleIds[i] = saleIds[len - 1];
                break;
            }
            unchecked {
                i++;
            }
        }
        saleIds.pop();
    }

    function getAllSale() public view returns(uint,uint256[] memory){

        uint len = saleIds.length;
        return (len,saleIds);
    }
}