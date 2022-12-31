# GM!

Good Morning.

# Buildspace Polygon DNS Server Hardhat Project

This project demonstrates a basic Hardhat use case. 

Deployed to 
- Mumbai: https://mumbai.polygonscan.com/address/0x8993abe939607677950a0d625F479fea1ce6FAe9#code
- Mainnet: https://polygonscan.com/address/0x42c2AA6CC34355C9F4451DC4c38F32D0Ca3Fc01c#code

GNS (GM Name Service)

Try running some of the following tasks:

Deploy to Polygon Mumbai Testnet:
```shell
npx hardhat run --network polygonMumbai scripts\deploy.ts        
npx hardhat verify --network polygonMumbai <CONTRACT ADDRESS> "gm"
```
Deploy to Polygon Mainnet:
```shell
npx hardhat run --network polygon scripts\deploy.ts        
npx hardhat verify --network polygon <CONTRACT ADDRESS> "gm"
```                               
