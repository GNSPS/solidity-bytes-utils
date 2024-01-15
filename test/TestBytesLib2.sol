// SPDX-License-Identifier: Unlicense
pragma solidity >=0.8.0 <0.9.0;

import "forge-std/Test.sol";
import "../contracts/AssertBytes.sol";
import "../contracts/BytesLib.sol";


contract TestBytesLib2 is Test {
    using BytesLib for bytes;

    bytes storageCheckBytes = hex"aabbccddeeff";
    bytes storageCheckBytesZeroLength = hex"";
    
    uint256 constant MAX_UINT = type(uint256).max;

    /**
    * Sanity Checks
    */

    function testSanityCheck() public {
        // Assert library sanity checks
        //
        // Please don't change the ordering of the var definitions
        // the order is purposeful for testing zero-length arrays
        bytes memory checkBytes = hex"aabbccddeeff";
        bytes memory checkBytesZeroLength = hex"";

        bytes memory checkBytesRight = hex"aabbccddeeff";
        bytes memory checkBytesZeroLengthRight = hex"";
        bytes memory checkBytesWrongLength = hex"aa0000";
        bytes memory checkBytesWrongContent = hex"aabbccddee00";

        assertEq(checkBytes, checkBytesRight, "Sanity check should be checking equal bytes arrays out.");
        assertTrue(keccak256(checkBytes) != keccak256(checkBytesWrongLength), "Sanity check should be checking different length bytes arrays out.");
        assertTrue(keccak256(checkBytes) != keccak256(checkBytesWrongContent), "Sanity check should be checking different content bytes arrays out.");
        AssertBytes.equal(checkBytes, checkBytesRight, "Sanity check should be checking equal bytes arrays out.");
        AssertBytes.notEqual(checkBytes, checkBytesWrongLength, "Sanity check should be checking different length bytes arrays out.");
        AssertBytes.notEqual(checkBytes, checkBytesWrongContent, "Sanity check should be checking different content bytes arrays out.");

        assertEq(storageCheckBytes, checkBytesRight, "Sanity check should be checking equal bytes arrays out. (Storage)");
        assertTrue(keccak256(storageCheckBytes) != keccak256(checkBytesWrongLength), "Sanity check should be checking different length bytes arrays out. (Storage)");
        assertTrue(keccak256(storageCheckBytes) != keccak256(checkBytesWrongContent), "Sanity check should be checking different content bytes arrays out. (Storage)");
AssertBytes.equalStorage(storageCheckBytes, checkBytesRight, "Sanity check should be checking equal bytes arrays out. (Storage)");
        AssertBytes.notEqualStorage(storageCheckBytes, checkBytesWrongLength, "Sanity check should be checking different length bytes arrays out. (Storage)");
        AssertBytes.notEqualStorage(storageCheckBytes, checkBytesWrongContent, "Sanity check should be checking different content bytes arrays out. (Storage)");

        // Zero-length checks
        assertEq(checkBytesZeroLength, checkBytesZeroLengthRight, "Sanity check should be checking equal zero-length bytes arrays out.");
        assertTrue(keccak256(checkBytesZeroLength) != keccak256(checkBytes), "Sanity check should be checking different length bytes arrays out.");
AssertBytes.equal(checkBytesZeroLength, checkBytesZeroLengthRight, "Sanity check should be checking equal zero-length bytes arrays out.");
        AssertBytes.notEqual(checkBytesZeroLength, checkBytes, "Sanity check should be checking different length bytes arrays out.");

        AssertBytes.equalStorage(storageCheckBytesZeroLength, checkBytesZeroLengthRight, "Sanity check should be checking equal zero-length bytes arrays out. (Storage)");
        AssertBytes.notEqualStorage(storageCheckBytesZeroLength, checkBytes, "Sanity check should be checking different length bytes arrays out. (Storage)");
    }

    /**
    * Slice Tests
    */

    function testSlice() public {
        bytes memory memBytes = hex"f00d0000000000000000000000000000000000000000000000000000000000feedf00d00000000000000000000000000000000000000000000000000000000feed";

        bytes memory testBytes;
        bytes memory resultBytes;

        testBytes = hex"f00d";
        resultBytes = memBytes.slice(0,2);
        assertEq(resultBytes, testBytes);
        AssertBytes.equal(resultBytes, testBytes, "Normal slicing array failed.");

        testBytes = hex"";
        resultBytes = memBytes.slice(1,0);
        assertEq(resultBytes, testBytes);
        AssertBytes.equal(resultBytes, testBytes, "Slicing with zero-length failed.");

        testBytes = hex"";
        resultBytes = memBytes.slice(0,0);
        assertEq(resultBytes, testBytes);
        AssertBytes.equal(resultBytes, testBytes, "Slicing with zero-length on index 0 failed.");

        testBytes = hex"feed";
        resultBytes = memBytes.slice(31,2);
        assertEq(resultBytes, testBytes);
        AssertBytes.equal(resultBytes, testBytes, "Slicing across the 32-byte slot boundary failed.");

        testBytes = hex"f00d0000000000000000000000000000000000000000000000000000000000feed";
        resultBytes = memBytes.slice(0,33);
        assertEq(resultBytes, testBytes);
        AssertBytes.equal(resultBytes, testBytes, "Full length slice failed.");

        testBytes = hex"f00d0000000000000000000000000000000000000000000000000000000000fe";
        resultBytes = memBytes.slice(0,32);
        assertEq(resultBytes, testBytes);
        AssertBytes.equal(resultBytes, testBytes, "Multiple of 32 bytes slice failed.");

        testBytes = hex"f00d0000000000000000000000000000000000000000000000000000000000feedf00d00000000000000000000000000000000000000000000000000000000fe";
        resultBytes = memBytes.slice(0,64);
        assertEq(resultBytes, testBytes);
        AssertBytes.equal(resultBytes, testBytes, "Multiple (*2) of 32 bytes slice failed.");

        // With v0.5.x we can now entirely replace the ThrowProxy patterns that was creating issues with the js-vm
        // and use an external call to our own contract with the function selector, since Solidity now gives us
        // access to those
        bool r;

        // We're basically calling our contract externally with a raw call, forwarding all available gas, with
        // msg.data equal to the throwing function selector that we want to be sure throws and using only the boolean
        // value associated with the message call's success
        (r, ) = address(this).call(abi.encodePacked(this.sliceIndexThrow.selector));
        assertFalse(r);

        (r, ) = address(this).call(abi.encodePacked(this.sliceOverflowLength0Throw.selector));
        assertFalse(r);

        (r, ) = address(this).call(abi.encodePacked(this.sliceOverflowLength1Throw.selector));
        assertFalse(r);

        (r, ) = address(this).call(abi.encodePacked(this.sliceOverflowLength33Throw.selector));
        assertFalse(r);

        (r, ) = address(this).call(abi.encodePacked(this.sliceOverflowLengthMinus32Throw.selector));
        assertFalse(r);

        (r, ) = address(this).call(abi.encodePacked(this.sliceOverflowStart0Throw.selector));
        assertFalse(r);

        (r, ) = address(this).call(abi.encodePacked(this.sliceOverflowStart1Throw.selector));
        assertFalse(r);

        (r, ) = address(this).call(abi.encodePacked(this.sliceOverflowStart33Throw.selector));
        assertFalse(r);

        (r, ) = address(this).call(abi.encodePacked(this.sliceLengthThrow.selector));
        assertFalse(r);
    }

    function sliceIndexThrow() public pure {
        bytes memory memBytes33 = hex"f00d0000000000000000000000000000000000000000000000000000000000feed";

        bytes memory testBytes;
        bytes memory resultBytes;

        testBytes = hex"f00d";
        resultBytes = memBytes33.slice(34,2);
        // This should throw;
    }

    function sliceLengthThrow() public pure {
        bytes memory memBytes33 = hex"f00d0000000000000000000000000000000000000000000000000000000000feed";

        bytes memory testBytes;
        bytes memory resultBytes;

        testBytes = hex"f00d";
        resultBytes = memBytes33.slice(0,34);
        // This should throw;
    }

    function sliceOverflowLength0Throw() public pure {
        bytes memory memBytes33 = hex"f00d0000000000000000000000000000000000000000000000000000000000feed";

        bytes memory testBytes;
        bytes memory resultBytes;

        testBytes = hex"f00d";
        resultBytes = memBytes33.slice(0, MAX_UINT);
        // This should throw;
    }

    function sliceOverflowLength1Throw() public pure {
        bytes memory memBytes33 = hex"f00d0000000000000000000000000000000000000000000000000000000000feed";

        bytes memory testBytes;
        bytes memory resultBytes;

        testBytes = hex"f00d";
        resultBytes = memBytes33.slice(1, MAX_UINT);
        // This should throw;
    }

    function sliceOverflowLength33Throw() public pure {
        bytes memory memBytes33 = hex"f00d0000000000000000000000000000000000000000000000000000000000feed";

        bytes memory testBytes;
        bytes memory resultBytes;

        testBytes = hex"f00d";
        resultBytes = memBytes33.slice(33, MAX_UINT);
        // This should throw;
    }

    function sliceOverflowLengthMinus32Throw() public pure {
        bytes memory memBytes33 = hex"f00d0000000000000000000000000000000000000000000000000000000000feed";

        bytes memory testBytes;
        bytes memory resultBytes;

        testBytes = hex"f00d";
        resultBytes = memBytes33.slice(1, MAX_UINT - 32);
        // This should throw;
    }

    function sliceOverflowStart0Throw() public pure {
        bytes memory memBytes33 = hex"f00d0000000000000000000000000000000000000000000000000000000000feed";

        bytes memory testBytes;
        bytes memory resultBytes;

        testBytes = hex"f00d";
        resultBytes = memBytes33.slice(MAX_UINT, 0);
        // This should throw;
    }

    function sliceOverflowStart1Throw() public pure {
        bytes memory memBytes33 = hex"f00d0000000000000000000000000000000000000000000000000000000000feed";

        bytes memory testBytes;
        bytes memory resultBytes;

        testBytes = hex"f00d";
        resultBytes = memBytes33.slice(MAX_UINT, 1);
        // This should throw;
    }

    function sliceOverflowStart33Throw() public pure {
        bytes memory memBytes33 = hex"f00d0000000000000000000000000000000000000000000000000000000000feed";

        bytes memory testBytes;
        bytes memory resultBytes;

        testBytes = hex"f00d";
        resultBytes = memBytes33.slice(MAX_UINT, 1);
        // This should throw;
    }

    /**
    * Memory Integrity Checks
    */

    function testMemoryIntegrityCheckZeroLengthSlice() public {
        // Let's taint memory first
        bytes memory taintBytes4 = hex"f00dfeed";

        // Now declare arrays to be sliced
        bytes memory testBytes4 = hex"f00dfeed";
        bytes memory emptyBytes = hex"";

        bytes memory resultBytes;

        // Try a zero-length slice from a non-zero-length array
        resultBytes = testBytes4.slice(0,0);

        assertEq(hex"", resultBytes);
        AssertBytes.equal(hex"", resultBytes, "The result of a zero-length slice is not a zero-length array.");

        // Try a zero-length slice from a zero-length array
        resultBytes = emptyBytes.slice(0,0);

        assertEq(hex"", resultBytes);
        AssertBytes.equal(hex"", resultBytes, "The result of a zero-length slice is not a zero-length array.");
    }
    
    /**
    * Type casting Checks
    */

    function testToUint8() public {
        bytes memory memBytes = hex"f00d20feed";

        uint8 testUint8 = 32; // 0x20 == 32
        uint8 resultUint8;

        resultUint8 = memBytes.toUint8(2);
        assertEq(uint256(resultUint8), uint256(testUint8));

        // Testing for the throw conditions below
        (bool r, ) = address(this).call(abi.encodePacked(this.toUint8Throw.selector));
        assertFalse(r);
    }

    function toUint8Throw() public pure {
        bytes memory memBytes = hex"f00d42feed";

        uint8 resultUint8;

        resultUint8 = memBytes.toUint8(35);
        // This should throw;
    }

    function testToUint16() public {
        bytes memory memBytes = hex"f00d0020feed";

        uint16 testUint16 = 32; // 0x20 == 32
        uint16 resultUint16;

        resultUint16 = memBytes.toUint16(2);
        assertEq(uint256(resultUint16), uint256(testUint16));

        // Testing for the throw conditions below
        (bool r, ) = address(this).call(abi.encodePacked(this.toUint16Throw.selector));
        assertFalse(r);
    }

    function toUint16Throw() public pure {
        bytes memory memBytes = hex"f00d0042feed";

        uint16 resultUint16;

        resultUint16 = memBytes.toUint16(35);
        // This should throw;
    }

    function testToUint32() public {
        bytes memory memBytes = hex"f00d00000020feed";

        uint32 testUint32 = 32; // 0x20 == 32
        uint32 resultUint32;

        resultUint32 = memBytes.toUint32(2);
        assertEq(uint256(resultUint32), uint256(testUint32));

        // Testing for the throw conditions below
        (bool r, ) = address(this).call(abi.encodePacked(this.toUint32Throw.selector));
        assertFalse(r);
    }

    function toUint32Throw() public pure {
        bytes memory memBytes = hex"f00d00000042feed";

        uint32 resultUint32;

        resultUint32 = memBytes.toUint32(35);
        // This should throw;
    }

    function testToUint64() public {
        bytes memory memBytes = hex"f00d0000000000000020feed";

        uint64 testUint64 = 32; // 0x20 == 32
        uint64 resultUint64;

        resultUint64 = memBytes.toUint64(2);
        assertEq(uint256(resultUint64), uint256(testUint64));

        // Testing for the throw conditions below
        (bool r, ) = address(this).call(abi.encodePacked(this.toUint64Throw.selector));
        assertFalse(r);
    }

    function toUint64Throw() public pure {
        bytes memory memBytes = hex"f00d42feed";

        uint64 resultUint64;

        resultUint64 = memBytes.toUint64(35);  // This should throw;
    }

    function testToUint96() public {
        bytes memory memBytes = hex"f00d000000000000000000000020feed";

        uint96 testUint96 = 32; // 0x20 == 32
        uint96 resultUint96;

        resultUint96 = memBytes.toUint96(2);
        assertEq(uint256(resultUint96), uint256(testUint96));

        // Testing for the throw conditions below
        (bool r, ) = address(this).call(abi.encodePacked(this.toUint64Throw.selector));
        assertFalse(r);
    }

    function toUint96Throw() public pure {
        bytes memory memBytes = hex"f00d42feed";

        uint96 resultUint96;

        resultUint96 = memBytes.toUint96(35);  // This should throw;
    }

    function testToUint128() public {
        bytes memory memBytes = hex"f00d00000000000000000000000000000020feed";

        uint128 testUint128 = 32; // 0x20 == 32
        uint128 resultUint128;

        resultUint128 = memBytes.toUint128(2);
        assertEq(uint256(resultUint128), uint256(testUint128));

        // Testing for the throw conditions below
        (bool r, ) = address(this).call(abi.encodePacked(this.toUint128Throw.selector));
        assertFalse(r);
    }

    function toUint128Throw() public pure {
        bytes memory memBytes = hex"f00d42feed";

        uint128 resultUint128;

        resultUint128 = memBytes.toUint128(35);  // This should throw;
    }

    function testToUint() public {
        bytes memory memBytes = hex"f00d0000000000000000000000000000000000000000000000000000000000000020feed";

        uint256 testUint = 32; // 0x20 == 32
        uint256 resultUint;

        resultUint = memBytes.toUint256(2);
        assertEq(resultUint, testUint);

        // Testing for the throw conditions below
        (bool r, ) = address(this).call(abi.encodePacked(this.toUintThrow.selector));
        assertFalse(r);
    }

    function toUintThrow() public pure {
        bytes memory memBytes = hex"f00d0000000000000000000000000000000000000000000000000000000000000042feed";

        uint256 resultUint;

        resultUint = memBytes.toUint256(35);
        // This should throw;
    }

    function testToAddress() public {
        bytes memory memBytes = hex"f00dfeed383Fa3B60f9B4AB7fBf6835d3c26C3765cD2B2e2f00dfeed";

        address testAddress = 0x383Fa3B60f9B4AB7fBf6835d3c26C3765cD2B2e2;
        address resultAddress;

        resultAddress = memBytes.toAddress(4);
        assertEq(resultAddress, testAddress);

        // Testing for the throw conditions below
        (bool r, ) = address(this).call(abi.encodePacked(this.toAddressThrow.selector));
        assertFalse(r);
    }

    function toAddressThrow() public pure {
        bytes memory memBytes = hex"f00dfeed383FA3b60F9b4ab7FBF6835D3c26C3765Cd2B2E2f00dfeed";

        address resultAddress;

        resultAddress = memBytes.toAddress(35);
        // This should throw;
    }
}
