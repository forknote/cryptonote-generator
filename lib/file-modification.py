import argparse
import fileinput
import fnmatch
import itertools
import json
import os
from stat import *
import re
import shutil
import sys


class bcolors:
    HEADER = '\033[95m'
    OKBLUE = '\033[94m'
    OKGREEN = '\033[92m'
    WARNING = '\033[93m'
    FAIL = '\033[91m'
    ENDC = '\033[0m'
    BOLD = '\033[1m'
    UNDERLINE = '\033[4m'

reload(sys)
sys.setdefaultencoding('utf8')

def reverse_enumerate(iterable):
    """
    Enumerate over an iterable in reverse order while retaining proper indexes
    """
    return itertools.izip(reversed(xrange(len(iterable))), reversed(iterable))

def findReplace(directory, file):
    replace_text = text_creator(file['changes'][0])
    for path, dirs, files in os.walk(os.path.abspath(directory)):
        for filename in fnmatch.filter(files, file['file_pattern']):
            filepath = os.path.join(path, filename)
            stats = os.stat(filepath)
            if ".git" in filepath:
                continue
            with open(filepath) as f:
                s = f.read()
            s = s.decode('utf-8', errors='ignore').encode('utf-8').replace(file['find'], replace_text)
            with open(filepath, "w") as f:
                f.write(s)


def text_creator(change):
    replace_text = ''
    if 'var' in change['parameters'].keys():
        if change['parameters']['var'] in config['core'].keys():
            aggregated_var = ""
            if 'separator' in change['parameters'].keys():
                for element in config['core'][change['parameters']['var']]:
                    if 'quote_it' in change['parameters'].keys() and change['parameters']['quote_it'] == True:
                        aggregated_var += "\"" + element + "\""
                    else:
                        aggregated_var += element
                    aggregated_var += change['parameters']['separator']
                aggregated_var = aggregated_var[:-len(change['parameters']['separator'])]
            else:
                aggregated_var = config['core'][change['parameters']['var']]
            replace_text = "\n".join(change['parameters']['text']).replace("%s", str(aggregated_var)) + "\n"
        elif 'replace_text_alt' in change['parameters'].keys():
            replace_text = '\n'.join(change['parameters']['replace_text_alt']) + "\n"
        elif 'mandatory' in change['parameters'].keys() and change['parameters']['mandatory'] == False:
            sys.__stdout__.write("NONE\n")
            return None
        else:
            sys.__stdout__.write(bcolors.FAIL + "ERROR: variable is not in the config file - " + change['parameters']['var']+ bcolors.ENDC + "\n")
            sys.exit(2)
    else:
        replace_text = '\n'.join(change['parameters']['text']) + "\n"

    # sys.__stdout__.write("Replace text: " + replace_text + "\n")
    return replace_text

parser = argparse.ArgumentParser()
parser.add_argument('--extension', action='store', dest='extension_file',
                    help='Extension filename. Format: json'
                    )
parser.add_argument('--config', action='store', dest='config_file',
                    default='config.json',
                    help='Configuration filename. Format: json'
                    )
parser.add_argument('--source', action='store', dest='source',
                    default='tmp',
                    help='Working folder containing the base coin source'
                    )
args = parser.parse_args()

try:
    extension_json_data = open(args.extension_file)
except IOError as e:
    print "I/O error({0}): {1} - {2}".format(e.errno, e.strerror, args.extension_file)
    sys.exit(2)
else:
    try:
        extension = json.load(extension_json_data)
    except ValueError as e:
        print "Not a valid JSON file: " + args.extension_file
        sys.exit(3)
    else:
        extension_json_data.close()

try:
    config_json_data = open(args.config_file)
except IOError as e:
    print "I/O error({0}): {1} - {2}".format(e.errno, e.strerror, args.config_file)
    sys.exit(2)
else:
    try:
        config = json.load(config_json_data)
    except ValueError as e:
        print "Not a valid JSON file: " + args.config_file
        sys.exit(3)
    else:
        config_json_data.close()

required_extensions = [i for i in extension['required']]
loaded_extensions = config['extensions'][:(config['extensions'].index(extension['file']))]

if not (set(required_extensions) <= set(loaded_extensions)):
    print bcolors.FAIL + "ERROR: Required extension not loaded:  required" + str(required_extensions) + "   loaded" + str(loaded_extensions) + bcolors.ENDC + "\n"
    exit(3)


