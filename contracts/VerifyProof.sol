//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";
import "contracts/SignedHeader.sol";

contract VerifyProof {
    constructor() {
    }

	bool private ret;

	function verify(bytes memory simpleProof,
					bytes memory wasmProof,
					string memory path,
					bytes memory key,
					bytes memory value,
					address _addr) public {
		SignedHeader header = SignedHeader(_addr);
		bytes memory appHash = abi.encodePacked(header.getAppHashBytes());

		bytes memory data = abi.encode(simpleProof, wasmProof, bytes(path), key, value, appHash);

		(ret, ) = address(0x14).call(data);
	}

	function getRet() public view returns (bool) {
		return ret;
	}
}
