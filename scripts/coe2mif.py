#!/usr/bin/env python3

"""
Produces a .mif file from a Xilinx .coe file for use in simulation

The structure of the .coe file is expected to describe an Nx8 memory array
that contains ';' denoted comment, whitespace, and configuration directives
which are indicated by a leading 'memory...' string.  Bytes are expected to
be separated from each other by whitespace.  No additional formatting details
are expected.

"""
import os
import sys

def byte_gen(filename):
    """Produces a stream of strings representing bytes stored in a .coe file

    Args:
      filename (str) - Path to .coe file

    Yields
      int

    """
    with open(filename, 'r') as lines:
        for line in lines:
            # Ignore comments and configuration directives
            if line.startswith(';') or line.startswith('memory'):
                pass
            # Ignore whitespace
            elif not line.strip():
                pass
            else:
                for byte in line.split():
                    # Check for invalid values
                    value = int(byte, 16)
                    if value > 255:
                        error_str = ('Invalid entries in .coe file')
                        raise ValueError(error_str)
                    else:
                        yield value

def convert(coe_file):
    """Converts a .coe file to a .mif file for use in simulation

    Args:
      coe_file (str) - Path to .coe file

    Returns:
      None

    """

    stem = coe_file.split('.')[0:-1]
    base = os.path.dirname(os.path.abspath(coe_file))
    mif_file = '.'.join(stem) + '.mif'

    try:
        coe = byte_gen(coe_file)
        with open(mif_file, 'w') as mif:
            for byte in coe:
                mif.write(left_pad(byte) + '\n')
    except:
        raise IOError('Problem writing to location.')

def left_pad(byte, N=8):
    """Pads a binary string representation to N bits

    Args:
      byte (int) - Returns the binary representation of an N-bit value
      N (int) - Number of zeros to pad left

    Returns:
      str - Binary string zero-padded to N bits

    """
    raw_binary = bin(byte)[2:]  # strip off the '0b'
    pad_length = N - len(raw_binary)
    # Concatenate with as many '0' as necessary
    return (pad_length * '0') + raw_binary

def main(args):
    if len(args) == 1:
        print("Usage: coe2mif.py <filename>")
        return 1

    convert(args[1])

if __name__ == "__main__":
    sys.exit(main(sys.argv))
