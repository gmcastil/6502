#!/usr/bin/env python3

"""
A very strange assembler for the MOS 6502 instruction set

Addressing modes are assumed to have the following format:

Mode              Syntax            Bytes
----              ------            -----
Accumulator       ROL A             1
Relative          BPL label         2
Implied           BRK               1
Immediate         ADC #$44          2
Zero page         ADC $44           2
Zero page, X      ADC $44,X         2
Absolute          ADC $4400         3
Absolute, X       ADC $4400,X       3
Absolute, Y       ADC $4400,Y       3
Indirect, X       ADC ($44,X)       2
Indirect, Y       ADC ($44),Y       2

"""
import os
import sys
import re
import argparse
from collections import namedtuple
from textwrap import dedent

SourceLine = namedtuple('SourceLine', ['number', 'code'])

# Parameters for .coe file definition
HIGH_ADDRESS = 2**16  # 64k address space

PAGE_SIZE = 2**8  # 256 addresses per page

# ROMs for this memory map will always be 16-bit addressed
ADDR_WIDTH = 2**16

# Functions to apply to operands for the lower byte
LOWER_BYTE = {
        'acc'     : lambda s: None,
        'imm'     : lambda s: int(s.strip('#$'), 16),
        'rel'     : lambda s: s,
        'imp'     : lambda s: None,
        'zp'      : lambda s: int(s.strip('$'), 16),
        'zp x'    : lambda s: int(s[1:3], 16),
        'abs'     : lambda s: int(s[3:5], 16),
        'abs x'   : lambda s: int(s[3:5], 16),
        'abs y'   : lambda s: int(s[3:5], 16),
        'ind x'   : lambda s: int(s[2:4], 16),
        'ind y'   : lambda s: int(s[2:4], 16)
    }

# Functions to apply to operands for the upper byte
UPPER_BYTE = {
        'acc'     : lambda s: None,
        'imm'     : lambda s: None,
        'rel'     : lambda s: None,
        'imp'     : lambda s: None,
        'zp'      : lambda s: None,
        'zp x'    : lambda s: None,
        'abs'     : lambda s: int(s[1:3], 16),
        'abs x'   : lambda s: int(s[1:3], 16),
        'abs y'   : lambda s: int(s[1:3], 16),
        'ind x'   : lambda s: None,
        'ind y'   : lambda s: None
    }

