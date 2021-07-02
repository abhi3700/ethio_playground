# ethio_playground
Ethereum Contracts [helpful for EOSIO Developers]

## Introduction
* The contract code can't be updated, but all the state variables can be updated.

## Installation
### Editor
* Sublime Text 3
	- packages
		+ [Solidity Docstring Generator](https://packagecontrol.io/packages/Solidity%20Docstring%20Generator)
		+ [Ethereum]()

## Compile
* Ethereum smart contracts are generally written in Solidity and then compiled into EVM bytecode and corresponding ABI via solc.

> NOTE: most people do not compile contracts directly through commands, because there are very convenient tools and frameworks such as remix or truffle.

* Comparo

| | Solidity | EOSIO |
|--|------|---|
| Compile Contract | solcjs --abi --bin hello.sol | eosio-cpp hello.cpp -o hello.wasm |
| Deployment contract |	hello=(web3.eth.contract([…])).new({…}) |	cleos set contract hello ./hello -p hello@active |
| Call contract | hello.hi.sendTransaction(…) | cleos push action hello hi '["bob"]' -p bob@active |

## Deploy
* The address of the contract account (not external account) is automatically generated at deployment time, and the contract can never be changed once deployed.
* In ETH, gas fee is analogous to EOS's RAM (for contract storage), CPU, NET (follow staked or powerup model). `EOSIO's CPU & NET` <-> `ETH's gas fee`
* In ETH, an object is created based on ABI in the `geth` console and then calls the `new()` method to initiate a contract creation txn (parameters contain bytecode), whereas in EOSIO's `cleos` tool, `set()` method is used to specify the bytecode and the directory where the ABI is located.
* [Remix](https://remix-ide.readthedocs.io/en/latest/run.html)
	- [Environments](https://remix-ide.readthedocs.io/en/latest/run.html#environment)
```
JavaScript VM: All the transactions will be executed in a sandbox blockchain in the browser. This means nothing will be persisted when you reload the page. The JsVM is its own blockchain and on each reload it will start a new blockchain, the old one will not be saved.
Injected Provider: Remix will connect to an injected web3 provider. Metamask is an example of a provider that inject web3.
Web3 Provider: Remix will connect to a remote node. You will need to provide the URL to the selected provider: geth, parity or any Ethereum client.
```

## Call
* The call method is only executed locally, does not generate transactions and does not consume gas, `sendTransaction()` method will generate transactions and consume gas, the transaction is executed by the miner and packaged into the block, while modifying the account status.

## Coding

### [Style Guide](https://docs.soliditylang.org/en/v0.8.6/style-guide.html)
* Summary: Prefer CamelCase for contracts & firstSecond type of font style for functions, variables.

### Layout
* Elements
	1. The pragma statement
	1. Import statements
	1. Interfaces
	1. Libraries
	1. Contracts

> NOTE: Libraries, interfaces, and contracts have their own elements as well. They should go in this order:

> - Type declarations

> - State variables

> - Events

> - Functions

### Contract
* Contracts and libraries should be named using the CapWords style. Examples: SimpleToken, SmartBank, CertificateHashRepository, Player, Congress, Owned.
* Contract and library names should also match their filenames.
* If a contract file includes multiple contracts and/or libraries, then the filename should match the core contract.
* Contracts consist of 2 main types:
	- Persistent data kept in __state variables__
	- Runnable __functions__ that can modify state variables

* Each contract can contain declarations of State Variables, Functions, Function Modifiers, Events, Errors, Struct Types and Enum Types. Furthermore, contracts can inherit from other contracts.

> NOTE: unlike in other languages, you don’t need to use the keyword this to access state variables.

* Creating contracts programmatically on Ethereum is best done via using the JavaScript API `web3.js`. It has a function called `web3.eth.Contract` to facilitate contract creation.
* A constructor is optional. Only one constructor is allowed, which means overloading is not supported.
* When a contract is created, its constructor (a function declared with the constructor keyword) is executed once.
* A constructor is optional. Only one constructor is allowed, which means overloading is not supported.
* Inheritance:
```
// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.4.0 <0.9.0;

import "./Owned.sol";


contract Congress is Owned, TokenRecipient {
    //...
}
```
* The contract should be named using the CapWords specification (first letter)capital）
```
contract BucketCrow {
    // ...
}
```

#### [State Variable types](https://docs.soliditylang.org/en/develop/types.html#types)
#### Variable
* By default, the variables are private (i.e. not accessed from external). 

> Note: It's actually not private storage var, as ETH is a public blockchain.

* For array variable declarations, the parentheses in types and arrays cannot have spaces directly.
```
The way to standardize:
 
uint[] x;
 
 ❌ Unregulated way:
 
uint [] x;
```
* There must be a space on both sides of the assignment operator
```
The way to standardize:
 
x = 3;x = 100 / 10;x += 3 + 4;x |= y && z;
 
 ❌ Unregulated way:
 
x=3;x = 100/10;x += 3+4;x |= y&&z;
```
* In order to display priority, there must be spaces between the precedence operator and the low priority operator, which is also to improve the readability of complex declarations. The number of spaces on either side of the operator must be the same.
```
The way to standardize:
 
x = 2**3 + 5;x = 2***y + 3*z;x = (a+b) * (a-**b);
 
 ❌ Unregulated way:
 
x = 2** 3 + 5;x = y+z;x +=1;
```
* Visibility: private, public, internal
* [More style guides](https://docs.soliditylang.org/en/v0.8.6/style-guide.html#variable-declarations)

#### [Enums](https://docs.soliditylang.org/en/develop/types.html#enums) cannot have more than 256 members
* Statement initialscapital, define the first letter of the enum enumeration variablelower case,Such as:
```
// Game status
enum GameState {
         GameStart, // Game starts
         InGaming, // In game
         GameOver // Game is over
}
    
 GameState public gameState; // The state of the current game    
```

#### Event
* Statement initialscapital, variable initialslower case, send event to add keywordsemit,Such as:
```
event Deposit(
         Address from, // transfer address
         Uint amount // transfer amount
);
 
function() public payable {
    emit Deposit(msg.sender, msg.value);
}
```

#### [Function](https://docs.soliditylang.org/en/develop/types.html#enums)
```
function (<parameter types>) {internal|external} [pure|view|payable] [returns (<return types>)]
```

* by default, functions are internal, so no need to write anything, or else, mention `public` 
* Getter methods are marked `view`.
* `constant` on functions is an alias to `view`, but this is deprecated and is planned to be dropped in version 0.5.0.
* Functions can be declared pure in which case they promise not to read from or modify the state.
* function visibility
```
public - all can access
external - Cannot be accessed internally, only externally
internal - only this contract and contracts deriving from it can access
private - can be accessed only from this contract
```
* In private access, the function is defined by prefixing underscore `_`. E.g. `function _getValue() returns(uint) { }`. Also, the function is no more visible in the IDE (e.g. Try in Remix)
* multiple output function
```
// M-1
function getValue() external view returns(address, address) {
    return (tx.origin, msg.sender);
}

// M-2
function getValue2() external pure returns(uint sum, uint product) {
	  uint v1 = 1;
	  uint v2 = 2;

	  sum = v1 + v2;
	  product = v1 * v2;
	  return (sum, product);
}
```
* For function declarations with more parameters, all parameters can be displayed line by line and remain the same indentation. The right parenthesis of the function declaration is placed on the same line as the left parenthesis of the function body, and remains the same indentation as the function declaration.
```
The way to standardize:
 
function thisFunctionHasLotsOfArguments(
    address a,
    address b,
    address c,
    address d,
    address e,
    address f
) {
    do_something;
}
 
 ❌ Unregulated way:
 
function thisFunctionHasLotsOfArguments(address a, address b, address c,
    address d, address e, address f) {
    do_something;
}
```
* If the function includes multiple modifiers, you need to branch the modifiers and indent them line by line. The left parenthesis of the function body is also branched.
```
The way to standardize:
 
function thisFunctionNameIsReallyLong(address x, address y, address z)
    public
    onlyowner
    priced
    returns (address)
{
    do_something;
}
 
 ❌ Unregulated way:
 
function thisFunctionNameIsReallyLong(address x, address y, address z)
    public onlyowner priced returns (address){
    do_something;
}
```
* For a derived contract that requires a parameter as a constructor, if the function declaration is too long or difficult to read, it is recommended to display the constructor of the base class in its constructor independently.
```
The way to standardize:
 
contract A is B, C, D {
 
    function A(uint param1, uint param2, uint param3, uint param4, uint param5)
        B(param1)
        C(param2, param3)
        D(param4)
    {
        // do something with param5
    }
    
}
 
 ❌ Unregulated way:
 
contract A is B, C, D {
 
    function A(uint param1, uint param2, uint param3, uint param4, uint param5)
    B(param1)
    C(param2, param3)
    D(param4)
    {
        // do something with param5
    }
 
}
```
* [More style guides](https://docs.soliditylang.org/en/v0.8.6/style-guide.html#function-declaration)

#### constant
* Constant definitions are all usedcapitalEasy to distinguish from variables and function parameters, such as:
```
Uint constant public ENTRANCE_FEE = 1 ether; // admission fee
```

#### Storage
```
// according to roomId => gameId => playerId => Player
mapping (uint => mapping (uint => mapping (uint => Player))) public players;    
```

#### Mapping
* can't be iterated across the keys unlike arrays.
* Example - [Mapping.sol](./base/Mapping/Mapping.sol)
* check if key exists:
```
if (abi.encodePacked(balances[addr]).length > 0) {
    delete balances[addr];
}
```
* delete key: `delete balances[addr]`

#### Array
* delete at an index using `delete myArray[3]`
* delete the last element using `delete myArray[myArray.length-1]`
* If you start with an array [A,B,C,D,E,F,G] and you delete "D", then you will have an array [A,B,C,nothing,E,F,G]. It's no shorter than before.
* Get all elements
```
function getAllElement() public view returns (uint[]) {
		return arr;
}
```
* test array variable
```
assert(a[6] == 9);
```
* pop element
```
function popElement() public returns (uint []){
    delete arr[arr.length-1];
    arr.length--;
    return arr;
 }
```

#### Modifiers
* Modifier definition useHump ​​nomenclature,Initialslower case,Such as:
```
modifier onlyOwner {
    require (msg.sender == owner, "OnlyOwner methods called by non-owner.");
    _;
}
```
* The default modifier should be placed before other custom modifiers.
```
The way to standardize:
 
function kill() public onlyowner {
 
    selfdestruct(owner);
 
}
 
 ❌ Unregulated way:
 
function kill() onlyowner public {
 
    selfdestruct(owner);
 
}
```

### Special Variables and Functions
* There are special variables and functions which always exist in the global namespace and are mainly used to provide information about the blockchain or are general-use utility functions
```solidity
blockhash(uint blockNumber) returns (bytes32): hash of the given block when blocknumber is one of the 256 most recent blocks; otherwise returns zero
block.chainid (uint): current chain id
block.coinbase (address payable): current block miner’s address
block.difficulty (uint): current block difficulty
block.gaslimit (uint): current block gaslimit
block.number (uint): current block number
block.timestamp (uint): current block timestamp as seconds since unix epoch
gasleft() returns (uint256): remaining gas
msg.data (bytes calldata): complete calldata
msg.sender (address): sender of the message (current call)
msg.sig (bytes4): first four bytes of the calldata (i.e. function identifier)
msg.value (uint): number of wei sent with the message
tx.gasprice (uint): gas price of the transaction
tx.origin (address): sender of the transaction (full call chain)
```

## Miscellaneous
### Don'ts
* Avoid parentheses, brackets, and spaces after curly braces
```
The way to standardize: 
 
spam(ham[1], Coin({name: “ham”}));
 
 ❌ Unregulated way: 
 
spam( ham[ 1 ], Coin( { name: “ham” } ) );
```

* Avoid spaces before commas and semicolons
```
The way to standardize: 
 
function spam(uint i, Coin coin);
 
 ❌ Unregulated way: 
 
function spam(uint i , Coin coin) ;
```
* Avoid multiple spaces before and after the assignment
```
The way to standardize:
 
x = 1;
y = 2;
long_variable = 3;
 
 ❌ Unregulated way:
 
x             = 1;
y             = 2;
long_variable = 3;
```
* Control structure
```
The way to standardize:
 
contract Coin {
    struct Bank {
        address owner;
        uint balance;
    }
}
 
 ❌ Unregulated way:
 
contract Coin
{
    struct Bank {
        address owner;
        uint balance;
    }
}
```
* For the control structure, if there is only a single statement, you don't need to use parentheses.
```
The way to standardize:
 
if (x < 10)
 
    x += 1;
    
 ❌ Unregulated way:
 
if (x < 10)
 
    someArray.push(Coin({
 
        name: 'spam',
 
        value: 42
 
    }));    
```
* [Names to avoid](https://docs.soliditylang.org/en/v0.8.6/style-guide.html#names-to-avoid)


### Types
* fixed-size types
```
bool isReady;
uint a;			// uint alias for uint256
address recipient;
bytes32 data;
```
* variable-size types
```
string name;
bytes _data;
uint[] amounts;
mapping(uint => string) users;
```
* user-defined data
```
struct User {
	uint id;
	string name;
	uint[] friendIds;
}

enum {
	RED,
	BLUE,
	GREEN
}
```

### Facts
* Main global variables: `block`, `msg`, `tx`
* Instead of `string`, `bytes32` data type is used for security reasons & also to save memory. This is because, in ASCII encoding, each character needs 8 bits, whereas in Unicode encoding, each character needs 16 bits
	- E.g. “Hello World”, ASCII size = ( 11 * 8)/8 = 11 Bytes & Unicode size = ( 11 * 16)/8 = 22 Bytes.
	- Then there are language specific things that get added up to these. For example in C, we will need an ‘\0’ at end of each string(char array), so we will need an extra byte.
	- Unicode is widely used these days, as it supports multiple languages and emotions to be represented.
* Which one to use `external` or `public`?
	- depends on what consumes more gas
	- with the latest solidity version 0.8.4:
```
// SPDX-License-Identifier: MIT

pragma solidity 0.8.4;

contract ExternalPublicTest {
    function test(uint[20] memory a) public pure returns (uint){
         return a[10]*2;
    }

    function test2(uint[20] calldata a) public pure returns (uint){
         return a[10]*2;
    }    
}
```

	- It's actually about `memory` or `calldata`. The former would consume more gas (491 wei) & the later would consume 260 wei gas.
* `view` vs `pure` in function
	- `view` demo: Here, the function is making a change (optional) into the state variables num1, num2 & getting the output. 
```
// Solidity program to 
// demonstrate view
// functions
pragma solidity ^0.5.0;
  
// Defining a contract
contract Test {
      
    // Declaring state 
    // variables
    uint num1 = 2; 
    uint num2 = 4;
  
   // Defining view function to  
   // calculate product and sum 
   // of 2 numbers
   function getResult(
   ) public view returns(
     uint product, uint sum){
       uint num1 = 10;
       uint num2 = 16;
      product = num1 * num2;
      sum = num1 + num2; 
   }
}
```
	- `pure` demo: Here, the function won't be able to read the state variables num1, num2 or even modify num1, num2, but getting the output. 
```
// Solidity program to
// demonstrate pure functions
pragma solidity ^0.5.0;

// Defining a contract
contract Test {

	// Defining pure function to
	// calculate product and sum
	// of 2 numbers
	function getResult(
	) public pure returns(
		uint product, uint sum){
		uint num1 = 2;
		uint num2 = 4;
		product = num1 * num2;
		sum = num1 + num2;
	}
}
```

## DEPRECATED
* `constant` replaced by `view` in function
* `msg.gas` replaced by `gasleft()` in global variables
* `now` replaced by `block.timestamp` in global variables

## References
* [From Solidity to EOS contract development](https://www.programmersought.com/article/6940225644/)
* [Solidity contract development specification](https://www.programmersought.com/article/4362686832/)
* [Contract Hacks challenges](https://capturetheether.com/challenges/)
* [Solidity Tutorial playlist](https://www.youtube.com/watch?v=jPHXG82WCYA&list=PLbbtODcOYIoE0D6fschNU4rqtGFRpk3ea)