// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.18;

import "forge-std/console.sol";

contract Yul1 {
    /// @dev Simple Add operation
    function add(uint256 x, uint256 y) public pure returns (uint256 z) {
        assembly {
            z := add(x, y)
        }
    }

    /// @dev Simple Sub operation
    function sub(uint256 x, uint256 y) public pure returns (uint256 z) {
        assembly {
            if gt(y, x) { z := sub(y, x) }
            if gt(x, y) { z := sub(x, y) }
        }
    }

    /// @dev Simple Add & then Mul operation
    function addMul(uint256 x, uint256 y) public pure returns (uint256 z) {
        assembly {
            z := mul(add(x, y), 7)
        }
    }

    /// @dev Simple Add & then Div operation
    function addDiv(uint256 x, uint256 y) public pure returns (uint256 z) {
        assembly {
            z := div(add(x, y), 7)
        }
    }

    // TODO:
    // - Add log, pow, and other arithmetic operations ??
    // - Here, add(), sub() internal functions can be used inside addMul, addDiv ??
}