OPCODES = {

    'adc' : {
        'imm'     : 0x69,
        'zp'      : 0x65,
        'zp x'    : 0x75,
        'abs'     : 0x6d,
        'abs x'   : 0x7d,
        'abs y'   : 0x79,
        'ind x'   : 0x61,
        'ind y'   : 0x71
        },

    'and' : {
        'imm'     : 0x29,
        'zp'      : 0x25,
        'zp x'    : 0x35,
        'abs'     : 0x2d,
        'abs x'   : 0x3d,
        'abs y'   : 0x39,
        'ind x'   : 0x21,
        'ind y'   : 0x31
        },

    'asl' : {
        'acc'     : 0x0a,
        'zp'      : 0x06,
        'zp x'    : 0x16,
        'abs'     : 0x0e,
        'abs x'   : 0x1e
        },

    'bit' : {
        'zp'      : 0x24,
        'abs'     : 0x2c
        },

    # Branch instructions
    'bpl' : {
        'rel'     : 0x10
        },

    'bmi' : {
        'rel'     : 0x30
        },

    'bvc' : {
        'rel'     : 0x50
        },

    'bvs' : {
        'rel'     : 0x70
        },

    'bcc' : {
        'rel'     : 0x90
        },

    'bcs' : {
        'rel'     : 0xb0
        },

    'bne' : {
        'rel'     : 0xd0
        },

    'beq' : {
        'rel'     : 0xf0
        },

    'brk' : {
        'imp'     : 0x00
        },

    'cmp' : {
        'imm'     : 0xc9,
        'zp'      : 0xc5,
        'zp x'    : 0xd5,
        'abs'     : 0xcd,
        'abs x'   : 0xdd,
        'abs y'   : 0xd9,
        'ind x'   : 0xc1,
        'ind y'   : 0xd1
        },

    'cpx' : {
        'imm'     : 0xe0,
        'zp'      : 0xe4,
        'abs'     : 0xec
        },

    'cpy' : {
        'imm'     : 0xc0,
        'zp'      : 0xc4,
        'abs'     : 0xcc
        },

    'dec' : {
        'zp'      : 0xc6,
        'zp x'    : 0xd6,
        'abs'     : 0xce,
        'abs x'   : 0xde
        },

    'eor' : {
        'imm'     : 0x49,
        'zp'      : 0x45,
        'zp x'    : 0x55,
        'abs'     : 0x4d,
        'abs x'   : 0x5d,
        'abs y'   : 0x59,
        'ind x'   : 0x41,
        'ind y'   : 0x51
        },

    'clc' : {
        'imp'     : 0x18
        },

    'sec' : {
        'imp'     : 0x38
        },

    'cli' : {
        'imp'     : 0x58
        },

    'sei' : {
        'imp'     : 0x78
        },

    'clv' : {
        'imp'     : 0xb8
        },

    'cld' : {
        'imp'     : 0xd8
        },

    'sed' : {
        'imp'     : 0xf8
        },

    'inc' : {
        'zp'      : 0xe6,
        'zp x'    : 0xf6,
        'abs'     : 0xee,
        'abs x'   : 0xfe
        },

    'jmp' : {
        'abs'     : 0x4c,
        'ind'     : 0x6c
        },

    'jsr' : {
        'abs'     : 0x20
        },

    'lda' : {
        'imm'     : 0xa9,
        'zp'      : 0xa5,
        'zp x'    : 0xb5,
        'abs'     : 0xad,
        'abs x'   : 0xbd,
        'abs y'   : 0xb9,
        'ind x'   : 0xa1,
        'ind y'   : 0xb1
        },

    'ldx' : {
        'imm'     : 0xa2,
        'zp'      : 0xa6,
        'zp y'    : 0xb6,
        'abs'     : 0xae,
        'abs y'   : 0xbe
        },

    'ldy' : {
        'imm'     : 0xa0,
        'zp'      : 0xa4,
        'zp x'    : 0xb4,
        'abs'     : 0xac,
        'abs x'   : 0xbc
        },

    'lsr' : {
        'acc'     : 0x4a,
        'zp'      : 0x46,
        'zp x'    : 0x56,
        'abs'     : 0x4e,
        'abs x'   : 0x5e
        },

    'nop' : {
        'imp'     : 0xea
        },

    'ora' : {
        'imm'     : 0x09,
        'zp'      : 0x05,
        'zp x'    : 0x15,
        'abs'     : 0x0d,
        'abs x'   : 0x1d,
        'abs y'   : 0x19,
        'ind x'   : 0x01,
        'ind y'   : 0x11
        },

    'tax' : {
        'imp'     : 0xaa
        },

    'txa' : {
        'imp'     : 0x8a
        },

    'dex' : {
        'imp'     : 0xca
        },

    'inx' : {
        'imp'     : 0xe8
        },

    'tay' : {
        'imp'     : 0xa8
        },

    'tya' : {
        'imp'     : 0x98
        },

    'dey' : {
        'imp'     : 0x88
        },

    'iny' : {
        'imp'     : 0xc8
        },

    'rol' : {
        'acc'     : 0x2a,
        'zp'      : 0x26,
        'zp x'    : 0x36,
        'abs'     : 0x2e,
        'abs x'   : 0x3e
        },

    'ror' : {
        'acc'     : 0x6a,
        'zp'      : 0x66,
        'zp x'    : 0x76,
        'abs'     : 0x6e,
        'abs x'   : 0x7e
        },

    'rti' : {
        'imp'     : 0x40
        },

    'rts' : {
        'imp'     : 0x60
        },

    'sbc' : {
        'imm'     : 0xe9,
        'zp'      : 0xe5,
        'zp x'    : 0xf5,
        'abs'     : 0xed,
        'abs x'   : 0xfd,
        'abs y'   : 0xf9,
        'ind x'   : 0xe1,
        'ind y'   : 0xf1
        },

    'sta' : {
        'zp'      : 0x85,
        'zp x'    : 0x95,
        'abs'     : 0x8d,
        'abs x'   : 0x9d,
        'abs y'   : 0x99,
        'ind x'   : 0x81,
        'ind y'   : 0x91
        },

    'txs' : {
        'imp'     : 0x9a
        },

    'tsx' : {
        'imp'     : 0xba
        },

    'pha' : {
        'imp'     : 0x48
        },

    'pla' : {
        'imp'     : 0x68
        },

    'php' : {
        'imp'     : 0x08
        },

    'plp' : {
        'imp'     : 0x28
        },

    'stx' : {
        'zp'      : 0x86,
        'zp y'    : 0x96,
        'abs'     : 0x8e
        },

    'sty' : {
        'zp'      : 0x84,
        'zp x'    : 0x94,
        'abs'     : 0x8c
        }
    }

