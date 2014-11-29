Cryptonote generator
==================
## What is Cryptonote generator?

The Cryptonote generator has a single purpose - to generate a personalized coin based on Cryptonote technology.

The Cryptonote generator eleminates the need of core development team involved in the creation of a cryptocurrency. This reduces the costs of running such a currency close to none. It also reduces dramatically the knowledge needed to create a feature rich, exploit free* cryptocurrency.

<sub><sup>* known exloits unrelated to hashrate attacks</sup></sub>

## Requirements
#### Windows
Cygwin - https://cygwin.com


## Installation

	git clone https://github.com/dashcoin/cryptonote-generator.git

## Configuration

You can create custom configuration by coping **config.json** and renaming it. The default configuration will create Dashcoin, the first cryptocurrency created with the Cryptonote generator.

## Usage

	bash generator.sh [PATH_TO_config.json]

The generated source will be in *generated_files/dashcoin*.

Use *-c* flag to compile after the source generation. 

## Currencies
List of Cryptonote currencies using the Cryptonote generator:

[Dashcoin](http://dashcoin.net)

	
## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

Plugins must be located in *plugins* folder.
