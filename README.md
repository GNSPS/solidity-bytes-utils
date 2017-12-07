[ ![Codeship Status for GNSPS/solidity-bytes-utils](https://app.codeship.com/projects/45b97080-bc0c-0135-fb75-76c2fb8e249b/status?branch=master)](https://app.codeship.com/projects/259449)

# Solidity Bytes Arrays Utils

Bytes tightly packed arrays utility library for ethereum contracts written.

Given this library has an all-internal collection of methods it doesn't make sense in having it reside in the mainnet. Instead it will only be available in EPM as an installable package.

## Usage

You can use the library here present by direct download and importing with:
```
import "BytesLib.sol";
```

or, if you have installed it from EPM (see below), with Truffle's specific paths:
```
import "bytes/BytesLib.sol";`
```

Usage examples and API are more thoroughly explained below.

Also there's an extra library in there called `AssertBytes` (inside the same named file) which is compatible with Truffle's Solidity testing library `Assert.sol` event firing and so let's you now test bytes equalities/inequalities in your Solidity tests by just importing it in your `.sol` test files:
```
import "bytes/AssertBytes.sol";
```

and use the library `AssertByte` much like they use `Assert` in Truffle's [example](http://truffleframework.com/docs/getting_started/solidity-tests).

## EthPM

This library is published at EPM under the alias `bytes`

**Installing it with Truffle**

```
truffle install bytes
```

## Contributing

Contributions are more than welcome in any way shape or form! 😄

## API

* `function concat(bytes memory _preBytes, bytes memory _postBytes) internal pure returns (bytes)`

Concatenates two `bytes` arrays in memory and returns the concatenation result as another `bytes` array in memory.


* `function concatStorage(bytes storage _preBytes, bytes memory _postBytes) internal pure`

Concatenates a `bytes` array present in memory directly into the given storage location addressed by the `_preBytes` storage pointer.


* `function slice(bytes _bytes, uint _start, uint _length) internal  pure returns (bytes)`

Takes a slice from a `bytes` array in memory of given `length` starting from `_start`th byte counting from the left-most one (0-based).


* `function toAddress(bytes _bytes, uint _start) internal  pure returns (address)`

Takes a 20-byte-long sequence present in a `bytes` array in memory and returns that as an address (also checks for sufficient length).


* `function toUint(bytes _bytes, uint _start) internal  pure returns (uint256)`

Takes a 32-byte-long sequence present in a `bytes` array in memory and returns that as an unsigned integer (also checks for sufficient length).


* `function equal(bytes memory _preBytes, bytes memory _postBytes) internal view returns (bool)`

Compares two `bytes` arrays in memory and returns the comparison result as a `bool` variable.


* `function equalStorage(bytes storage _preBytes, bytes memory _postBytes) internal view returns (bool)`

Compares a `bytes` array in storage against another `bytes` array in memory and returns the comparison result as a `bool` variable.


## Examples

Ordered to mimic the above `API` section ordering:

```javascript
bytes memory _preBytes = hex"f00dfeed";
bytes memory _postBytes = hex"f00dfeed";

bytes memory concatBytes = BytesLib.concat(_preBytes, _postBytes);

// concatBytes == 0xf00dfeedf00dfeed
```


```javascript
contract MyContract {
	bytes storageBytes = hex"f00dfeed";

	function myFunc() {
		bytes memory _postBytes = hex"f00dfeed";

		BytesLib.concatStorage(storageBytes, _postBytes);

		// storageBytes == 0xf00dfeedf00dfeed
	}
}
```


```javascript
bytes memory memBytes = hex"f00dfeedaabbccddeeff";

bytes memory slice1 = BytesLib.slice(memBytes, 0, 2);
bytes memory slice2 = BytesLib.slice(memBytes, 2, 2);

// slice1 == 0xf00d
// slice2 == 0xfeed
```


```javascript
bytes memory memBytes = hex"f00dfeed383FA3b60F9b4ab7FBF6835D3c26C3765Cd2B2E2f00dfeed";

address addrFromBytes = BytesLib.toAddress(memBytes, 4);

// addrFromBytes == 0x383FA3b60F9b4ab7FBF6835D3c26C3765Cd2B2E2
```


```javascript
bytes memory memBytes = hex"f00dfeed383FA3b60F9b4ab7FBF6835D3c26C3765Cd2B2E2f00dfeed";

address addrFromBytes = BytesLib.toAddress(memBytes, 4);

// addrFromBytes == 0x383FA3b60F9b4ab7FBF6835D3c26C3765Cd2B2E2
```


```javascript
bytes memory memBytes = hex"f00dfeed";
bytes memory checkBytesTrue = hex"f00dfeed";
bytes memory checkBytesFalse = hex"00000000";

bool check1 = BytesLib.equal(memBytes, checkBytesTrue);
bool check2 = BytesLib.equal(memBytes, checkBytesFalse);

// check1 == true
// check2 == false
```


```javascript
contract MyContract {
	bytes storageBytes = hex"f00dfeed";

	function myFunc() {
		bytes memory checkBytesTrue = hex"f00dfeed";
		bytes memory checkBytesFalse = hex"00000000";

		bool check1 = BytesLib.equalStorage(storageBytes, checkBytesTrue);
		bool check2 = BytesLib.equalStorage(storageBytes, checkBytesFalse);

		// check1 == true
		// check2 == false
	}
}
```