class Block(object):
    """Organize blocks of source code for assembling

    Args:
      offset (int): Absolute offset address
      source (list): List of tuples, each contains a line number and instruction

    """
    def __init__(self, offset, source):
        self.offset = offset
        self.source = source
        self.exec_code = list()

        # Symbol table for storing interim results
        self._symbols = dict()
        # Interim object code created during the first pass
        self._object_code = list()

    def __len__(self):
        return len(self.exec_code)

    def assemble(self):
        """Assembles a block of source code

        Returns:
          None

        """
        self._object_code = self._first_pass()
        self.exec_code = self._second_pass()

    def _first_pass(self):
        """First pass assembly and build symbol table

        Returns:
          list - Assembled source code with symbols included

        """
        object_code = list()
        for line in self.source:
            # Fetch assembly mneumonic, label, and operands
            parsed_line = parse_line(line.code)
            operands = parsed_line['operands']
            mneumonic = parsed_line['mneumonic']
            label = parsed_line['label']

            # Use form of operands to infer addressing mode
            addr_mode = parse_addr_mode(operands)

            # Use the addressing mode and mneumonic to get the right opcode
            opcode = OPCODES[mneumonic][addr_mode]
            # The label should point to the location of this instruction
            if label:
                self._symbols[label] = len(object_code)

            lower_byte = LOWER_BYTE[addr_mode](operands)
            upper_byte = UPPER_BYTE[addr_mode](operands)

            # Add the opcode
            object_code.append(opcode)
            # Add lower and upper bytes, little endian
            if lower_byte is not None:
                object_code.append(lower_byte)
            if upper_byte is not None:
                object_code.append(upper_byte)

        return object_code

    def _second_pass(self):
        """Complete assembly and generate final machine code

        Returns:
          list - Final executable code with symbols removed

        """
        # Copy the object code to preserve it from the first pass
        object_code = list(self._object_code)

        # Iterate over each entry in the object code
        for index, entry in enumerate(object_code):
            if isinstance(entry, str):
                try:
                    # Look up the offset in the symbol table
                    symbol_position = self._symbols[entry]
                # Add a check here to error if the label is missing
                except KeyError:
                    print('ERROR: Label not found')

                # Calculate relative position and replace the label with it
                offset = symbol_position - index
                if offset > 0:
                    object_code[index] = offset - 1
                else:
                    offset = abs(offset - 1)
                    object_code[index] = twos_complement(offset)

        return object_code


