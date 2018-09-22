pragma solidity ^0.4.22;

import "truffle/Assert.sol";
import "../contracts/AssertBytes.sol";
import "../contracts/BytesLib.sol";


contract TestBytesLib2 {

    using BytesLib for bytes;

    bytes storageCheckBytes = hex"aabbccddeeff";
    bytes storageCheckBytesZeroLength = hex"";

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

        // This next line is needed in order for Truffle to activate the Solidity unit testing feature
        // otherwise it doesn't interpret any events fired as results of tests
        Assert.equal(uint256(1), uint256(1), "This should not fail! :D");

        AssertBytes.equal(checkBytes, checkBytesRight, "Sanity check should be checking equal bytes arrays out.");
        AssertBytes.notEqual(checkBytes, checkBytesWrongLength, "Sanity check should be checking different length bytes arrays out.");
        AssertBytes.notEqual(checkBytes, checkBytesWrongContent, "Sanity check should be checking different content bytes arrays out.");

        AssertBytes.equalStorage(storageCheckBytes, checkBytesRight, "Sanity check should be checking equal bytes arrays out. (Storage)");
        AssertBytes.notEqualStorage(storageCheckBytes, checkBytesWrongLength, "Sanity check should be checking different length bytes arrays out. (Storage)");
        AssertBytes.notEqualStorage(storageCheckBytes, checkBytesWrongContent, "Sanity check should be checking different content bytes arrays out. (Storage)");

        // Zero-length checks
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
        AssertBytes.equal(resultBytes, testBytes, "Normal slicing array failed.");
        
        testBytes = hex"";
        resultBytes = memBytes.slice(1,0);
        AssertBytes.equal(resultBytes, testBytes, "Slicing with zero-length failed.");
        
        testBytes = hex"";
        resultBytes = memBytes.slice(0,0);
        AssertBytes.equal(resultBytes, testBytes, "Slicing with zero-length on index 0 failed.");
        
        testBytes = hex"feed";
        resultBytes = memBytes.slice(31,2);
        AssertBytes.equal(resultBytes, testBytes, "Slicing across the 32-byte slot boundary failed.");
        
        testBytes = hex"f00d0000000000000000000000000000000000000000000000000000000000feed";
        resultBytes = memBytes.slice(0,33);
        AssertBytes.equal(resultBytes, testBytes, "Full length slice failed.");
        
        testBytes = hex"f00d0000000000000000000000000000000000000000000000000000000000fe";
        resultBytes = memBytes.slice(0,32);
        AssertBytes.equal(resultBytes, testBytes, "Multiple of 32 bytes slice failed.");
        
        testBytes = hex"f00d0000000000000000000000000000000000000000000000000000000000feedf00d00000000000000000000000000000000000000000000000000000000fe";
        resultBytes = memBytes.slice(0,64);
        AssertBytes.equal(resultBytes, testBytes, "Multiple (*2) of 32 bytes slice failed.");

        // Now we're going to test for slicing actions that throw present in the functions below
        // with a ThrowProxy contract
        // v. http://truffleframework.com/tutorials/testing-for-throws-in-solidity-tests
        ThrowProxy throwProxy = new ThrowProxy(address(this));
        bool r;

        TestBytesLib2(address(throwProxy)).sliceIndexThrow();
        r = throwProxy.execute.gas(100000)();
        Assert.isFalse(r, "Slicing with wrong index should throw");

        TestBytesLib2(address(throwProxy)).sliceLengthThrow();
        r = throwProxy.execute.gas(100000)();
        Assert.isFalse(r, "Slicing with wrong length should throw");
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

    function testToUint() public {
        bytes memory memBytes = hex"f00d0000000000000000000000000000000000000000000000000000000000000020feed";

        uint256 testUint = 32; // 0x20 == 32
        uint256 resultUint;

        resultUint = memBytes.toUint(2);
        Assert.equal(resultUint, testUint, "Typecast to unsigned integer failed.");

        // Now we're going to test for slicing actions that throw present in the functions below
        // with a ThrowProxy contract
        // v. http://truffleframework.com/tutorials/testing-for-throws-in-solidity-tests
        ThrowProxy throwProxy = new ThrowProxy(address(this));

        TestBytesLib2(address(throwProxy)).toUintThrow();
        bool r = throwProxy.execute.gas(100000)();
        Assert.isFalse(r, "Typecasting with wrong index should throw");
    }

    function toUintThrow() public pure {
        bytes memory memBytes = hex"f00d0000000000000000000000000000000000000000000000000000000000000042feed";

        uint256 resultUint;

        resultUint = memBytes.toUint(35);
        // This should throw;
    }

    function testToAddress() public {
        bytes memory memBytes = hex"f00dfeed383Fa3B60f9B4AB7fBf6835d3c26C3765cD2B2e2f00dfeed";

        address testAddress = 0x383Fa3B60f9B4AB7fBf6835d3c26C3765cD2B2e2;
        address resultAddress;

        resultAddress = memBytes.toAddress(4);
        Assert.equal(resultAddress, testAddress, "Typecast to address failed.");

        // Now we're going to test for slicing actions that throw present in the functions below
        // with a ThrowProxy contract
        // v. http://truffleframework.com/tutorials/testing-for-throws-in-solidity-tests
        ThrowProxy throwProxy = new ThrowProxy(address(this));

        TestBytesLib2(address(throwProxy)).toAddressThrow();
        bool r = throwProxy.execute.gas(100000)();
        Assert.isFalse(r, "Typecasting with wrong index should throw");
    }

    function toAddressThrow() public pure {
        bytes memory memBytes = hex"f00dfeed383FA3b60F9b4ab7FBF6835D3c26C3765Cd2B2E2f00dfeed";

        address resultAddress;

        resultAddress = memBytes.toAddress(35);
        // This should throw;
    }

}

// Proxy contract for testing throws
contract ThrowProxy {
    address public target;
    bytes data;

    constructor(address _target) public {
        target = _target;
    }

    //prime the data using the fallback function.
    function() public {
        data = msg.data;
    }

    function execute() public returns (bool) {
        return target.call(data);
    }
}
