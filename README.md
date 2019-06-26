![Codeship Status for GNSPS/solidity-bytes-utils](https://app.codeship.com/projects/45b97080-bc0c-0135-fb75-76c2fb8e249b/status?branch=master)

# Solidity Bytes Arrays Utils

Bytes tightly packed arrays utility library for ethereum contracts written in Solidity.

The library lets you concatenate, slice and type cast bytes arrays both in memory and storage.

Given this library has an all-internal collection of methods it doesn't make sense having it reside in the mainnet. Instead it will only be available in EPM as an installable package.

_Note_: Since version `v0.0.7` the library will only compile on Solidity versions `>0.4.22` so, if you need `v0.4.x` support for your project just use `v0.0.6` of the library with:
```
$ truffle install bytes@0.0.6
```
or
```
$ npm install solidity-bytes-utils@0.0.6
```

## Usage

You can use the library here present by direct download and importing with:
```
import "BytesLib.sol";
```

or, if you have installed it from EPM (see below), with Truffle's specific paths:
```
import "bytes/BytesLib.sol";
```

Usage examples and API are more thoroughly explained below.

Also there's an extra library in there called `AssertBytes` (inside the same named file) which is compatible with Truffle's Solidity testing library `Assert.sol` event firing and so lets you now test bytes equalities/inequalities in your Solidity tests by just importing it in your `.sol` test files:
```
import "bytes/AssertBytes.sol";
```

and use the library `AssertBytes` much like they use `Assert` in Truffle's [example](http://truffleframework.com/docs/getting_started/solidity-tests).

## EthPM

This library is published in EPM under the alias `bytes`

**Installing it with Truffle**

```
$ truffle install bytes
```

## NPM

This library is published in NPM under the alias `solidity-bytes-utils`

**Installing it with NPM**

```
$ npm install solidity-bytes-utils
```

**Importing it in your Solidity contract**

```
import "solidity-bytes-utils/contracts/BytesLib.sol";
```

## Contributing

Contributions are more than welcome in any way shape or form! 😄

TODOs:
* Two storage bytes arrays concatenation
* Slicing directly from storage
* Implement inline assembly functions for better readability

### Testing

This project uses Truffle for tests. Truffle's version of `solc` needs to be at least 0.4.19 for the contracts to compile. If you encounter compilation errors, try:

    $ cd /usr/local/lib/node_modules/truffle
    $ npm install solc@latest

To run the tests, start a `testrpc` instance, then run `truffle test`.

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
contract MyContract {
	using BytesLib for bytes;

	function myFunc() {
		bytes memory _preBytes = hex"f00dfeed";
		bytes memory _postBytes = hex"f00dfeed";

		bytes memory concatBytes = _preBytes.concat(_postBytes);

		// concatBytes == 0xf00dfeedf00dfeed
	}
}
```


```javascript
contract MyContract {
	using BytesLib for bytes;

	bytes storageBytes = hex"f00dfeed";

	function myFunc() {
		bytes memory _postBytes = hex"f00dfeed";

		storageBytes.concatStorage(_postBytes);

		// storageBytes == 0xf00dfeedf00dfeed
	}
}
```


```javascript
contract MyContract {
	using BytesLib for bytes;

	function myFunc() {
		bytes memory memBytes = hex"f00dfeedaabbccddeeff";

		bytes memory slice1 = memBytes.slice(0, 2);
		bytes memory slice2 = memBytes.slice(2, 2);

		// slice1 == 0xf00d
		// slice2 == 0xfeed
	}
}
```


```javascript
contract MyContract {
	using BytesLib for bytes;

	function myFunc() {
		bytes memory memBytes = hex"f00dfeed383Fa3B60f9B4AB7fBf6835d3c26C3765cD2B2e2f00dfeed";

		address addrFromBytes = memBytes.toAddress(4);

		// addrFromBytes == 0x383Fa3B60f9B4AB7fBf6835d3c26C3765cD2B2e2
	}
}
```


```javascript
contract MyContract {
	using BytesLib for bytes;

	function myFunc() {
		bytes memory memBytes = hex"f00d0000000000000000000000000000000000000000000000000000000000000042feed";

		uint256 uintFromBytes = memBytes.toUint(2);

		// uintFromBytes == 42
	}
}
```


```javascript
contract MyContract {
	using BytesLib for bytes;

	function myFunc() {
		bytes memory memBytes = hex"f00dfeed";
		bytes memory checkBytesTrue = hex"f00dfeed";
		bytes memory checkBytesFalse = hex"00000000";

		bool check1 = memBytes.equal(checkBytesTrue);
		bool check2 = memBytes.equal(checkBytesFalse);

		// check1 == true
		// check2 == false
	}
}
```


```javascript

contract MyContract {
	using BytesLib for bytes;

	bytes storageBytes = hex"f00dfeed";

	function myFunc() {
		bytes memory checkBytesTrue = hex"f00dfeed";
		bytes memory checkBytesFalse = hex"00000000";

		bool check1 = storageBytes.equalStorage(checkBytesTrue);
		bool check2 = storageBytes.equalStorage(checkBytesFalse);

		// check1 == true
		// check2 == false
	}
}
```
