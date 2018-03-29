cryptonote-generator
==================

A python / bash Cryptonote source creator. Generate and compile new or maintain old code with a single command.

#### Table of Contents

* [Features](#features)
* [Usage](#usage)
  * [Downloading & Installing](#1-downloading--installing)
  * [Configuration](#2-configuration)
  * [Generate coin](#3-generate-coin)
  * [Print genesis tx hex](#4-print-genesis-tx-hex)
* [Examples (real life)](#examples_real_life)
  * [Dashcoin](#1-dashcoin)
  * [Forknote](#2-forknote)
* [Coins Using This Software](#coins-using-this-software)
* [Community / Support](#community--support)
* [Contributing](#contributing)

#### Features

* Cryptonote source code creation, based on:
   * Bytecoin code (latest version)
* Single command code and binaries update
* Simple update for existing code
* Compile for
  * Windows (tested on 8.1)
  * Ubuntu (tested on 14.04)
  * Mac OS X (tested on Yosemite)

Usage
===

#### 1) Downloading & Installing

Clone the repository:

```bash
	git clone https://github.com/forknote/cryptonote-generator.git generator
	cd generator
```

Install dependencies:

* Windows - [follow this instructions](https://github.com/dashcoin/cryptonote-generator/blob/master/docs/windows-requirements-install.md)
* Linux / Mac OS X
```
bash install_dependencies.sh
```

#### 2) Configuration


*Warning for existing Cryptonote coins other than Dashcoin:* this software may or may not work with any given cryptonote coin.

Create your configuration here and export as JSON:
http://forknote.net/create

Copy the `config_example.json` file to `config.json` then overview each options and change any to match your preferred setup.


Explanation for each field:


```
{

/* Extensions to load */
"extensions": [ "core/bytecoin.json", "print-genesis-tx.json" ],

/* Source coin. Bytecoin example. See the available base coins here: https://github.com/forknote/cryptonote-generator/tree/master/cores */
"base_coin": "bytecoin-v2",

"core":{
	/* Check uniqueness with Google and Map of Coins. */
	"CRYPTONOTE_NAME":"dashcoin",

	/* Address prefix. Generate here: https://cryptonotestarter.org/inner.html */
	"CRYPTONOTE_PUBLIC_ADDRESS_BASE58_PREFIX":72,

	"P2P_DEFAULT_PORT":29080,
	"RPC_DEFAULT_PORT":29081,

	/* Seed nodes. Use at least 2 */
	"SEED_NODES":["162.243.247.45:29080", "146.185.191.90:29080", "104.131.132.129:29080", "128.199.146.243:29080"],

	/* Array with checkpoints. */
	"CHECKPOINTS":["28000:70d2531151529ac00bf875281e15f51324934bc85e5733dcd92e1ccb1a665ff8", "40000:c181ec9223a91fef8658c7aa364c093c41c28d250870ca1ed829bf74f0abf038", "55000:5289fe9f2dce8f51441019b9fbc85c70ad85ff49a666ef0109f3269890c6af6d", "70000:193e335f34b8b8f1fab3857111cb668c2720340e80176a25155071e573481acb", "87500:cce8a035f34457ec1098ab41e5949cac3db00ebff3503e26f36bfa057543095a", "91453:ad46d069bb2726a9bc5962cda6b2108376c0b95c157da0f09ee32458f486d87f"],

	/* Created with connectivity_tool. Leave empty if not needed */
	"P2P_STAT_TRUSTED_PUB_KEY":"4d26c4df7f4ca7037950ad026f9ab36dd05d881952662992f2e4dcfcafbe57eb",

	/* Genesis! Leave empty for new coins */
	"GENESIS_COINBASE_TX_HEX":"010a01ff0001ffffffffffff0f029b2e4c0271c0b42e7c53291a94d1c0cbff8883f8024f5142ee494ffbbd08807121013c086a48c15fb637a96991bc6d53caf77068b5ba6eeb3c82357228c49790584a",

	/* Random hex, identifier for your network */
	"BYTECOIN_NETWORK":"0x12, 0x11, 0x21, 0x11, 0x11, 0x10, 0x41, 0x01, 0x13, 0x11, 0x00, 0x12, 0x12, 0x11, 0x01, 0x10",

	/* Visualize here https://cryptonotestarter.org/inner.html  */
	/* Total amount of coins to be emitted. Most of CryptoNote-based coins use (uint64_t)(-1) (equals to 18446744073709551616).
	   You can define number explicitly (for example UINT64_C(858986905600000000)). */
	"MONEY_SUPPLY":"static_cast<uint64_t>(-1)",
	"EMISSION_SPEED_FACTOR":18,
	"GENESIS_BLOCK_REWARD":0,
	"DIFFICULTY_TARGET":120,   // In seconds

	"MINIMUM_FEE":1000000,   // 10^6. Equals to 0.01 in Dashcoin
	"DEFAULT_DUST_THRESHOLD":1000000,
	"COIN":100000000,    // Number of atom units in a coin. 10^8 in Dashcoin
	"CRYPTONOTE_DISPLAY_DECIMAL_POINT":8,    // The pow from the previews value

	"CRYPTONOTE_MINED_MONEY_UNLOCK_WINDOW":10,    // in blocks
	"CRYPTONOTE_BLOCK_GRANTED_FULL_REWARD_ZONE":20000,    // in bytes

	"DIFFICULTY_CUT":60,  // timestamps to cut after sorting
	"DIFFICULTY_LAG":15,

	/* USED ONLY IN OLD COINS. IF YOU UPDATE CHANGE THIS TO YOUR OLD CRYPTONOTE_BLOCK_GRANTED_FULL_REWARD_ZONE */
	"CRYPTONOTE_BLOCK_GRANTED_FULL_REWARD_ZONE_V1":10000,

	/* ONLY USED IN OLD COINS. IT WILL HARDFORK YOUR COIN AT THIS BLOCK */
	"UPGRADE_HEIGHT":91452,

	/* Max initial block size */
	"MAX_BLOCK_SIZE_INITIAL":"25 * 1024"

	/* Max initial block size */
	"EXPECTED_NUMBER_OF_BLOCKS_PER_DAY":"24 * 60 * 60 / 120"
}
}

```

#### 3) Generate coin

The file `config.json` is used by default but a file can be specified using the `-f file` command argument, for example:

```bash
	bash generator.sh -f [CONFIG_FILE] [-c COMPILE_OPTIONS]
```

By default, the cryptonote generator is not using multithread. I strongly recommend to use this arguments, if you are not building on a on VPS with no swap defined

###### Windows:
```bash
	bash generator.sh -f config_example.json -c '/maxcpucount:3'
```

###### Linux / Mac OS X (Cmake 2.8.x):
```bash
	bash generator.sh -f config_example.json -c '-j3'
```

#### 4) Print genesis tx hex

If you are creating a new coin, you need to create the genesis tx hex:

```
	cd generated_files/binaries/yourcoin   # yourcoin-linux for Linux, yourcoin-mac for Mac
	./yourcoind --print-genesis-tx
```
Change the _GENESIS_COINBASE_TX_HEX_ in your configuration file, then [3) Generate coin](#3-generate-coin) again.


### Examples (real life)

#### 1) Dashcoin - http://dashcoin.info

To generate Dashcoin:
```
	git clone https://github.com/forknote/cryptonote-generator.git generator && cd generator
	bash install_dependencies.sh && bash generator.sh -f configs/bytecoin-v2/dashcoin.json
```

#### 2) Forknote - http://forknote.net

To generate Forknote:
```
	git clone https://github.com/forknote/cryptonote-generator.git generator && cd generator
	bash install_dependencies.sh && bash generator.sh -f configs/bytecoin-v2/forknote.json
```


### Community / Support

* IRC (freenode)
  * Support / general / development discussion join #dashcoin: [https://webchat.freenode.net/?channels=#dashcoin](https://webchat.freenode.net/?channels=#dashcoin)
* [CryptoNote Forum](https://forum.cryptonote.org/)


#### Projects Using This Software

* [Dashcoin](https://bitcointalk.org/index.php?topic=1020627.0)
* [Forknote](https://bitcointalk.org/index.php?topic=1079306.0)


#### Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

Extensions must be located in *extensions* folder.


Donations
---------
* BTC: `1EYiA8o1KsDZxMHXvptxXyaVwuhTVNBMFp`
* DSH: <sup><sub>`D3z2DDWygoZU4NniCNa4oMjjKi45dC2KHUWUyD1RZ1pfgnRgcHdfLVQgh5gmRv4jwEjCX5LoLERAf5PbjLS43Rkd8vFUM1m`</sup></sub>
* BCN: <sup><sub>`21YR5mw5BF2ah3yVE3kbhkjDwvuv21VR6D7hnpm4zHveDsvq5WEwyTxXLXNwtU5K4Pen89ZZzJ81fB3vxHABEUJCAhxXz2v`</sup></sub>
* XMR: <sup><sub>`47LEJyhCgNFcoz6U8x7tUk6LEHe38NobAfn4ou8d588jY5nddvgEANLMMcwxsbfbkJRw4xPwcG583Gq189hjusShEyk9FXz`</sup></sub>

*Donate XMR if you want to XMR version to be developed*

Additional credits
------------------
* [piotaak](https://github.com/piotaak) (tests for cryptonotecoin-core extension)

License
-------
Released under the GNU General Public License v2

http://www.gnu.org/licenses/gpl-2.0.html
