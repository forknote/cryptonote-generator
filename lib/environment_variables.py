import json
import argparse
import sys


def convert_to_bash ( entity, prefix ):
	for key, value in entity.iteritems():
		if isinstance(value, dict):
			convert_to_bash(entity[key], prefix + key + '_')
		elif isinstance(value, list):
			print "export " + str(prefix) + str(key) + "=(" + " ".join(json.dumps(str(item)) for item in value) + ")"
		elif isinstance(value, int):
			print "export " + str(prefix) + str(key) + "=" + str(value)
		else:
			print "export " + str(prefix) + str(key) + "=" + str(json.dumps(value)) + ""

parser = argparse.ArgumentParser()

parser.add_argument('--config', action='store', dest='config_file',
                    default='config.json',
                    help='Configuration filename. Format: json'
                    )
parser.add_argument('--output', action='store', dest='output',
                    default='config.cfg',
                    help='Output path. Format: string'
                    )
parser.add_argument('--prefix', action='store', dest='prefix',
                    default='',
                    help='Prefix of the saved bash variables. Format: string'
                    )

args = parser.parse_args()

json_data=open(args.config_file)
config = json.load(json_data)
json_data.close()

f = open(args.output, 'w+')
sys.stdout = f
convert_to_bash(config, '__CONFIG' + args.prefix + '_')
sys.stdout = sys.__stdout__
f.close()
