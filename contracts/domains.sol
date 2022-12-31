// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

import "./libraries/BaseContract.sol";
import {StringUtils} from "./libraries/StringUtils.sol";
import "@openzeppelin/contracts/utils/Base64.sol";
import "hardhat/console.sol";

// We inherit the contract we imported. This means we'll have access
// to the inherited contract's methods.
contract Domains is BaseContract {
    using Counters for Counters.Counter;
    Counters.Counter public _tokenIdCounter;
    string public tld;
    
    // We'll be storing our NFT images on chain as SVGs
    string svgPartOne =
        '<svg xmlns="http://www.w3.org/2000/svg" width="270" height="270" fill="none"><path fill="url(#B)" d="M0 0h270v270H0z"/><defs><filter id="A" color-interpolation-filters="sRGB" filterUnits="userSpaceOnUse" height="270" width="270"><feDropShadow dx="0" dy="1" stdDeviation="2" flood-opacity=".225" width="200%" height="200%"/></filter></defs><path d="M72.863 42.949c-.668-.387-1.426-.59-2.197-.59s-1.529.204-2.197.59l-10.081 6.032-6.85 3.934-10.081 6.032c-.668.387-1.426.59-2.197.59s-1.529-.204-2.197-.59l-8.013-4.721a4.52 4.52 0 0 1-1.589-1.616c-.384-.665-.594-1.418-.608-2.187v-9.31c-.013-.775.185-1.538.572-2.208a4.25 4.25 0 0 1 1.625-1.595l7.884-4.59c.668-.387 1.426-.59 2.197-.59s1.529.204 2.197.59l7.884 4.59a4.52 4.52 0 0 1 1.589 1.616c.384.665.594 1.418.608 2.187v6.032l6.85-4.065v-6.032c.013-.775-.185-1.538-.572-2.208a4.25 4.25 0 0 0-1.625-1.595L41.456 24.59c-.668-.387-1.426-.59-2.197-.59s-1.529.204-2.197.59l-14.864 8.655a4.25 4.25 0 0 0-1.625 1.595c-.387.67-.585 1.434-.572 2.208v17.441c-.013.775.185 1.538.572 2.208a4.25 4.25 0 0 0 1.625 1.595l14.864 8.655c.668.387 1.426.59 2.197.59s1.529-.204 2.197-.59l10.081-5.901 6.85-4.065 10.081-5.901c.668-.387 1.426-.59 2.197-.59s1.529.204 2.197.59l7.884 4.59a4.52 4.52 0 0 1 1.589 1.616c.384.665.594 1.418.608 2.187v9.311c.013.775-.185 1.538-.572 2.208a4.25 4.25 0 0 1-1.625 1.595l-7.884 4.721c-.668.387-1.426.59-2.197.59s-1.529-.204-2.197-.59l-7.884-4.59a4.52 4.52 0 0 1-1.589-1.616c-.385-.665-.594-1.418-.608-2.187v-6.032l-6.85 4.065v6.032c-.013.775.185 1.538.572 2.208a4.25 4.25 0 0 0 1.625 1.595l14.864 8.655c.668.387 1.426.59 2.197.59s1.529-.204 2.197-.59l14.864-8.655c.657-.394 1.204-.95 1.589-1.616s.594-1.418.609-2.187V55.538c.013-.775-.185-1.538-.572-2.208a4.25 4.25 0 0 0-1.625-1.595l-14.993-8.786z" fill="#fff"/><defs><linearGradient id="B" x1="0" y1="0" x2="270" y2="270" gradientUnits="userSpaceOnUse"><stop stop-color="#cb5eee"/><stop offset="1" stop-color="#0cd7e4" stop-opacity=".99"/></linearGradient></defs><text x="32.5" y="231" font-size="27" fill="#fff" filter="url(#A)" font-family="Plus Jakarta Sans,DejaVu Sans,Noto Color Emoji,Apple Color Emoji,sans-serif" font-weight="bold">';
    string svgPartTwo = "</text></svg>";

    mapping(string => address) public domains;
    mapping(string => string) public records;
    mapping(uint => string) public names;

    error Unauthorized();
    error AlreadyRegistered();

    constructor(string memory _tld) {
        _tokenIdCounter.increment();
        tld = _tld;
    }

    function valid(string calldata _name) public pure returns(bool) {
      return StringUtils.strlen(_name) >= 3 && StringUtils.strlen(_name) <= 10;
    }

    function price(string calldata _name) public pure returns (uint) {
        uint len = StringUtils.strlen(_name);
        require(len > 0, "Domain name must be at least 1 character");
        if (len == 3) {
            return 5 * 10 ** 17; // 0.5 MATIC
        } else if (len == 4) {
            return 3 * 10 ** 17; // 0.3 MATIC
        } else {
            return 1 * 10 ** 17; // 0.1 MATIC
        }
    }

    function getAllNames() public view returns (string[] memory) {
        console.log("Getting all names from contract");
        string[] memory allNames = new string[](_tokenIdCounter.current());
        for (uint i = 0; i < _tokenIdCounter.current(); i++) {
            allNames[i] = names[i];
            console.log("Name for token %d is %s", i, allNames[i]);
        }

        return allNames;
    }

    function getAddress(string calldata _name) public view returns (address) {
        return domains[_name];
    }

    function setRecord(string calldata _name, string calldata record) public {
        if (msg.sender != domains[_name]) revert Unauthorized();
        records[_name] = record;
    }

    function getRecord(string calldata _name) public view returns (string memory) {
      return records[_name];
    }

    function register(string calldata _name) public payable {
        if (domains[_name] != address(0)) revert AlreadyRegistered();

        uint256 _price = price(_name);
        require(msg.value >= _price, "Not enough Matic paid");

        // Combine the name passed into the function  with the TLD
        string memory _finalName = string(abi.encodePacked(_name, ".", tld));

        // Create the SVG (image) for the NFT with the name
        string memory finalSvg = string(
            abi.encodePacked(svgPartOne, _finalName, svgPartTwo)
        );
        uint256 newTokenId = _tokenIdCounter.current();
        uint256 length = StringUtils.strlen(_finalName);
        string memory strLen = Strings.toString(length);

        console.log(
            "Registering %s on the contract with tokenID %d",
            _finalName,
            newTokenId
        );

        // Create the JSON metadata of our NFT. We do this by combining strings and encoding as base64
        string memory json = Base64.encode(
            abi.encodePacked(
                '{"name": "',
                _name,
                '", "description": "A domain on the GM name service", "image": "data:image/svg+xml;base64,',
                Base64.encode(bytes(finalSvg)),
                '","length":"',
                strLen,
                '"}'
            )
        );

        string memory finalTokenUri = string(
            abi.encodePacked("data:application/json;base64,", json)
        );

        console.log(
            "\n--------------------------------------------------------"
        );
        console.log("Final tokenURI", finalTokenUri);
        console.log(
            "--------------------------------------------------------\n"
        );

        // Mint the NFT to newRecordId
        _safeMint(msg.sender, newTokenId);

        // Set the NFTs data -- in this case the JSON blob w/ our domain's info!
        _setTokenURI(newTokenId, finalTokenUri);

        console.log("Minted NFT w/ tokenID %s", newTokenId);

        domains[_name] = msg.sender;
        names[newTokenId] = _name;
        _tokenIdCounter.increment();
    }
}