for file in extension['files']:
    # Bulk replace text
    if 'action' in file.keys() and file['action'] == 'bulk_replace':
        if 'find' in file.keys() and 'file_pattern' in file.keys():
            sys.__stdout__.write("- Bulk replacing " + file['find'] + " with pattern \"" + file['file_pattern'] + "\"\n")
            findReplace(args.source, file)
        else:
            sys.__stdout__.write(bcolors.FAIL + "ERROR: find and file_pattern are mandatory with bulk_replace" + bcolors.ENDC + "\n")
            exit(4)
        continue

    # Add new file to output source
    if 'action' in file.keys() and 'source' in file.keys() and file['action'] == 'add':
        source_path = os.path.dirname(os.path.realpath(args.extension_file)) + file['source']
        if (os.path.isfile(source_path)):
            sys.__stdout__.write("- Adding file " + source_path + "\n")
            path = os.path.dirname(args.source + file['path'])
            if not os.path.exists(path):
                os.makedirs(path)
            shutil.copyfile(source_path,args.source + file['path'])
        else:
            sys.__stdout__.write(bcolors.FAIL + "ERROR: file does not exists - " + source_path + bcolors.ENDC + "\n")
            exit(4)
        continue

    # Remove file from base repository
    if 'action' in file.keys() and 'path' in file.keys() and file['action'] == 'remove':
        path = args.source + file['path']
        if (os.path.isfile(path)):
            sys.__stdout__.write("- Removing file " + path + "\n")
            os.remove(path)
        else:
            sys.__stdout__.write(bcolors.FAIL + "ERROR: file does not exists - " + path + bcolors.ENDC + "\n")
            exit(4)
        continue


    # If multiline, get the whole file
    if 'multiline' in file.keys() and file['multiline'] == True:
        work_file = open(args.source + file['path'], 'r')
        work_file_content = work_file.read()
        work_file.close()

        # Start pre-tests
        sys.__stdout__.write("- Making pre-tests in file " + args.source + file['path'] + "\n")
        changes = list(file['changes'])
        for index, change in reverse_enumerate(changes):
            TEMPLATE_re = re.compile(r"%s" % change['marker'], re.MULTILINE)
            match = TEMPLATE_re.search(work_file_content)
            if match:
                sys.__stdout__.write("  + Pretest: marker exists - " + change['marker'] + "\n")
                del changes[index]

        for index, change in reverse_enumerate(changes):
            if 'may_not_exist' in change and change['may_not_exist']:
                sys.__stdout__.write(bcolors.WARNING + "WARNING: marker not found - " + change['marker'] + bcolors.ENDC + "\n")
                del changes[index]

        for change in changes:
            sys.__stdout__.write(bcolors.FAIL + "ERROR: marker not found - " + change['marker'] + bcolors.ENDC + "\n")
            sys.exit(2)
        # End pre-tests

        sys.__stdout__.write("- Making changes in file " + args.source + file['path'] + "\n")
        changes = list(file['changes'])
        for change in changes:
            sys.__stdout__.write("  + Replaced text at marker: " + change['marker'] + "\n")
            replace_text = text_creator(change)
            if replace_text is not None:
                TEMPLATE_re = re.compile(r"%s" % change['marker'], re.DOTALL)
                work_file_content = TEMPLATE_re.sub(replace_text, work_file_content) + "\n"

        work_file = open(args.source + file['path'], "w")
        work_file.write(work_file_content)
        work_file.close()
    # If not multiline - check line by line
    else:
        # Start pre-tests
        sys.__stdout__.write("- Making pre-tests in file " + args.source + file['path'] + "\n")
        changes = list(file['changes'])
        for line in fileinput.input([args.source + file['path']], inplace=True):
            for index, change in reverse_enumerate(changes):
                if change['marker'] in line:
                    sys.__stdout__.write("  + Pretest: marker exists - " + change['marker'] + "\n")
                    del changes[index]
            sys.stdout.write(line)

        for index, change in reverse_enumerate(changes):
            if 'may_not_exist' in change and change['may_not_exist']:
                sys.__stdout__.write(bcolors.WARNING + "WARNING: marker not found - " + change['marker'] + bcolors.ENDC + "\n")
                del changes[index]

        for change in changes:
            sys.__stdout__.write(bcolors.FAIL + "ERROR: marker not found - " + change['marker'] + bcolors.ENDC + "\n")
            sys.exit(2)
        # End pre-tests


        sys.__stdout__.write("- Making changes in file " + args.source + file['path'] + "\n")
        changes = list(file['changes'])
        for line in fileinput.input([args.source + file['path']], inplace=True):
            add_after_line = ""
            delete_line = False
            for change in changes:
                if change['action'] == "replace":
                    if change['marker'] in line:
                        sys.__stdout__.write("  + Replacing line at marker: " + change['marker'] + "\n")
                        replace_text = text_creator(change)
                        if replace_text is not None:
                            line = replace_text
                if change['action'] == "add_above":
                    if change['marker'] in line:
                        sys.__stdout__.write("  + Added text before marker: " + change['marker'] + "\n")
                        replace_text = text_creator(change)
                        if replace_text is not None:
                            add_before_line = replace_text
                            sys.stdout.write(replace_text)
                if change['action'] == "delete":
                    if change['marker'] in line:
                        sys.__stdout__.write("  + Delete line at marker: " + change['marker'] + "\n")
                        delete_line = True
                if change['action'] == "add_below":
                    if change['marker'] in line:
                        sys.__stdout__.write("  + Added text after marker: " + change['marker'] + "\n")
                        replace_text = text_creator(change)
                        if replace_text is not None:
                            add_after_line = replace_text

            if delete_line != True:
                sys.stdout.write(line)
            if add_after_line != "":
                sys.stdout.write(add_after_line)