def parse_addr_mode(operands):
    """Determines addressing mode based on format of operands passed to it

    Args:
      operands (str): Operands from an instruction

    Returns:
      str - Addressing mode to use for looking up opcodes and values to place

    Raises:
      SyntaxError - Catch this elsewhere and reraise with the line number

    """
    # Need to check for this to be not None or it'll give an error
    if operands:
        operands = operands.lower().strip().replace(' ', '')

    # Implied
    if not operands:
        return 'imp'

    # Immediate
    if operands.startswith('#$'):
        return 'imm'

    # Accumulator
    if operands == 'a':
        return 'acc'

    # Indirect modes
    if operands.startswith('('):
        if operands.endswith(',x)'):
            return 'ind x'
        elif operands.endswith('),y'):
            return 'ind y'
        else:
            raise SyntaxError

    # Absolute modes
    abs_pattern = r'^\$[0-9A-Fa-f]{4}'
    abs_match = re.search(abs_pattern, operands)
    # This is really rather fragile and there are ways to break this
    if abs_match:
        if operands.endswith(',x'):
            return 'abs x'
        elif operands.endswith(',y'):
            return 'abs y'
        else:
            return 'abs'

    # Zero page modes
    zp_pattern = r'^\$[0-9A-Fa-f]{2}$'
    zp_match = re.search(zp_pattern, operands)
    if zp_match:
        return 'zp'

    zp_x_pattern = r'^\$[0-9A-Fa-f]{2},x$'
    zp_x_match = re.search(zp_x_pattern, operands)
    if zp_x_match:
        return 'zp x'

    # Relative
    rel_pattern = r'^[0-9A-Za-z\_]+$'
    rel_match = re.search(rel_pattern, operands)
    # Here we limit labels to alphanumeric strings with underscores
    if rel_match:
        return 'rel'
    else:
        raise SyntaxError

def parse_line(line):
    """Parses lines into the appropriate tokens required

    Args:
      line (str): Line of valid source code (stripped)

    Returns:
      dict - Contains assembly mneumonic, label, and operands

    """
    head, sep, tail = line.partition(':')
    if sep:
        label = head.strip()
        statement = tail.strip()
    else:
        label = None
        statement = line.strip()

    head, sep, tail = statement.partition(' ')
    if sep:
        mneumonic = head.strip()
        operands = tail.strip()
    else:
        mneumonic = statement.strip()
        operands = None

    return {'label' : label, 'mneumonic' : mneumonic, 'operands' : operands}

def stripped(filename):
    """Generates a sequence of source code lines without comments or whitespace

    Args:
      filename (str) - Filename to strip of whitespace and comments

    Yields:
      tuple - Line numbers and instructions or assembler directives

    """
    with open(filename, 'r') as lines:
        for number, line in enumerate(lines, 1):
            # Only deal with lowercase values
            line = line.lower().strip()
            # Eliminate comment lines
            if line.startswith(';'):
                continue
            # Eliminate whitespace lines
            if not line:
                continue
            # Eliminate any trailing comments and whitespace before yielding
            if ';' in line:
                comment_index = line.find(';')
                code = line[0:comment_index].strip()
            else:
                code = line.strip()
            line = SourceLine(number, code)
            yield line

def extract_code(filename):
    """Extracts blocks of source code delineated by .org directives

    Args:
      filename (str): Source code filename

    Returns
      dict - Keys are derived from origin directives. Values are lists of
             instructions to be placed there

    """
    source_code = stripped(filename)
    blocks = dict()
    for line in source_code:
        # This requires that an .org directive appear before any code...
        if is_origin(line.code):
            directive, offset = line.code.split()
            # Peel off the leading '$' from the source file
            offset = int(offset[1:], 16)
            blocks[offset] = list()
        # ...otherwise this line throws a NameError
        else:
            blocks[offset].append(line)
    return [Block(offset, blocks[offset]) for offset in sorted(blocks.keys())]

def is_origin(line):
    """Returns True if line is a valid origin directive

    Args:
      line (str): Line of valid source code (stripped)

    Returns:
      bool

    """
    status = False
    directive = 'org'
    if line.startswith('.' + directive):
        status = True
    return status

def twos_complement(number):
    complement = (0xff ^ number)
    return complement + 1

def write_coefficients(filename, data):
    """Writes a .coe file out to disk from the supplied data

    Args:
      filename (str): Output filename
      data (list): Complete

    Returns:
      None

    """
    def row_gen(data):
        "Yield successive rows of elements"
        for i in range(0, len(data), 64):
            # Get a 64-byte chunk
            row = data[i:i+64]
            # Convert to a two-digit hex value but remove the leading '0x'
            yield [hex(number)[2:].zfill(2) for number in row]

    with open(filename, 'w') as coe_file:
        # Xilinx header files have a peculiar format
        header = dedent(
            f'''\
            ;; Distributed Memory Generator COE file
            ;; \tAddress Size = {HIGH_ADDRESS}
            ;; \tPage Size = {PAGE_SIZE}
            memory_initialization_radix = 16;
            memory_initialization_vector =
            '''
            )

        coe_file.write(header)
        rows = row_gen(data)
        for number, row in enumerate(rows):
            if (number % 4 == 0):
                # Need multiplication here because there are 64 bytes per line
                page_number = int(number * 64)
                # Format in the usual way
                page_number = format(page_number, '#06x')
                boundary_str = f';; Begin page {page_number}.\n'
                coe_file.write(boundary_str)
            coe_file.write(' '.join(row) + '\n')

