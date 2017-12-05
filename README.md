# Solidity Bytes Arrays Utils

Bytes tightly packed arrays utility library for ethereum contracts written.

Still not deployed on mainnet or EPM but Coming Soon™.


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


* `function equalStorage(bytes memory _preBytes, bytes memory _postBytes) internal view returns (bool)`

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
