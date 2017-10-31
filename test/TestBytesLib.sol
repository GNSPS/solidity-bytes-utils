pragma solidity ^0.4.2;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/BytesLib.sol";

contract TestBytesLib {

    using BytesLib for bytes;

    bytes storageBytes4 = hex"f00dfeed";
    bytes storageBytes31 = hex"f00d000000000000000000000000000000000000000000000000000000feed";
    bytes storageBytes32 = hex"f00d00000000000000000000000000000000000000000000000000000000feed";
    bytes storageBytes33 = hex"f00d0000000000000000000000000000000000000000000000000000000000feed";
    bytes storageBytes63 = hex"f00d0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000feed";
    bytes storageBytes64 = hex"f00d000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000feed";
    bytes storageBytes65 = hex"f00d00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000feed";
    bytes storageBytes70 = hex"f00d000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000feed";

    event LogBytes(bytes loggedBytes);

    /**
    * Constructor
    */

    // function Tester() public {
    //     // The following storage variables have as suffixes their actual length
    //     // They are more densely distributed around every multiple of 32
    //     // because it's at a 32-bytes-length that storage tightly packed
    //     // arrays have different layouts
    //     storageBytes.push(hex"f00dfeed"); //4 bytes
    //     storageBytes.push(hex"f00d000000000000000000000000000000000000000000000000000000feed"); //31 bytes
    //     storageBytes.push(hex"f00d00000000000000000000000000000000000000000000000000000000feed"); //32 bytes
    //     storageBytes.push(hex"f00d0000000000000000000000000000000000000000000000000000000000feed"); //33 bytes
    //     storageBytes.push(hex"f00d0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000feed"); //63 bytes
    //     storageBytes.push(hex"f00d000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000feed"); //64 bytes
    //     storageBytes.push(hex"f00d00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000feed"); //65 bytes
    //     storageBytes.push(hex"f00d000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000feed"); //70 bytes
    // }

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

    /**
    * Storage Concatenation Tests
    */

    function testSanityCheckAssertLib() public {
        // Assert library sanity checks
        bytes memory checkBytes = hex"aabbccddeeff";
        bytes memory checkBytesRight = hex"aabbccddeeff";
        bytes memory checkBytesWrong = hex"000000";
        Assert.equal(string(checkBytes), string(checkBytesRight), "Sanity check should be checking equal strings out!!!");
        Assert.equal(string(checkBytes), string(checkBytesWrong), "Sanity check should be checking different strings out!!!");
    }

    function testConcatStorage() public {
        // Initialize `bytes` variables in memory with different sizes as well
        bytes memory memBytes4 = hex"f00dfeed";
        bytes memory memBytes31 = hex"f00d000000000000000000000000000000000000000000000000000000feed";
        bytes memory memBytes32 = hex"f00d00000000000000000000000000000000000000000000000000000000feed";
        bytes memory memBytes33 = hex"f00d0000000000000000000000000000000000000000000000000000000000feed";

        bytes memory concatBytesCurrent;

        //storageBytes4 tests
        concatBytesCurrent = storageBytes4.concatStorage(memBytes4);
        Assert.equal(concatBytesCurrent, string(hex"f00dfeedf00dfeed"), "storageBytes4 + memBytes4 concatenation failed.");
        concatBytesCurrent = storageBytes4.concatStorage(memBytes31);
        Assert.equal(concatBytesCurrent, string(hex"f00dfeedf00d000000000000000000000000000000000000000000000000000000feed"), "storageBytes4 + memBytes31 concatenation failed.");
        concatBytesCurrent = storageBytes4.concatStorage(memBytes32);
        Assert.equal(concatBytesCurrent, string(hex"f00dfeedf00d00000000000000000000000000000000000000000000000000000000feed"), "storageBytes4 + memBytes32 concatenation failed.");
        concatBytesCurrent = storageBytes4.concatStorage(memBytes33);
        Assert.equal(concatBytesCurrent, string(hex"f00dfeedf00d0000000000000000000000000000000000000000000000000000000000feed"), "storageBytes4 + memBytes33 concatenation failed.");

        resetStorage();

        //storageBytes31 tests
        concatBytesCurrent = storageBytes31.concatStorage(memBytes4);
        Assert.equal(concatBytesCurrent, string(hex"f00d000000000000000000000000000000000000000000000000000000feedf00dfeed"), "storageBytes31 + memBytes4 concatenation failed.");
        concatBytesCurrent = storageBytes31.concatStorage(memBytes31);
        Assert.equal(concatBytesCurrent, string(hex"f00d000000000000000000000000000000000000000000000000000000feedf00d000000000000000000000000000000000000000000000000000000feed"), "storageBytes31 + memBytes31 concatenation failed.");
        concatBytesCurrent = storageBytes31.concatStorage(memBytes32);
        Assert.equal(concatBytesCurrent, string(hex"f00d000000000000000000000000000000000000000000000000000000feedf00d00000000000000000000000000000000000000000000000000000000feed"), "storageBytes31 + memBytes32 concatenation failed.");
        concatBytesCurrent = storageBytes31.concatStorage(memBytes33);
        Assert.equal(concatBytesCurrent, string(hex"f00d000000000000000000000000000000000000000000000000000000feedf00d0000000000000000000000000000000000000000000000000000000000feed"), "storageBytes31 + memBytes33 concatenation failed.");

        resetStorage();

        //storageBytes32 tests
        concatBytesCurrent = storageBytes32.concatStorage(memBytes4);
        Assert.equal(concatBytesCurrent, string(hex"f00d000000000000000000000000000000000000000000000000000000feedf00dfeed"), "storageBytes32 + memBytes4 concatenation failed.");
        concatBytesCurrent = storageBytes32.concatStorage(memBytes31);
        Assert.equal(concatBytesCurrent, string(hex"f00d000000000000000000000000000000000000000000000000000000feedf00d000000000000000000000000000000000000000000000000000000feed"), "storageBytes32 + memBytes31 concatenation failed.");
        concatBytesCurrent = storageBytes32.concatStorage(memBytes32);
        Assert.equal(concatBytesCurrent, string(hex"f00d000000000000000000000000000000000000000000000000000000feedf00d00000000000000000000000000000000000000000000000000000000feed"), "storageBytes32 + memBytes32 concatenation failed.");
        concatBytesCurrent = storageBytes32.concatStorage(memBytes33);
        Assert.equal(concatBytesCurrent, string(hex"f00d000000000000000000000000000000000000000000000000000000feedf00d0000000000000000000000000000000000000000000000000000000000feed"), "storageBytes32 + memBytes33 concatenation failed.");

        resetStorage();

        //storageBytes33 tests
        concatBytesCurrent = storageBytes33.concatStorage(memBytes4);
        Assert.equal(concatBytesCurrent, string(hex"f00d000000000000000000000000000000000000000000000000000000feedf00dfeed"), "storageBytes33 + memBytes4 concatenation failed.");
        concatBytesCurrent = storageBytes33.concatStorage(memBytes31);
        Assert.equal(concatBytesCurrent, string(hex"f00d000000000000000000000000000000000000000000000000000000feedf00d000000000000000000000000000000000000000000000000000000feed"), "storageBytes33 + memBytes31 concatenation failed.");
        concatBytesCurrent = storageBytes33.concatStorage(memBytes32);
        Assert.equal(concatBytesCurrent, string(hex"f00d000000000000000000000000000000000000000000000000000000feedf00d00000000000000000000000000000000000000000000000000000000feed"), "storageBytes33 + memBytes32 concatenation failed.");
        concatBytesCurrent = storageBytes33.concatStorage(memBytes33);
        Assert.equal(concatBytesCurrent, string(hex"f00d000000000000000000000000000000000000000000000000000000feedf00d0000000000000000000000000000000000000000000000000000000000feed"), "storageBytes33 + memBytes33 concatenation failed.");

        resetStorage();

        //storageBytes63 tests
        concatBytesCurrent = storageBytes63.concatStorage(memBytes4);
        Assert.equal(concatBytesCurrent, string(hex"f00d000000000000000000000000000000000000000000000000000000feedf00dfeed"), "storageBytes63 + memBytes4 concatenation failed.");
        concatBytesCurrent = storageBytes63.concatStorage(memBytes31);
        Assert.equal(concatBytesCurrent, string(hex"f00d000000000000000000000000000000000000000000000000000000feedf00d000000000000000000000000000000000000000000000000000000feed"), "storageBytes63 + memBytes31 concatenation failed.");
        concatBytesCurrent = storageBytes63.concatStorage(memBytes32);
        Assert.equal(concatBytesCurrent, string(hex"f00d000000000000000000000000000000000000000000000000000000feedf00d00000000000000000000000000000000000000000000000000000000feed"), "storageBytes63 + memBytes32 concatenation failed.");
        concatBytesCurrent = storageBytes63.concatStorage(memBytes33);
        Assert.equal(concatBytesCurrent, string(hex"f00d000000000000000000000000000000000000000000000000000000feedf00d0000000000000000000000000000000000000000000000000000000000feed"), "storageBytes63 + memBytes33 concatenation failed.");

        resetStorage();

        //storageBytes64 tests
        concatBytesCurrent = storageBytes64.concatStorage(memBytes4);
        Assert.equal(concatBytesCurrent, string(hex"f00d000000000000000000000000000000000000000000000000000000feedf00dfeed"), "storageBytes64 + memBytes4 concatenation failed.");
        concatBytesCurrent = storageBytes64.concatStorage(memBytes31);
        Assert.equal(concatBytesCurrent, string(hex"f00d000000000000000000000000000000000000000000000000000000feedf00d000000000000000000000000000000000000000000000000000000feed"), "storageBytes64 + memBytes31 concatenation failed.");
        concatBytesCurrent = storageBytes64.concatStorage(memBytes32);
        Assert.equal(concatBytesCurrent, string(hex"f00d000000000000000000000000000000000000000000000000000000feedf00d00000000000000000000000000000000000000000000000000000000feed"), "storageBytes64 + memBytes32 concatenation failed.");
        concatBytesCurrent = storageBytes64.concatStorage(memBytes33);
        Assert.equal(concatBytesCurrent, string(hex"f00d000000000000000000000000000000000000000000000000000000feedf00d0000000000000000000000000000000000000000000000000000000000feed"), "storageBytes64 + memBytes33 concatenation failed.");

        resetStorage();

        //storageBytes65 tests
        concatBytesCurrent = storageBytes65.concatStorage(memBytes4);
        Assert.equal(concatBytesCurrent, string(hex"f00d000000000000000000000000000000000000000000000000000000feedf00dfeed"), "storageBytes65 + memBytes4 concatenation failed.");
        concatBytesCurrent = storageBytes65.concatStorage(memBytes31);
        Assert.equal(concatBytesCurrent, string(hex"f00d000000000000000000000000000000000000000000000000000000feedf00d000000000000000000000000000000000000000000000000000000feed"), "storageBytes65 + memBytes31 concatenation failed.");
        concatBytesCurrent = storageBytes65.concatStorage(memBytes32);
        Assert.equal(concatBytesCurrent, string(hex"f00d000000000000000000000000000000000000000000000000000000feedf00d00000000000000000000000000000000000000000000000000000000feed"), "storageBytes65 + memBytes32 concatenation failed.");
        concatBytesCurrent = storageBytes65.concatStorage(memBytes33);
        Assert.equal(concatBytesCurrent, string(hex"f00d000000000000000000000000000000000000000000000000000000feedf00d0000000000000000000000000000000000000000000000000000000000feed"), "storageBytes65 + memBytes33 concatenation failed.");

        resetStorage();

        //storageBytes70 tests
        concatBytesCurrent = storageBytes70.concatStorage(memBytes4);
        Assert.equal(concatBytesCurrent, string(hex"f00d000000000000000000000000000000000000000000000000000000feedf00dfeed"), "storageBytes70 + memBytes4 concatenation failed.");
        concatBytesCurrent = storageBytes70.concatStorage(memBytes31);
        Assert.equal(concatBytesCurrent, string(hex"f00d000000000000000000000000000000000000000000000000000000feedf00d000000000000000000000000000000000000000000000000000000feed"), "storageBytes70 + memBytes31 concatenation failed.");
        concatBytesCurrent = storageBytes70.concatStorage(memBytes32);
        Assert.equal(concatBytesCurrent, string(hex"f00d000000000000000000000000000000000000000000000000000000feedf00d00000000000000000000000000000000000000000000000000000000feed"), "storageBytes70 + memBytes32 concatenation failed.");
        concatBytesCurrent = storageBytes70.concatStorage(memBytes33);
        Assert.equal(concatBytesCurrent, string(hex"f00d000000000000000000000000000000000000000000000000000000feedf00d0000000000000000000000000000000000000000000000000000000000feed"), "storageBytes70 + memBytes33 concatenation failed.");

    }

}
