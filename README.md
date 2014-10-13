Dashcoin generator
==================
## What is Dashcoin generator?

The Dashcoin generator has a single purpose - to generate a personalized copy of Bytecoin, an anonymous p2p currency based on the Cryptonote technology.

The Dashcoin generator eleminates the need of core development team involved in the creation of a cryptocurrency. This reduces the costs of running such a currency close to none. It also reduces dramatically the knowledge needed to create a feature rich, exploit free* cryptocurrency.

<sub><sup>* known exloits unrelated to hashrate attacks</sup></sub>

*Currently the Dashcoin generator works only on Linux and Mac OS X.*

## Installation

	git clone https://github.com/dashcoin/dashcoin-generator.git

## Configuration

The Dashcoin generator comes preconfigured. You can create custom configuration by coping **config.cfg** and renaming it.

## Usage

Generating Dashcoin:

	bash generator.sh [PATH_TO_config.cfg]

The generated source will be in *generated_files/dashcoin*.

## Customization

Customize the Dashcoin generator by writing your scripts in the following files:

**custom/customize.sh** - customize coin's parameters

**custom/customize-test.sh** - add custom tests for the generated code

**custom/generate.sh** - custom actions after the coin is generated and tested

Dashcoin generator can be customized to generate your own coin with its own parameters. You can even change the base coin to be different from Bytecoin like Monero or Boolberry with minimum efford.

	
## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

Plugins must be located in *plugins* folder.
