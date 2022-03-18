//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract SignedHeader {
	bytes private signed;
	string private appHash;
	bytes32 private appHashBytes;
	string private bnHash;
	uint256 private blockNumber;

    constructor() {
    }
	
	function toHex16 (bytes16 data) internal pure returns (bytes32 result) {
        result = bytes32 (data) & 0xFFFFFFFFFFFFFFFF000000000000000000000000000000000000000000000000 |
              (bytes32 (data) & 0x0000000000000000FFFFFFFFFFFFFFFF00000000000000000000000000000000) >> 64;
        result = result & 0xFFFFFFFF000000000000000000000000FFFFFFFF000000000000000000000000 |
              (result & 0x00000000FFFFFFFF000000000000000000000000FFFFFFFF0000000000000000) >> 32;
        result = result & 0xFFFF000000000000FFFF000000000000FFFF000000000000FFFF000000000000 |
              (result & 0x0000FFFF000000000000FFFF000000000000FFFF000000000000FFFF00000000) >> 16;
        result = result & 0xFF000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000 |
              (result & 0x00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000) >> 8;
        result = (result & 0xF000F000F000F000F000F000F000F000F000F000F000F000F000F000F000F000) >> 4 |
              (result & 0x0F000F000F000F000F000F000F000F000F000F000F000F000F000F000F000F00) >> 8;
        result = bytes32 (0x3030303030303030303030303030303030303030303030303030303030303030 +
               uint256 (result) +
               (uint256 (result) + 0x0606060606060606060606060606060606060606060606060606060606060606 >> 4 &
               0x0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F) * 7);
    }
    
    function toHex (bytes32 data) public pure returns (string memory) {
        return string (abi.encodePacked ("0x", toHex16 (bytes16 (data)), toHex16 (bytes16 (data << 128))));
    }

    function sign(bytes memory data) public {
		bytes32[2] memory output;
		uint256 length = data.length;
		console.log("Sign Length %d", data.length);

		uint256 bn;
		assembly {
			if iszero(call(0, 0x13, 0, add(data, 32), length, output, 0x40)) {
				revert(0, 0)
			}
			bn := mload(output)
		}

		blockNumber = bn;
		bnHash = toHex(output[0]);
		appHash = toHex(output[1]);
		appHashBytes = output[1];
    }

	function getSigned() public view returns (string memory) {
		return string(signed);
	}

	function getBlockNumber() public view returns (uint256) {
		return blockNumber;
	}

	function getAppHash() public view returns (string memory) {
		return appHash;
	}

	function getAppHashBytes() public view returns (bytes32) {
		return appHashBytes;
	}

	function getBnHash() public view returns (string memory) {
		return bnHash;
	}
}
