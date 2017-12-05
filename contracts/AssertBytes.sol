pragma solidity 0.4.18;


/*
*  This library doesn't enforce the 32-byte zero-padding the compiler
*   does since newer versions and instead presupposes that inconsistencies
*   wouldn't 
*/
library AssertBytes {
    // Event to maintain compatibility with Truffle's Assertion Lib
    event TestEvent(bool indexed result, string message);

    /*
        Function: equal(bytes memory, bytes memory)

        Assert that two tightly packed bytes arrays are equal.

        Params:
            A (bytes) - The first bytes.
            B (bytes) - The second bytes.
            message (string) - A message that is sent if the assertion fails.

        Returns:
            result (bool) - The result.
    */
    function _equal(bytes memory _a, bytes memory _b) internal returns (bool) {
        bool returnBool = false;

        assembly {
            let length := mload(_a)

            // if lengths don't match the arrays are not equal
            jumpi(unsuccess, iszero(eq(length, mload(_b))))
            
            let mc := add(_a, 0x20)
            let end := add(mc, length)

            for {
                let cc := add(_b, 0x20)
            } lt(mc, end) {
                mc := add(mc, 0x20)
                cc := add(cc, 0x20)
            } {
                // if any of these checks fails then arrays are not equal
                jumpi(unsuccess, iszero(eq(mload(mc), mload(cc))))
            }

            // success: all conditions check out, we'll jump over unsuccess :D
            returnBool := 1
        unsuccess:
            // Now we have to compensate for the stack unbalance here because the stack
            //  height analyser goes top-down opcode by opcode and not by control flow
            //  v. http://solidity.readthedocs.io/en/develop/assembly.html#labels
            42 // The meaning of life
        }

        return returnBool;
    }

    function equal(bytes memory _a, bytes memory _b, string message) internal returns (bool) {
        bool returnBool = _equal(_a, _b);

        _report(returnBool, message);

        return returnBool;
    }

    function notEqual(bytes memory _a, bytes memory _b, string message) internal returns (bool) {
        bool returnBool = _equal(_a, _b);

        _report(!returnBool, message);

        return !returnBool;
    }

    /*
        Function: equal(bytes storage, bytes memory)

        Assert that two tightly packed bytes arrays are equal.

        Params:
            A (bytes) - The first bytes.
            B (bytes) - The second bytes.
            message (string) - A message that is sent if the assertion fails.

        Returns:
            result (bool) - The result.
    */
    function _equalStorage(bytes storage _a, bytes memory _b) internal returns (bool) {
        bool returnBool = false;

        assembly {
            // we know _a_offset is 0
            let fslot := sload(_a_slot)
            let slength := div(and(fslot, sub(mul(0x100, iszero(and(fslot, 1))), 1)), 2)
            let mlength := mload(_b)

            // if lengths don't match the arrays are not equal
            jumpi(unsuccess, iszero(eq(slength, mlength)))

            // slength can contain both the length and contents of the array
            // if length < 32 bytes so let's prepare for that
            // v. http://solidity.readthedocs.io/en/latest/miscellaneous.html#layout-of-state-variables-in-storage
            switch lt(slength, 32)
            case 1 {
                // blank the last byte which is the length
                fslot := mul(div(fslot, 0x100), 0x100)

                jumpi(unsuccess, iszero(eq(fslot, mload(add(_b, 0x20)))))
            }
            default {
                // get the keccak hash to get the contents of the array
                mstore(0x0, _a_slot)
                let sc := keccak256(0x0, 0x20)
                
                let mc := add(_b, 0x20)
                let end := add(mc, mlength)
                
                for {} lt(mc, end) {
                    sc := add(sc, 1)
                    mc := add(mc, 0x20)
                } {
                    jumpi(unsuccess, iszero(eq(sload(sc), mload(mc))))
                }
            }

            // success: all conditions check out, we'll jump over unsuccess :D
            returnBool := 1
        unsuccess:
            // Now we have to compensate for the stack unbalance here because the stack
            //  height analyser goes top-down opcode by opcode and not by control flow
            //  v. http://solidity.readthedocs.io/en/develop/assembly.html#labels
            42 // The meaning of life
        }

        return returnBool;
    }

    function equalStorage(bytes storage _a, bytes memory _b, string message) internal returns (bool) {
        bool returnBool = _equalStorage(_a, _b);

        _report(returnBool, message);

        return returnBool;
    }

    function notEqualStorage(bytes storage _a, bytes memory _b, string message) internal returns (bool) {
        bool returnBool = _equalStorage(_a, _b);

        _report(!returnBool, message);

        return !returnBool;
    }

    /********** Maintaining compatibility with Truffle's Assert.sol ***********/
    /******************************** internal ********************************/

    /*
        Function: _report

        Internal function for triggering <TestEvent>.

        Params:
            result (bool) - The test result (true or false).
            message (string) - The message that is sent if the assertion fails.
    */

    function _report(bool result, string message) internal {
        if (result)
            TestEvent(true, "");
        else
            TestEvent(false, message);
    }
}