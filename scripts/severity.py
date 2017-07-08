#!/usr/bin/python
"""

Highlights Vivado output messages according to their severity

"""
import sys
import re

# Define some normal and bright colors - may not use all of these
green = "\033[38;5;2m"
bright_green = "\033[38;5;10m"
yellow = "\033[38;5;3m"
bright_yellow = "\033[38;5;11m"
orange = "\033[38;5;166m"
bright_orange = "\033[38;5;202m"
red = "\033[38;5;1m"
bright_red = "\033[38;5;9m"
blue = "\033[38;5;4m"
bright_blue = "\033[38;5;12m"
white = "\033[38;5;7m"
bright_white = "\033[38;5;15m"
reset = "\033[0m"

MESSAGES = {'STATUS' : white,
            'INFO' : yellow,
            'WARNING'  : bright_yellow,
            'CRITICAL WARNING' : bright_orange,
            'ERROR' : bright_red}

def main():
    for line in sys.stdin:
        if is_message(line):
            sys.stdout.write(colored(line))
        else:
            sys.stdout.write(line)

def colored(line):
    # Color the message name
    message, remainder = line.split(":", 1)
    color = MESSAGES[message]
    colored_line = ''.join([color, message, reset, ":", remainder])

    # Color the message ID
    err_pattern = re.compile('\\: \\[.*?\\]')
    matches = err_pattern.search(line)
    if matches:
        # Only want to colorize the code itself
        err_code = matches.group()[2:]
        colored_err_code = ''.join([bright_white, err_code, reset])
        colored_line = colored_line.replace(err_code, colored_err_code, 1)

    return colored_line

def is_message(line):
    if line.startswith(tuple(MESSAGES.keys())):
        return True
    else:
        return False

if __name__ == "__main__":
    main()