def write_mif(filename, data):
    """Writes a .mif file out to disk from the supplied data

    Args:
      filename (str): Output filename
      data (list): Complete

    Returns:
      None

    """
    with open(filename, 'w') as mif_file:
        for byte in data:
            bin_string = bin(byte)[2:].zfill(8)
            mif_file.write(bin_string + '\n')

def assemble(filename, quiet=True):
    """Assembles a source file into machine code

    Args:
      filename (str): Input filename
      quiet (bool):

    Returns:
      list - Machine code containing the entire 64KB address space

    """

    # Dict of Block objects - key is the address offset
    blocks = extract_code(filename)
    # Create an empty coefficients structure containing NOP
    data = [OPCODES['nop']['imp'] for i in range(ADDR_WIDTH)]
    # Iterate over each block of assembly code extracted from the source
    # file and place into coefficents structure
    for block in blocks:
        block.assemble()
        start_offset = block.offset
        end_offset = start_offset + len(block)
        # Insert each block into the coefficients structure
        data[start_offset:end_offset] = block.exec_code
        if not quiet:
            print(f'Assembling {len(block)} bytes at offset '
                  f'{hex(start_offset)}...')
    return data

def add_map(filename, data):
    """Adds a memory map to a complete coefficients image

    Args:
      filename (str): Memory map containing address and value pairs
      data (list): Machine code containng the entire 64KB address space

    Returns
      list - Input data with added values from the map file

    Input data is nominally considered to be the results of assembly

    """
    with open(filename, 'r') as map_file:
        for line in map_file:
            if line.startswith('#'):
                continue
            elif ';' in line:
                comment_index = line.find('#')
                line = line[:comment_index].strip()
            else:
                line = line.strip()
            address, value = line.split()
            address = int(address.strip('$'), 16)
            value = int(value.strip('$'), 16)
            data[address] = value
    return data


def main():

    desc_text = 'Converts MOS 6502 assembly code to Xilinx .COE and .MIF files'

    # Set up command line argument parsing and increase the allowed width of
    # the help text
    parser = argparse.ArgumentParser(
        prog='oddball',
        description=desc_text,
        formatter_class=lambda prog: argparse.HelpFormatter(
            prog, max_help_position=50))

    parser.add_argument('filename',
                        help='input source code')
    parser.add_argument('-c', '--coe-only', action='store_true',
                        help='only generate a coefficients file')
    parser.add_argument('-m', '--with-map', metavar='MAP_FILE',
                        help='additional data to place in memory')
    parser.add_argument('-o', '--output', metavar='MIF_FILE',
                        help='output filename to use')
    parser.add_argument('-q', '--quiet', action='store_true',
                        help='suppress all output')
    args = parser.parse_args()

    if args.filename:
        if os.path.exists(args.filename):
            data = assemble(args.filename, args.quiet)
        else:
            raise OSError('Source file not found.')

    if args.with_map:
        if os.path.exists(args.with_map):
            data = add_map(args.with_map, data)
        else:
            raise OSError('Map file not found.')

    # Write out a .coe file
    if args.output:
        coe_file = os.path.splitext(args.output)[0] + '.coe'
    else:
        coe_file= os.path.splitext(args.filename)[0] + '.coe'
    if not args.quiet:
        print(f'Generating coefficients file at {coe_file}.')
    write_coefficients(coe_file, data)

    # Unless otherwise directed, generate a .mif file as well
    if not args.coe_only:
        mif_file = os.path.splitext(coe_file)[0] + '.mif'
        if not args.quiet:
            print(f'Generating memory initialization file at {mif_file}.')
        write_mif(mif_file, data)


if __name__ == '__main__':
    sys.exit(main())
