// SPDX-License-Identifier: Unlicense
pragma solidity >=0.8.0 <0.9.0;

import "forge-std/Test.sol";
import "../contracts/AssertBytes.sol";
import "../contracts/BytesLib.sol";


contract TestBytesLib1 is Test {
    using BytesLib for bytes;

    bytes storageCheckBytes = hex"aabbccddeeff";
    bytes storageCheckBytesZeroLength = hex"";

    bytes storageBytes4 = hex"f00dfeed";
    bytes storageBytes31 = hex"f00d000000000000000000000000000000000000000000000000000000feed";
    bytes storageBytes32 = hex"f00d00000000000000000000000000000000000000000000000000000000feed";
    bytes storageBytes33 = hex"f00d0000000000000000000000000000000000000000000000000000000000feed";
    bytes storageBytes63 = hex"f00d0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000feed";
    bytes storageBytes64 = hex"f00d000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000feed";
    bytes storageBytes65 = hex"f00d00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000feed";
    bytes storageBytes70 = hex"f00d000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000feed";

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

        assertEq(storageCheckBytesZeroLength, checkBytesZeroLengthRight, "Sanity check should be checking equal zero-length bytes arrays out. (Storage)");
        assertTrue(keccak256(storageCheckBytesZeroLength) != keccak256(checkBytes), "Sanity check should be checking different length bytes arrays out. (Storage)");
        AssertBytes.equalStorage(storageCheckBytesZeroLength, checkBytesZeroLengthRight, "Sanity check should be checking equal zero-length bytes arrays out. (Storage)");
        AssertBytes.notEqualStorage(storageCheckBytesZeroLength, checkBytes, "Sanity check should be checking different length bytes arrays out. (Storage)");
    }

    /**
    * Memory Integrity Checks
    */

    function testMemoryIntegrityCheck4Bytes() public {
        bytes memory preBytes4 = hex"f00dfeed";
        bytes memory postBytes4 = hex"f00dfeed";
        bytes memory postBytes31 = hex"f00d000000000000000000000000000000000000000000000000000000feed";
        bytes memory postBytes32 = hex"f00d00000000000000000000000000000000000000000000000000000000feed";
        bytes memory postBytes33 = hex"f00d0000000000000000000000000000000000000000000000000000000000feed";

        bytes memory testBytes;
        bytes memory resultBytes;

        resultBytes = preBytes4.concat(postBytes4);

        // Now we should make sure that all the other previously initialized arrays stayed the same
        testBytes = hex"f00dfeed";
        assertEq(preBytes4, testBytes, "After a postBytes4 concat the preBytes4 integrity check failed.");
        assertEq(postBytes4, testBytes, "After a postBytes4 concat the postBytes4 integrity check failed.");
        AssertBytes.equal(preBytes4, testBytes, "After a postBytes4 concat the preBytes4 integrity check failed.");
        AssertBytes.equal(postBytes4, testBytes, "After a postBytes4 concat the postBytes4 integrity check failed.");
        testBytes = hex"f00d000000000000000000000000000000000000000000000000000000feed";
        assertEq(postBytes31, testBytes, "After a postBytes4 concat the postBytes31 integrity check failed.");
        AssertBytes.equal(postBytes31, testBytes, "After a postBytes4 concat the postBytes31 integrity check failed.");
        testBytes = hex"f00d00000000000000000000000000000000000000000000000000000000feed";
        assertEq(postBytes32, testBytes, "After a postBytes4 concat the postBytes32 integrity check failed.");
        AssertBytes.equal(postBytes32, testBytes, "After a postBytes4 concat the postBytes32 integrity check failed.");
        testBytes = hex"f00d0000000000000000000000000000000000000000000000000000000000feed";
        assertEq(postBytes33, testBytes, "After a postBytes4 concat the postBytes33 integrity check failed.");
        AssertBytes.equal(postBytes33, testBytes, "After a postBytes4 concat the postBytes33 integrity check failed.");
    }

    function testMemoryIntegrityCheck31Bytes() public {
        bytes memory preBytes4 = hex"f00dfeed";
        bytes memory postBytes4 = hex"f00dfeed";
        bytes memory postBytes31 = hex"f00d000000000000000000000000000000000000000000000000000000feed";
        bytes memory postBytes32 = hex"f00d00000000000000000000000000000000000000000000000000000000feed";
        bytes memory postBytes33 = hex"f00d0000000000000000000000000000000000000000000000000000000000feed";

        bytes memory testBytes;
        bytes memory resultBytes;

        resultBytes = preBytes4.concat(postBytes31);

        // Now we should make sure that all the other previously initialized arrays stayed the same
        testBytes = hex"f00dfeed";
        assertEq(preBytes4, testBytes, "After a postBytes31 concat the preBytes4 integrity check failed.");
        assertEq(postBytes4, testBytes, "After a postBytes31 concat the postBytes4 integrity check failed.");
        AssertBytes.equal(preBytes4, testBytes, "After a postBytes31 concat the preBytes4 integrity check failed.");
        AssertBytes.equal(postBytes4, testBytes, "After a postBytes31 concat the postBytes4 integrity check failed.");
        testBytes = hex"f00d000000000000000000000000000000000000000000000000000000feed";
        assertEq(postBytes31, testBytes, "After a postBytes31 concat the postBytes31 integrity check failed.");
        AssertBytes.equal(postBytes31, testBytes, "After a postBytes31 concat the postBytes31 integrity check failed.");
        testBytes = hex"f00d00000000000000000000000000000000000000000000000000000000feed";
        assertEq(postBytes32, testBytes, "After a postBytes31 concat the postBytes32 integrity check failed.");
        AssertBytes.equal(postBytes32, testBytes, "After a postBytes31 concat the postBytes32 integrity check failed.");
        testBytes = hex"f00d0000000000000000000000000000000000000000000000000000000000feed";
        assertEq(postBytes33, testBytes, "After a postBytes31 concat the postBytes33 integrity check failed.");
        AssertBytes.equal(postBytes33, testBytes, "After a postBytes31 concat the postBytes33 integrity check failed.");
    }

    function testMemoryIntegrityCheck32Bytes() public {
        bytes memory preBytes4 = hex"f00dfeed";
        bytes memory postBytes4 = hex"f00dfeed";
        bytes memory postBytes31 = hex"f00d000000000000000000000000000000000000000000000000000000feed";
        bytes memory postBytes32 = hex"f00d00000000000000000000000000000000000000000000000000000000feed";
        bytes memory postBytes33 = hex"f00d0000000000000000000000000000000000000000000000000000000000feed";

        bytes memory testBytes;
        bytes memory resultBytes;

        resultBytes = preBytes4.concat(postBytes32);

        // Now we should make sure that all the other previously initialized arrays stayed the same
        testBytes = hex"f00dfeed";
        assertEq(preBytes4, testBytes, "After a postBytes32 concat the preBytes4 integrity check failed.");
        assertEq(postBytes4, testBytes, "After a postBytes32 concat the postBytes4 integrity check failed.");
        AssertBytes.equal(preBytes4, testBytes, "After a postBytes32 concat the preBytes4 integrity check failed.");
        AssertBytes.equal(postBytes4, testBytes, "After a postBytes32 concat the postBytes4 integrity check failed.");
        testBytes = hex"f00d000000000000000000000000000000000000000000000000000000feed";
        assertEq(postBytes31, testBytes, "After a postBytes32 concat the postBytes31 integrity check failed.");
        AssertBytes.equal(postBytes31, testBytes, "After a postBytes32 concat the postBytes31 integrity check failed.");
        testBytes = hex"f00d00000000000000000000000000000000000000000000000000000000feed";
        assertEq(postBytes32, testBytes, "After a postBytes32 concat the postBytes32 integrity check failed.");
        AssertBytes.equal(postBytes32, testBytes, "After a postBytes32 concat the postBytes32 integrity check failed.");
        testBytes = hex"f00d0000000000000000000000000000000000000000000000000000000000feed";
        assertEq(postBytes33, testBytes, "After a postBytes32 concat the postBytes33 integrity check failed.");
        AssertBytes.equal(postBytes33, testBytes, "After a postBytes32 concat the postBytes33 integrity check failed.");
}

    function testMemoryIntegrityCheck33Bytes() public {
        bytes memory preBytes4 = hex"f00dfeed";
        bytes memory postBytes4 = hex"f00dfeed";
        bytes memory postBytes31 = hex"f00d000000000000000000000000000000000000000000000000000000feed";
        bytes memory postBytes32 = hex"f00d00000000000000000000000000000000000000000000000000000000feed";
        bytes memory postBytes33 = hex"f00d0000000000000000000000000000000000000000000000000000000000feed";

        bytes memory testBytes;
        bytes memory resultBytes;

        resultBytes = preBytes4.concat(postBytes33);

        // Now we should make sure that all the other previously initialized arrays stayed the same
        testBytes = hex"f00dfeed";
        assertEq(preBytes4, testBytes, "After a postBytes33 concat the preBytes4 integrity check failed.");
        assertEq(postBytes4, testBytes, "After a postBytes33 concat the postBytes4 integrity check failed.");
        AssertBytes.equal(preBytes4, testBytes, "After a postBytes33 concat the preBytes4 integrity check failed.");
        AssertBytes.equal(postBytes4, testBytes, "After a postBytes33 concat the postBytes4 integrity check failed.");
        testBytes = hex"f00d000000000000000000000000000000000000000000000000000000feed";
        assertEq(postBytes31, testBytes, "After a postBytes33 concat the postBytes31 integrity check failed.");
        AssertBytes.equal(postBytes31, testBytes, "After a postBytes33 concat the postBytes31 integrity check failed.");
        testBytes = hex"f00d00000000000000000000000000000000000000000000000000000000feed";
        assertEq(postBytes32, testBytes, "After a postBytes33 concat the postBytes32 integrity check failed.");
        AssertBytes.equal(postBytes32, testBytes, "After a postBytes33 concat the postBytes32 integrity check failed.");
        testBytes = hex"f00d0000000000000000000000000000000000000000000000000000000000feed";
        assertEq(postBytes33, testBytes, "After a postBytes33 concat the postBytes33 integrity check failed.");
        AssertBytes.equal(postBytes33, testBytes, "After a postBytes33 concat the postBytes33 integrity check failed.");
    }

    /**
    * Memory Concatenation Tests
    */

    function testConcatMemory4Bytes() public {
        // Initialize `bytes` variables in memory with different critical sizes
        bytes memory preBytes4 = hex"f00dfeed";
        bytes memory preBytes31 = hex"f00d000000000000000000000000000000000000000000000000000000feed";
        bytes memory preBytes32 = hex"f00d00000000000000000000000000000000000000000000000000000000feed";
        bytes memory preBytes33 = hex"f00d0000000000000000000000000000000000000000000000000000000000feed";

        bytes memory postBytes4 = hex"f00dfeed";

        bytes memory testBytes;
        bytes memory resultBytes;

        resultBytes = preBytes4.concat(postBytes4);
        testBytes = hex"f00dfeedf00dfeed";
        assertEq(resultBytes, testBytes, "preBytes4 + postBytes4 concatenation failed.");
        AssertBytes.equal(resultBytes, testBytes, "preBytes4 + postBytes4 concatenation failed.");

        resultBytes = preBytes31.concat(postBytes4);
        testBytes = hex"f00d000000000000000000000000000000000000000000000000000000feedf00dfeed";
        assertEq(resultBytes, testBytes, "preBytes31 + postBytes4 concatenation failed.");
        AssertBytes.equal(resultBytes, testBytes, "preBytes31 + postBytes4 concatenation failed.");

        resultBytes = preBytes32.concat(postBytes4);
        testBytes = hex"f00d00000000000000000000000000000000000000000000000000000000feedf00dfeed";
        assertEq(resultBytes, testBytes, "preBytes32 + postBytes4 concatenation failed.");
        AssertBytes.equal(resultBytes, testBytes, "preBytes32 + postBytes4 concatenation failed.");

        resultBytes = preBytes33.concat(postBytes4);
        testBytes = hex"f00d0000000000000000000000000000000000000000000000000000000000feedf00dfeed";
        assertEq(resultBytes, testBytes, "preBytes33 + postBytes4 concatenation failed.");
        AssertBytes.equal(resultBytes, testBytes, "preBytes33 + postBytes4 concatenation failed.");
    }

    function testConcatMemory31Bytes() public {
        // Initialize `bytes` variables in memory with different critical sizes
        bytes memory preBytes4 = hex"f00dfeed";
        bytes memory preBytes31 = hex"f00d000000000000000000000000000000000000000000000000000000feed";
        bytes memory preBytes32 = hex"f00d00000000000000000000000000000000000000000000000000000000feed";
        bytes memory preBytes33 = hex"f00d0000000000000000000000000000000000000000000000000000000000feed";

        bytes memory postBytes31 = hex"f00d000000000000000000000000000000000000000000000000000000feed";

        bytes memory testBytes;
        bytes memory resultBytes;

        resultBytes = preBytes4.concat(postBytes31);
        testBytes = hex"f00dfeedf00d000000000000000000000000000000000000000000000000000000feed";
        assertEq(resultBytes, testBytes, "preBytes4 + postBytes31 concatenation failed.");
        AssertBytes.equal(resultBytes, testBytes, "preBytes4 + postBytes31 concatenation failed.");

        resultBytes = preBytes31.concat(postBytes31);
        testBytes = hex"f00d000000000000000000000000000000000000000000000000000000feedf00d000000000000000000000000000000000000000000000000000000feed";
        assertEq(resultBytes, testBytes, "preBytes31 + postBytes31 concatenation failed.");
        AssertBytes.equal(resultBytes, testBytes, "preBytes31 + postBytes31 concatenation failed.");

        resultBytes = preBytes32.concat(postBytes31);
        testBytes = hex"f00d00000000000000000000000000000000000000000000000000000000feedf00d000000000000000000000000000000000000000000000000000000feed";
        assertEq(resultBytes, testBytes, "preBytes32 + postBytes31 concatenation failed.");
        AssertBytes.equal(resultBytes, testBytes, "preBytes32 + postBytes31 concatenation failed.");

        resultBytes = preBytes33.concat(postBytes31);
        testBytes = hex"f00d0000000000000000000000000000000000000000000000000000000000feedf00d000000000000000000000000000000000000000000000000000000feed";
        assertEq(resultBytes, testBytes, "preBytes33 + postBytes31 concatenation failed.");
        AssertBytes.equal(resultBytes, testBytes, "preBytes33 + postBytes31 concatenation failed.");
    }

    function testConcatMemory32Bytes() public {
        // Initialize `bytes` variables in memory with different critical sizes
        bytes memory preBytes4 = hex"f00dfeed";
        bytes memory preBytes31 = hex"f00d000000000000000000000000000000000000000000000000000000feed";
        bytes memory preBytes32 = hex"f00d00000000000000000000000000000000000000000000000000000000feed";
        bytes memory preBytes33 = hex"f00d0000000000000000000000000000000000000000000000000000000000feed";

        bytes memory postBytes32 = hex"f00d00000000000000000000000000000000000000000000000000000000feed";

        bytes memory testBytes;
        bytes memory resultBytes;

        resultBytes = preBytes4.concat(postBytes32);
        testBytes = hex"f00dfeedf00d00000000000000000000000000000000000000000000000000000000feed";
        assertEq(resultBytes, testBytes, "preBytes4 + postBytes32 concatenation failed.");
        AssertBytes.equal(resultBytes, testBytes, "preBytes4 + postBytes32 concatenation failed.");

        resultBytes = preBytes31.concat(postBytes32);
        testBytes = hex"f00d000000000000000000000000000000000000000000000000000000feedf00d00000000000000000000000000000000000000000000000000000000feed";
        assertEq(resultBytes, testBytes, "preBytes31 + postBytes32 concatenation failed.");
        AssertBytes.equal(resultBytes, testBytes, "preBytes31 + postBytes32 concatenation failed.");

        resultBytes = preBytes32.concat(postBytes32);
        testBytes = hex"f00d00000000000000000000000000000000000000000000000000000000feedf00d00000000000000000000000000000000000000000000000000000000feed";
        assertEq(resultBytes, testBytes, "preBytes32 + postBytes32 concatenation failed.");
        AssertBytes.equal(resultBytes, testBytes, "preBytes32 + postBytes32 concatenation failed.");

        resultBytes = preBytes33.concat(postBytes32);
        testBytes = hex"f00d0000000000000000000000000000000000000000000000000000000000feedf00d00000000000000000000000000000000000000000000000000000000feed";
        assertEq(resultBytes, testBytes, "preBytes33 + postBytes32 concatenation failed.");
        AssertBytes.equal(resultBytes, testBytes, "preBytes33 + postBytes32 concatenation failed.");
    }

    function testConcatMemory33Bytes() public {
        // Initialize `bytes` variables in memory with different critical sizes
        bytes memory preBytes4 = hex"f00dfeed";
        bytes memory preBytes31 = hex"f00d000000000000000000000000000000000000000000000000000000feed";
        bytes memory preBytes32 = hex"f00d00000000000000000000000000000000000000000000000000000000feed";
        bytes memory preBytes33 = hex"f00d0000000000000000000000000000000000000000000000000000000000feed";

        bytes memory postBytes33 = hex"f00d0000000000000000000000000000000000000000000000000000000000feed";

        bytes memory testBytes;
        bytes memory resultBytes;

        resultBytes = preBytes4.concat(postBytes33);
        testBytes = hex"f00dfeedf00d0000000000000000000000000000000000000000000000000000000000feed";
        assertEq(resultBytes, testBytes, "preBytes4 + postBytes33 concatenation failed.");
        AssertBytes.equal(resultBytes, testBytes, "preBytes4 + postBytes33 concatenation failed.");

        resultBytes = preBytes31.concat(postBytes33);
        testBytes = hex"f00d000000000000000000000000000000000000000000000000000000feedf00d0000000000000000000000000000000000000000000000000000000000feed";
        assertEq(resultBytes, testBytes, "preBytes31 + postBytes33 concatenation failed.");
        AssertBytes.equal(resultBytes, testBytes, "preBytes31 + postBytes33 concatenation failed.");

        resultBytes = preBytes32.concat(postBytes33);
        testBytes = hex"f00d00000000000000000000000000000000000000000000000000000000feedf00d0000000000000000000000000000000000000000000000000000000000feed";
        assertEq(resultBytes, testBytes, "preBytes32 + postBytes33 concatenation failed.");
        AssertBytes.equal(resultBytes, testBytes, "preBytes32 + postBytes33 concatenation failed.");

        resultBytes = preBytes33.concat(postBytes33);
        testBytes = hex"f00d0000000000000000000000000000000000000000000000000000000000feedf00d0000000000000000000000000000000000000000000000000000000000feed";
        assertEq(resultBytes, testBytes, "preBytes33 + postBytes33 concatenation failed.");
        AssertBytes.equal(resultBytes, testBytes, "preBytes33 + postBytes33 concatenation failed.");
    }

    /**
    * Storage Concatenation Tests
    */

    function testConcatStorage4Bytes() public {
        // Initialize `bytes` variables in memory
        bytes memory memBytes4 = hex"f00dfeed";

        // this next assembly block is to guarantee that the block of memory next to the end of the bytes
        // array is not zero'ed out
        assembly {
            let mc := mload(0x40)
            mstore(mc, 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff)
            mstore(0x40, add(mc, 0x20))
        }

        bytes memory testBytes;

        storageBytes4.concatStorage(memBytes4);
        testBytes = hex"f00dfeedf00dfeed";
        assertEq(storageBytes4, testBytes, "storageBytes4 + memBytes4 concatenation failed.");
        AssertBytes.equalStorage(storageBytes4, testBytes, "storageBytes4 + memBytes4 concatenation failed.");

        storageBytes31.concatStorage(memBytes4);
        testBytes = hex"f00d000000000000000000000000000000000000000000000000000000feedf00dfeed";
        assertEq(storageBytes31, testBytes, "storageBytes31 + memBytes4 concatenation failed.");
        AssertBytes.equalStorage(storageBytes31, testBytes, "storageBytes31 + memBytes4 concatenation failed.");

        storageBytes32.concatStorage(memBytes4);
        testBytes = hex"f00d00000000000000000000000000000000000000000000000000000000feedf00dfeed";
        assertEq(storageBytes32, testBytes, "storageBytes32 + memBytes4 concatenation failed.");
        AssertBytes.equalStorage(storageBytes32, testBytes, "storageBytes32 + memBytes4 concatenation failed.");

        storageBytes33.concatStorage(memBytes4);
        testBytes = hex"f00d0000000000000000000000000000000000000000000000000000000000feedf00dfeed";
        assertEq(storageBytes33, testBytes, "storageBytes33 + memBytes4 concatenation failed.");
        AssertBytes.equalStorage(storageBytes33, testBytes, "storageBytes33 + memBytes4 concatenation failed.");

        storageBytes63.concatStorage(memBytes4);
        testBytes = hex"f00d0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000feedf00dfeed";
        assertEq(storageBytes63, testBytes, "storageBytes63 + memBytes4 concatenation failed.");
        AssertBytes.equalStorage(storageBytes63, testBytes, "storageBytes63 + memBytes4 concatenation failed.");

        storageBytes64.concatStorage(memBytes4);
        testBytes = hex"f00d000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000feedf00dfeed";
        assertEq(storageBytes64, testBytes, "storageBytes64 + memBytes4 concatenation failed.");
        AssertBytes.equalStorage(storageBytes64, testBytes, "storageBytes64 + memBytes4 concatenation failed.");

        storageBytes65.concatStorage(memBytes4);
        testBytes = hex"f00d00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000feedf00dfeed";
        assertEq(storageBytes65, testBytes, "storageBytes65 + memBytes4 concatenation failed.");
        AssertBytes.equalStorage(storageBytes65, testBytes, "storageBytes65 + memBytes4 concatenation failed.");

        storageBytes70.concatStorage(memBytes4);
        testBytes = hex"f00d000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000feedf00dfeed";
        assertEq(storageBytes70, testBytes, "storageBytes70 + memBytes4 concatenation failed.");
        AssertBytes.equalStorage(storageBytes70, testBytes, "storageBytes70 + memBytes4 concatenation failed.");

        resetStorage();
    }

    function testConcatStorage31Bytes() public {
        // Initialize `bytes` variables in memory
        bytes memory memBytes31 = hex"f00d000000000000000000000000000000000000000000000000000000feed";

        // this next assembly block is to guarantee that the block of memory next to the end of the bytes
        // array is not zero'ed out
        assembly {
            let mc := mload(0x40)
            mstore(mc, 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff)
            mstore(0x40, add(mc, 0x20))
        }

        bytes memory testBytes;

        storageBytes4.concatStorage(memBytes31);
        testBytes = hex"f00dfeedf00d000000000000000000000000000000000000000000000000000000feed";
        assertEq(storageBytes4, testBytes, "storageBytes4 + memBytes31 concatenation failed.");
        AssertBytes.equalStorage(storageBytes4, testBytes, "storageBytes4 + memBytes31 concatenation failed.");

        storageBytes31.concatStorage(memBytes31);
        testBytes = hex"f00d000000000000000000000000000000000000000000000000000000feedf00d000000000000000000000000000000000000000000000000000000feed";
        assertEq(storageBytes31, testBytes, "storageBytes31 + memBytes31 concatenation failed.");
        AssertBytes.equalStorage(storageBytes31, testBytes, "storageBytes31 + memBytes31 concatenation failed.");

        storageBytes32.concatStorage(memBytes31);
        testBytes = hex"f00d00000000000000000000000000000000000000000000000000000000feedf00d000000000000000000000000000000000000000000000000000000feed";
        assertEq(storageBytes32, testBytes, "storageBytes32 + memBytes31 concatenation failed.");
        AssertBytes.equalStorage(storageBytes32, testBytes, "storageBytes32 + memBytes31 concatenation failed.");

        storageBytes33.concatStorage(memBytes31);
        testBytes = hex"f00d0000000000000000000000000000000000000000000000000000000000feedf00d000000000000000000000000000000000000000000000000000000feed";
        assertEq(storageBytes33, testBytes, "storageBytes33 + memBytes31 concatenation failed.");
        AssertBytes.equalStorage(storageBytes33, testBytes, "storageBytes33 + memBytes31 concatenation failed.");

        storageBytes63.concatStorage(memBytes31);
        testBytes = hex"f00d0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000feedf00d000000000000000000000000000000000000000000000000000000feed";
        assertEq(storageBytes63, testBytes, "storageBytes63 + memBytes31 concatenation failed.");
        AssertBytes.equalStorage(storageBytes63, testBytes, "storageBytes63 + memBytes31 concatenation failed.");

        storageBytes64.concatStorage(memBytes31);
        testBytes = hex"f00d000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000feedf00d000000000000000000000000000000000000000000000000000000feed";
        assertEq(storageBytes64, testBytes, "storageBytes64 + memBytes31 concatenation failed.");
        AssertBytes.equalStorage(storageBytes64, testBytes, "storageBytes64 + memBytes31 concatenation failed.");

        storageBytes65.concatStorage(memBytes31);
        testBytes = hex"f00d00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000feedf00d000000000000000000000000000000000000000000000000000000feed";
        assertEq(storageBytes65, testBytes, "storageBytes65 + memBytes31 concatenation failed.");
        AssertBytes.equalStorage(storageBytes65, testBytes, "storageBytes65 + memBytes31 concatenation failed.");

        storageBytes70.concatStorage(memBytes31);
        testBytes = hex"f00d000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000feedf00d000000000000000000000000000000000000000000000000000000feed";
        assertEq(storageBytes70, testBytes, "storageBytes70 + memBytes31 concatenation failed.");
        AssertBytes.equalStorage(storageBytes70, testBytes, "storageBytes70 + memBytes31 concatenation failed.");

        resetStorage();
    }

    function testConcatStorage32Bytes() public {
        // Initialize `bytes` variables in memory
        bytes memory memBytes32 = hex"f00d00000000000000000000000000000000000000000000000000000000feed";

        // this next assembly block is to guarantee that the block of memory next to the end of the bytes
        // array is not zero'ed out
        assembly {
            let mc := mload(0x40)
            mstore(mc, 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff)
            mstore(0x40, add(mc, 0x20))
        }

        bytes memory testBytes;

        storageBytes4.concatStorage(memBytes32);
        testBytes = hex"f00dfeedf00d00000000000000000000000000000000000000000000000000000000feed";
        assertEq(storageBytes4, testBytes, "storageBytes4 + memBytes32 concatenation failed.");
        AssertBytes.equalStorage(storageBytes4, testBytes, "storageBytes4 + memBytes32 concatenation failed.");

        storageBytes31.concatStorage(memBytes32);
        testBytes = hex"f00d000000000000000000000000000000000000000000000000000000feedf00d00000000000000000000000000000000000000000000000000000000feed";
        assertEq(storageBytes31, testBytes, "storageBytes31 + memBytes32 concatenation failed.");
        AssertBytes.equalStorage(storageBytes31, testBytes, "storageBytes31 + memBytes32 concatenation failed.");

        storageBytes32.concatStorage(memBytes32);
        testBytes = hex"f00d00000000000000000000000000000000000000000000000000000000feedf00d00000000000000000000000000000000000000000000000000000000feed";
        assertEq(storageBytes32, testBytes, "storageBytes32 + memBytes32 concatenation failed.");
        AssertBytes.equalStorage(storageBytes32, testBytes, "storageBytes32 + memBytes32 concatenation failed.");

        storageBytes33.concatStorage(memBytes32);
        testBytes = hex"f00d0000000000000000000000000000000000000000000000000000000000feedf00d00000000000000000000000000000000000000000000000000000000feed";
        assertEq(storageBytes33, testBytes, "storageBytes33 + memBytes32 concatenation failed.");
        AssertBytes.equalStorage(storageBytes33, testBytes, "storageBytes33 + memBytes32 concatenation failed.");

        storageBytes63.concatStorage(memBytes32);
        testBytes = hex"f00d0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000feedf00d00000000000000000000000000000000000000000000000000000000feed";
        assertEq(storageBytes63, testBytes, "storageBytes63 + memBytes32 concatenation failed.");
        AssertBytes.equalStorage(storageBytes63, testBytes, "storageBytes63 + memBytes32 concatenation failed.");

        storageBytes64.concatStorage(memBytes32);
        testBytes = hex"f00d000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000feedf00d00000000000000000000000000000000000000000000000000000000feed";
        assertEq(storageBytes64, testBytes, "storageBytes64 + memBytes32 concatenation failed.");
        AssertBytes.equalStorage(storageBytes64, testBytes, "storageBytes64 + memBytes32 concatenation failed.");

        storageBytes65.concatStorage(memBytes32);
        testBytes = hex"f00d00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000feedf00d00000000000000000000000000000000000000000000000000000000feed";
        assertEq(storageBytes65, testBytes, "storageBytes65 + memBytes32 concatenation failed.");
        AssertBytes.equalStorage(storageBytes65, testBytes, "storageBytes65 + memBytes32 concatenation failed.");

        storageBytes70.concatStorage(memBytes32);
        testBytes = hex"f00d000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000feedf00d00000000000000000000000000000000000000000000000000000000feed";
        assertEq(storageBytes70, testBytes, "storageBytes70 + memBytes32 concatenation failed.");
        AssertBytes.equalStorage(storageBytes70, testBytes, "storageBytes70 + memBytes32 concatenation failed.");

        resetStorage();
    }

    function testConcatStorage33Bytes() public {
        // Initialize `bytes` variables in memory
        bytes memory memBytes33 = hex"f00d0000000000000000000000000000000000000000000000000000000000feed";

        // this next assembly block is to guarantee that the block of memory next to the end of the bytes
        // array is not zero'ed out
        assembly {
            let mc := mload(0x40)
            mstore(mc, 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff)
            mstore(0x40, add(mc, 0x20))
        }

        bytes memory testBytes;

        storageBytes4.concatStorage(memBytes33);
        testBytes = hex"f00dfeedf00d0000000000000000000000000000000000000000000000000000000000feed";
        assertEq(storageBytes4, testBytes, "storageBytes4 + memBytes33 concatenation failed.");
        AssertBytes.equalStorage(storageBytes4, testBytes, "storageBytes4 + memBytes33 concatenation failed.");

        storageBytes31.concatStorage(memBytes33);
        testBytes = hex"f00d000000000000000000000000000000000000000000000000000000feedf00d0000000000000000000000000000000000000000000000000000000000feed";
        assertEq(storageBytes31, testBytes, "storageBytes31 + memBytes33 concatenation failed.");
        AssertBytes.equalStorage(storageBytes31, testBytes, "storageBytes31 + memBytes33 concatenation failed.");

        storageBytes32.concatStorage(memBytes33);
        testBytes = hex"f00d00000000000000000000000000000000000000000000000000000000feedf00d0000000000000000000000000000000000000000000000000000000000feed";
        assertEq(storageBytes32, testBytes, "storageBytes32 + memBytes33 concatenation failed.");
        AssertBytes.equalStorage(storageBytes32, testBytes, "storageBytes32 + memBytes33 concatenation failed.");

        storageBytes33.concatStorage(memBytes33);
        testBytes = hex"f00d0000000000000000000000000000000000000000000000000000000000feedf00d0000000000000000000000000000000000000000000000000000000000feed";
        assertEq(storageBytes33, testBytes, "storageBytes33 + memBytes33 concatenation failed.");
        AssertBytes.equalStorage(storageBytes33, testBytes, "storageBytes33 + memBytes33 concatenation failed.");

        storageBytes63.concatStorage(memBytes33);
        testBytes = hex"f00d0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000feedf00d0000000000000000000000000000000000000000000000000000000000feed";
        assertEq(storageBytes63, testBytes, "storageBytes63 + memBytes33 concatenation failed.");
        AssertBytes.equalStorage(storageBytes63, testBytes, "storageBytes63 + memBytes33 concatenation failed.");

        storageBytes64.concatStorage(memBytes33);
        testBytes = hex"f00d000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000feedf00d0000000000000000000000000000000000000000000000000000000000feed";
        assertEq(storageBytes64, testBytes, "storageBytes64 + memBytes33 concatenation failed.");
        AssertBytes.equalStorage(storageBytes64, testBytes, "storageBytes64 + memBytes33 concatenation failed.");

        storageBytes65.concatStorage(memBytes33);
        testBytes = hex"f00d00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000feedf00d0000000000000000000000000000000000000000000000000000000000feed";
        assertEq(storageBytes65, testBytes, "storageBytes65 + memBytes33 concatenation failed.");
        AssertBytes.equalStorage(storageBytes65, testBytes, "storageBytes65 + memBytes33 concatenation failed.");

        storageBytes70.concatStorage(memBytes33);
        testBytes = hex"f00d000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000feedf00d0000000000000000000000000000000000000000000000000000000000feed";
        assertEq(storageBytes70, testBytes, "storageBytes70 + memBytes33 concatenation failed.");
        AssertBytes.equalStorage(storageBytes70, testBytes, "storageBytes70 + memBytes33 concatenation failed.");

        resetStorage();
    }

    /**
    * Equality Non-aligned Tests
    */

    function testEqualNonAligned4Bytes() public {
        bytes memory memBytes1; // hex"f00dfeed"
        bytes memory memBytes2; // hex"f00dfeed"

        // We need to make sure that the bytes are not aligned to a 32 byte boundary
        // so we need to use assembly to allocate the bytes in contiguous memory
        // Solidity will not let us do this normally, this equality method exists
        // to test the edge case of non-aligned bytes created in assembly
        assembly {
            // Fetch free memory pointer
            let freePointer := mload(0x40)

            // We first store the length of the byte array (4 bytes)
            // And then we write a byte at a time
            memBytes1 := freePointer
            mstore(freePointer, 0x04)
            freePointer := add(freePointer, 0x20)
            mstore8(freePointer, 0xf0)
            freePointer := add(freePointer, 0x1)
            mstore8(freePointer, 0x0d)
            freePointer := add(freePointer, 0x1)
            mstore8(freePointer, 0xfe)
            freePointer := add(freePointer, 0x1)
            mstore8(freePointer, 0xed)
            freePointer := add(freePointer, 0x1)

            // We do the same for memBytes2 in contiguous memory
            memBytes2 := freePointer
            mstore(freePointer, 0x04)
            freePointer := add(freePointer, 0x20)
            mstore8(freePointer, 0xf0)
            freePointer := add(freePointer, 0x1)
            mstore8(freePointer, 0x0d)
            freePointer := add(freePointer, 0x1)
            mstore8(freePointer, 0xfe)
            freePointer := add(freePointer, 0x1)
            mstore8(freePointer, 0xed)
            freePointer := add(freePointer, 0x1)

            // We add some garbage bytes in contiguous memory
            mstore8(freePointer, 0xde)
            freePointer := add(freePointer, 0x1)
            mstore8(freePointer, 0xad)
            freePointer := add(freePointer, 0x1)

            // now, just for completeness sake we'll update the free-memory pointer accordingly
            mstore(0x40, freePointer)
        }

        AssertBytes.equal_nonAligned(memBytes1, memBytes2, "The equality check for the non-aligned equality 4-bytes-long test failed.");
        // The equality check for aligned byte arrays should fail for non-aligned bytes
        AssertBytes.notEqual(memBytes1, memBytes2, "The equality check for the non-aligned equality 4-bytes-long test failed.");
    }

    function testEqualNonAligned4BytesFail() public {
        bytes memory memBytes1; // hex"f00dfeed"
        bytes memory memBytes2; // hex"feedf00d"

        // We need to make sure that the bytes are not aligned to a 32 byte boundary
        // so we need to use assembly to allocate the bytes in contiguous memory
        // Solidity will not let us do this normally, this equality method exists
        // to test the edge case of non-aligned bytes created in assembly
        assembly {
            // Fetch free memory pointer
            let freePointer := mload(0x40)

            // We first store the length of the byte array (4 bytes)
            // And then we write a byte at a time
            memBytes1 := freePointer
            mstore(freePointer, 0x04)
            freePointer := add(freePointer, 0x20)
            mstore8(freePointer, 0xf0)
            freePointer := add(freePointer, 0x1)
            mstore8(freePointer, 0x0d)
            freePointer := add(freePointer, 0x1)
            mstore8(freePointer, 0xfe)
            freePointer := add(freePointer, 0x1)
            mstore8(freePointer, 0xed)
            freePointer := add(freePointer, 0x1)

            // We do the same for memBytes2 in contiguous memory
            memBytes2 := freePointer
            mstore(freePointer, 0x04)
            freePointer := add(freePointer, 0x20)
            mstore8(freePointer, 0xfe)
            freePointer := add(freePointer, 0x1)
            mstore8(freePointer, 0xed)
            freePointer := add(freePointer, 0x1)
            mstore8(freePointer, 0xf0)
            freePointer := add(freePointer, 0x1)
            mstore8(freePointer, 0x0d)
            freePointer := add(freePointer, 0x1)

            // We add some garbage bytes in contiguous memory
            mstore8(freePointer, 0xde)
            freePointer := add(freePointer, 0x1)
            mstore8(freePointer, 0xad)
            freePointer := add(freePointer, 0x1)

            // now, just for completeness sake we'll update the free-memory pointer accordingly
            mstore(0x40, freePointer)
        }

        AssertBytes.notEqual_nonAligned(memBytes1, memBytes2, "The non equality check for the non-aligned equality 4-bytes-long test failed.");
    }

    function testEqualNonAligned33Bytes() public {
        bytes memory memBytes1; // hex"f00d00000000000000000000000000000000000000000000000000000000feedcc";
        bytes memory memBytes2; // hex"f00d00000000000000000000000000000000000000000000000000000000feedcc";
        
        // We need to make sure that the bytes are not aligned to a 32 byte boundary
        // so we need to use assembly to allocate the bytes in contiguous memory
        // Solidity will not let us do this normally, this equality method exists
        // to test the edge case of non-aligned bytes created in assembly
        assembly {
            // Fetch free memory pointer
            let freePointer := mload(0x40)

            // We first store the length of the byte array (33 bytes)
            // And then we write a word and then a byte
            memBytes1 := freePointer
            mstore(freePointer, 0x21)
            freePointer := add(freePointer, 0x20)
            mstore(freePointer, 0xf00d00000000000000000000000000000000000000000000000000000000feed)
            freePointer := add(freePointer, 0x20)
            mstore8(freePointer, 0xcc)
            freePointer := add(freePointer, 0x1)

            // We do the same for memBytes2 in contiguous memory
            memBytes2 := freePointer
            mstore(freePointer, 0x21)
            freePointer := add(freePointer, 0x20)
            mstore(freePointer, 0xf00d00000000000000000000000000000000000000000000000000000000feed)
            freePointer := add(freePointer, 0x20)
            mstore8(freePointer, 0xcc)
            freePointer := add(freePointer, 0x1)

            // We add some garbage bytes in contiguous memory
            mstore8(freePointer, 0xde)
            freePointer := add(freePointer, 0x1)
            mstore8(freePointer, 0xad)
            freePointer := add(freePointer, 0x1)

            // now, just for completeness sake we'll update the free-memory pointer accordingly
            mstore(0x40, freePointer)
        }

        AssertBytes.equal_nonAligned(memBytes1, memBytes2, "The equality check for the non-aligned equality 33-bytes-long test failed.");
        // The equality check for aligned byte arrays should fail for non-aligned bytes
        AssertBytes.notEqual(memBytes1, memBytes2, "The equality check for the non-aligned equality 4-bytes-long test failed.");
    }

    function testEqualNonAligned33BytesFail() public {
        bytes memory memBytes1; // hex"f00d00000000000000000000000000000000000000000000000000000000feedcc";
        bytes memory memBytes2; // hex"f00d00000000000000000000000000000000000000000000000000000000feedee";
        
        // We need to make sure that the bytes are not aligned to a 32 byte boundary
        // so we need to use assembly to allocate the bytes in contiguous memory
        // Solidity will not let us do this normally, this equality method exists
        // to test the edge case of non-aligned bytes created in assembly
        assembly {
            // Fetch free memory pointer
            let freePointer := mload(0x40)

            // We first store the length of the byte array (33 bytes)
            // And then we write a word and then a byte
            memBytes1 := freePointer
            mstore(freePointer, 0x21)
            freePointer := add(freePointer, 0x20)
            mstore(freePointer, 0xf00d00000000000000000000000000000000000000000000000000000000feed)
            freePointer := add(freePointer, 0x20)
            mstore8(freePointer, 0xcc)
            freePointer := add(freePointer, 0x1)

            // We do the same for memBytes2 in contiguous memory
            memBytes2 := freePointer
            mstore(freePointer, 0x21)
            freePointer := add(freePointer, 0x20)
            mstore(freePointer, 0xf00d00000000000000000000000000000000000000000000000000000000feed)
            freePointer := add(freePointer, 0x20)
            mstore8(freePointer, 0xee)
            freePointer := add(freePointer, 0x1)

            // We add some garbage bytes in contiguous memory
            mstore8(freePointer, 0xde)
            freePointer := add(freePointer, 0x1)
            mstore8(freePointer, 0xad)
            freePointer := add(freePointer, 0x1)

            // now, just for completeness sake we'll update the free-memory pointer accordingly
            mstore(0x40, freePointer)
        }

        AssertBytes.notEqual_nonAligned(memBytes1, memBytes2, "The non equality check for the non-aligned equality 33-bytes-long test failed.");
    }

    /**
    * Edge Cases
    */

    function testConcatMemoryZeroLength() public {
        // Initialize `bytes` variables in memory with different critical sizes
        bytes memory preZeroLength = hex"";
        bytes memory postZeroLength = hex"";

        bytes memory testBytes;
        bytes memory resultBytes;

        resultBytes = preZeroLength.concat(postZeroLength);
        testBytes = hex"";
        assertEq(resultBytes, testBytes, "Zero Length concatenation failed.");
        AssertBytes.equal(resultBytes, testBytes, "Zero Length concatenation failed.");
    }

    /**
    * Helper Functions
    */

    function resetStorage() internal {
        storageBytes4 = hex"f00dfeed";
        storageBytes31 = hex"f00d000000000000000000000000000000000000000000000000000000feed";
        storageBytes32 = hex"f00d00000000000000000000000000000000000000000000000000000000feed";
        storageBytes33 = hex"f00d0000000000000000000000000000000000000000000000000000000000feed";
        storageBytes63 = hex"f00d0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000feed";
        storageBytes64 = hex"f00d000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000feed";
        storageBytes65 = hex"f00d00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000feed";
        storageBytes70 = hex"f00d000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000feed";
    }
}
