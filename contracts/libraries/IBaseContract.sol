// SPDX-License-Identifier: MIT
// BaseContract smart contract v1.0

pragma solidity ^0.8.9;

interface IBaseContract {
  function safeMint(address to) external;
  function _baseURI() external view returns (string memory);
  function _burn(uint256 tokenId) external;
  function _beforeTokenTransfer(address from, address to, uint256 tokenId, uint256 batchSize) external;
  function renounceOwnership() external;
  function setBaseURI(string memory newBaseTokenURI) external;
  function setMintPrice(uint256 newMintPrice) external;
  function setMaxMintAmount(uint256 newMaxMintAmount) external;
  function setIsPaused(bool state) external;
  function supportsInterface(bytes4 interfaceId) external view returns (bool);
  function tokenURI(uint256 tokenId) external view returns (string memory);
  function withdraw() external;
  function withdrawToken(address tokenContractAddress, uint256 amount)
}