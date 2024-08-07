# Solidity API

## MyNFT

### mintPrice

```solidity
uint256 mintPrice
```

### Minted

```solidity
event Minted(uint256 nftId)
```

When successfully minted NFT

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| nftId | uint256 | Unique ID of minted NFT |

### AddressZero

```solidity
error AddressZero()
```

### NotEnoughFunds

```solidity
error NotEnoughFunds(uint256 required, uint256 balance)
```

When there are insufficent funds to mint an NFT

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| required | uint256 | Required funds to mint NFT |
| balance | uint256 | Function caller balance |

### constructor

```solidity
constructor() public
```

### mint

```solidity
function mint() external payable
```

### setMintPrice

```solidity
function setMintPrice(uint256 newPrice) external
```

### withdraw

```solidity
function withdraw() external
```

## Lock

### unlockTime

```solidity
uint256 unlockTime
```

### owner

```solidity
address payable owner
```

### Withdrawal

```solidity
event Withdrawal(uint256 amount, uint256 when)
```

### constructor

```solidity
constructor(uint256 _unlockTime) public payable
```

### withdraw

```solidity
function withdraw() public
```

## Market

### Offer

Structure to represent offer

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |

```solidity
struct Offer {
  uint256 nftId;
  address seller;
  address token;
  uint256 sellPrice;
}
```

### offers

```solidity
mapping(uint256 => struct Market.Offer) offers
```

Mapping from `offer ID` to `offer details`

_The key is a unique identifier for each offer, and a value is an instance of `Offer` struct_

### NFT

```solidity
contract ERC721 NFT
```

### Token

```solidity
contract ERC20 Token
```

### AddressZero

```solidity
error AddressZero()
```

### OfferCreated

```solidity
event OfferCreated(uint256 offerId, uint256 nftId, address seller, uint256 sellPrice)
```

Event emmited when offer created

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| offerId | uint256 | Unique identifier of offer |
| nftId | uint256 | NFT ID |
| seller | address |  |
| sellPrice | uint256 | Selling price in Tokens |

### OfferCanceled

```solidity
event OfferCanceled(uint256 offerId, uint256 nftId, address seller)
```

Event emmited when offer canceled

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| offerId | uint256 | Unique identifier of offer |
| nftId | uint256 | NFT ID |
| seller | address | Addres of seller/offerer |

### TransactionSucceed

```solidity
event TransactionSucceed(uint256 offerId, address buyer, uint256 price)
```

Event emmited when transaction is successful

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| offerId | uint256 | Unique identifier of offer |
| buyer | address | Address of the buyer (completed the transaction) |
| price | uint256 | Transaction at which the offer was completed |

### constructor

```solidity
constructor(address _NFT, address _Token) public
```

Market constructor, requires NFT and Token addres

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _NFT | address | NFT contract address |
| _Token | address | Token contract address |

### createOffer

```solidity
function createOffer(uint256 _nftId, uint256 _sellPrice) external
```

Function to create new offer

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _nftId | uint256 | Id of NFT to offer |
| _sellPrice | uint256 | Price to buy the NFT in Tokens |

### cancelOffer

```solidity
function cancelOffer(uint256 offerId) external
```

Function to cancel offer by offerId

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| offerId | uint256 | Id of offer to cancel |

### buyNFT

```solidity
function buyNFT(uint256 offerId) external payable
```

Function to buy the NFT

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| offerId | uint256 | Offer identifier |

## MyToken

### mintPrice

```solidity
uint256 mintPrice
```

### Minted

```solidity
event Minted(uint256 amount, address reiever)
```

### NotEnoughFunds

```solidity
error NotEnoughFunds(uint256 required, uint256 amount)
```

If there are insufficent funds to mint Tokens

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| required | uint256 | Required funds to mint Tokens |
| amount | uint256 | Function caller balance |

### constructor

```solidity
constructor() public
```

### mint

```solidity
function mint(uint256 amount) external payable
```

### setMintPrice

```solidity
function setMintPrice(uint256 _mintPrice) external
```

### withdraw

```solidity
function withdraw() external
```

