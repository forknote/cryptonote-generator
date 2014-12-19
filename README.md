cryptonote-generator
==================

A python / bash Cryptonote source creator. Generate and compile new or maintain old code with a single command. 

#### Table of Contents

* [Features](#features)
* [Community Support](#community--support)
* [Pools Using This Software](#pools-using-this-software)
* [Usage](#usage)
  * [Requirements](#requirements)
  * [Downloading & Installing](#1-downloading--installing)
  * [Configuration](#2-configuration)
  * [Generate coin](#3-generate-coin)
* [Examples](#examples)
  * [Dashcoin](#1-dashcoin)
  * [Bitcoin emission curve coin](#2-bitcoin-emission-curve-coin)
* [Contributing](#contributing)

#### Features

* Cryptonote source code creation, based on the latest Bytecoin code
* Plugin based code creation
* Simple update for existing code
* Compilation for
  * Windows
  * Ubuntu
  * Mac OS X

### Community / Support

* [CryptoNote Forum](https://forum.cryptonote.org/)
* [Bytecoin Github](https://github.com/amjuarez/bytecoin)
* [Dashcoin Announcement Thread](https://bitcointalk.org/index.php?topic=678232.0)
* IRC (freenode)
  * Support / general / development discussion join #dashcoin: [https://webchat.freenode.net/?channels=#dashcoin](https://webchat.freenode.net/?channels=#dashcoin)


#### Coins Using This Software

* [Dashcoin](http://dashcoin.net)

Usage
===

#### Requirements
* Cygwin - [https://cygwin.com](https://cygwin.com) (Windows only)
* GCC 4.7.3 or later
* or CMake 2.8.6 or later
* Boost 1.53 or later (but don’t use 1.54)


#### 1) Downloading & Installing


Clone the repository:

```bash
	git clone https://github.com/dashcoin/cryptonote-generator.git generator
	cd generator
```

#### 2) Configuration


*Warning for existing Cryptonote coins other than Dashcoin:* this software may or may not work with any given cryptonote coin.

Copy the `config_example.json` file to `config.json` then overview each options and change any to match your preferred setup.


Explanation for each field:


```
{

/* Plugins to load */ 
"plugins": [ "core/bytecoin.py" ],

/* Tests to run. Executed after the plugins load */
"tests": [ "core/bytecoin-test.sh" ],

/* Source coin. Bytecoin example */ 
"base_coin":{
	"name":"bytecoin",		
	"git":"https://github.com/amjuarez/bytecoin.git"
},

"core":{
	/* Check uniqueness with Google and Map of Coins. */
	"CRYPTONOTE_NAME":"dashcoin",
	"daemon_name":"dashcoind",

	/* Address prefix. Generate here: https://cryptonotestarter.org/inner.html */
	"CRYPTONOTE_PUBLIC_ADDRESS_BASE58_PREFIX":72,

	"P2P_DEFAULT_PORT":29080,
	"RPC_DEFAULT_PORT":29081,

	/* Seed nodes. Use at least 2 */
	"SEED_NODES":["162.243.247.45:29080", "146.185.191.90:29080", "104.131.132.129:29080", "128.199.146.243:29080"],

	/* Array with checkpoints. */
	"CHECKPOINTS":"{28000, \"70d2531151529ac00bf875281e15f51324934bc85e5733dcd92e1ccb1a665ff8\"}, {40000, \"c181ec9223a91fef8658c7aa364c093c41c28d250870ca1ed829bf74f0abf038\"}, {55000, \"5289fe9f2dce8f51441019b9fbc85c70ad85ff49a666ef0109f3269890c6af6d\"}, {70000, \"193e335f34b8b8f1fab3857111cb668c2720340e80176a25155071e573481acb\"}, {87500, \"cce8a035f34457ec1098ab41e5949cac3db00ebff3503e26f36bfa057543095a\"}, {91453, \"ad46d069bb2726a9bc5962cda6b2108376c0b95c157da0f09ee32458f486d87f\"}",
	
	/* Created with connectivity_tool. Leave empty if not needed */
	"P2P_STAT_TRUSTED_PUB_KEY":"4d26c4df7f4ca7037950ad026f9ab36dd05d881952662992f2e4dcfcafbe57eb",

	/* Generated with --print-genesis-tx argument. */
	"genesisCoinbaseTxHex":"010a01ff0001ffffffffffff0f029b2e4c0271c0b42e7c53291a94d1c0cbff8883f8024f5142ee494ffbbd08807121013c086a48c15fb637a96991bc6d53caf77068b5ba6eeb3c82357228c49790584a",

	/* Random hex, identifier for your network */
	"BYTECOIN_NETWORK":"0x12, 0x11, 0x21, 0x11, 0x11, 0x10, 0x41, 0x01, 0x13, 0x11, 0x00, 0x12, 0x12, 0x11, 0x01, 0x10",

	/* Visualize here https://cryptonotestarter.org/inner.html  */
	/* Total amount of coins to be emitted. Most of CryptoNote-based coins use (uint64_t)(-1) (equals to 18446744073709551616).
	   You can define number explicitly (for example UINT64_C(858986905600000000)). */
	"MONEY_SUPPLY":"static_cast<uint64_t>(-1)",
	"EMISSION_SPEED_FACTOR":18,
	"DIFFICULTY_TARGET":120,   // In seconds

	"MINIMUM_FEE":1000000,   // 10^6. Equals to 0.01 in Dashcoin
	"DEFAULT_DUST_THRESHOLD":1000000,
	"COIN":100000000,    // Number of atom units in a coin. 10^8 in Dashcoin
	"CRYPTONOTE_DISPLAY_DECIMAL_POINT":8,    // The pow from the previews value

	"CRYPTONOTE_MINED_MONEY_UNLOCK_WINDOW":10,    // in blocks
	"CRYPTONOTE_BLOCK_GRANTED_FULL_REWARD_ZONE":20000,    // in bytes

	/* USED ONLY IN OLD COINS. IF YOU UPDATE CHANGE THIS TO YOUR OLD CRYPTONOTE_BLOCK_GRANTED_FULL_REWARD_ZONE */
	"CRYPTONOTE_BLOCK_GRANTED_FULL_REWARD_ZONE_V1":10000,

	/* For new coins, remove this. For old coins, use future block. IT WILL HARDFORK YOUR COIN AT THIS BLOCK */
	"UPGRADE_HEIGHT":91452,

	/* Max initial block size */
	"MAX_BLOCK_SIZE_INITIAL":"25 * 1024"
}
}

```

#### 3) Generate coin

```bash
bash generator.sh
```

The file `config.json` is used by default but a file can be specified using the `-f file` command argument, for example:

```bash
bash generator.sh -f config_dashcoin.json
```

If you compile on VPS with no swap defined you have to remove the default '-j' compile flag using the `-c <string>` command argument, for example:
```bash
bash generator.sh -c ''
```
*the default -c value is '-j'*


### Examples

#### 1) Dashcoin
```
/* config_dashcoin.json */

{
	"plugins": [ "core/bytecoin.py" ],
	"tests": [ "core/bytecoin-test.sh" ],
	"base_coin":{
		"name":"bytecoin",
		"git":"https://github.com/amjuarez/bytecoin.git"
	},
	"core":{
		"daemon_name":"dashcoind",
		"CRYPTONOTE_PUBLIC_ADDRESS_BASE58_PREFIX":72,
		"P2P_DEFAULT_PORT":29080,
		"RPC_DEFAULT_PORT":29081,
		"MAX_BLOCK_SIZE_INITIAL":"25 * 1024",
		"CRYPTONOTE_NAME":"dashcoin",
		"SEED_NODES":["162.243.247.45:29080", "146.185.191.90:29080", "104.131.132.129:29080", "128.199.146.243:29080"],
		"CHECKPOINTS":"{28000, \"70d2531151529ac00bf875281e15f51324934bc85e5733dcd92e1ccb1a665ff8\"}, {40000, \"c181ec9223a91fef8658c7aa364c093c41c28d250870ca1ed829bf74f0abf038\"}, {55000, \"5289fe9f2dce8f51441019b9fbc85c70ad85ff49a666ef0109f3269890c6af6d\"}, {70000, \"193e335f34b8b8f1fab3857111cb668c2720340e80176a25155071e573481acb\"}, {87500, \"cce8a035f34457ec1098ab41e5949cac3db00ebff3503e26f36bfa057543095a\"}, {91453, \"ad46d069bb2726a9bc5962cda6b2108376c0b95c157da0f09ee32458f486d87f\"}",
		"UPGRADE_HEIGHT":91452,
		"P2P_STAT_TRUSTED_PUB_KEY":"4d26c4df7f4ca7037950ad026f9ab36dd05d881952662992f2e4dcfcafbe57eb",
		"genesisCoinbaseTxHex":"010a01ff0001ffffffffffff0f029b2e4c0271c0b42e7c53291a94d1c0cbff8883f8024f5142ee494ffbbd08807121013c086a48c15fb637a96991bc6d53caf77068b5ba6eeb3c82357228c49790584a",
		"BYTECOIN_NETWORK":"0x12, 0x11, 0x21, 0x11, 0x11, 0x10, 0x41, 0x01, 0x13, 0x11, 0x00, 0x12, 0x12, 0x11, 0x01, 0x10"
	}
}

```

#### 2) Bitcoin emission curve coin
```
/* examples/config_slowcoin.json */

{
	"plugins": [ "core/bytecoin.py" ],
	"tests": [ "core/bytecoin-test.sh" ],
	"base_coin":{
		"name":"bytecoin",
		"git":"https://github.com/amjuarez/bytecoin.git"
	},
	"core":{
		"CRYPTONOTE_NAME":"slowcoin",
		"daemon_name":"slowcoind",
		"CRYPTONOTE_PUBLIC_ADDRESS_BASE58_PREFIX":259566,
		"P2P_DEFAULT_PORT":33080,
		"RPC_DEFAULT_PORT":33081,
		"SEED_NODES":["127.0.0.1:33080"],
		"P2P_STAT_TRUSTED_PUB_KEY":"",
		"genesisCoinbaseTxHex":"010f01ff0001ffffffffffff01029b2e4c0281c0b02e7c53291a94d1d0cbff8883f8024f5142ee494ffbbd08807121016e9035e8680e36994aa1cc7b179adfd2a22907f24dfb801823430625b4b59874",
		"BYTECOIN_NETWORK":"0x12, 0x14, 0x21, 0xB1, 0x15, 0x10, 0x41, 0x01, 0x13, 0x11, 0x30, 0x12, 0x12, 0x11, 0x01, 0x10",
		"MONEY_SUPPLY":"static_cast<uint64_t>(-1)",
		"EMISSION_SPEED_FACTOR":21,
		"DIFFICULTY_TARGET":90,
		"MINIMUM_FEE":1000000,
		"DEFAULT_DUST_THRESHOLD":1000000,
		"COIN":100000000000,
		"CRYPTONOTE_DISPLAY_DECIMAL_POINT":11,
		"CRYPTONOTE_MINED_MONEY_UNLOCK_WINDOW":15,
		"CRYPTONOTE_BLOCK_GRANTED_FULL_REWARD_ZONE":20000,
		"CRYPTONOTE_BLOCK_GRANTED_FULL_REWARD_ZONE_V1":10000
	}
}


```


#### Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

Plugins must be located in *plugins* folder.


Donations
---------
* <sup><sub>BTC: `1EYiA8o1KsDZxMHXvptxXyaVwuhTVNBMFp`</sup></sub>
* <sup><sub>DSH: `D3z2DDWygoZU4NniCNa4oMjjKi45dC2KHUWUyD1RZ1pfgnRgcHdfLVQgh5gmRv4jwEjCX5LoLERAf5PbjLS43Rkd8vFUM1m`</sup></sub>
* <sup><sub>BCN: `21YR5mw5BF2ah3yVE3kbhkjDwvuv21VR6D7hnpm4zHveDsvq5WEwyTxXLXNwtU5K4Pen89ZZzJ81fB3vxHABEUJCAhxXz2v`</sup></sub>
* <sup><sub>XMR: `47LEJyhCgNFcoz6U8x7tUk6LEHe38NobAfn4ou8d588jY5nddvgEANLMMcwxsbfbkJRw4xPwcG583Gq189hjusShEyk9FXz`</sup></sub>

*Donate XMR if you want to XMR version to be developed*

License
-------
Released under the GNU General Public License v2

http://www.gnu.org/licenses/gpl-2.0.html
	