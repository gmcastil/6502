#!/usr/bin/env python3

"""
Collection of tools for working with Xilinx COE files

"""
import pdb
import sys

implied = {
    'clc' : '18',
    'sec' : '38',
    'cli' : '58',
    'sei' : '78',
    'clv' : 'b8',
    'cld' : 'd8',
    'sed' : 'f8',
    'nop' : 'ea'
    }

immediate = {
    'adc' : '69',
    'and' : '29',
    'cmp' : 'c9',
    'cpx' : 'e0',
    'cpy' : 'c0',
    'eor' : '49',
    'lda' : 'a9',
    'ldx' : 'a2',
    'ldy' : 'a0',
    'ora' : '09',
    'sbc' : 'e9'
    }

absolute = {
    'adc' : '6d',
    'and' : '2d',
    'asl' : '0e',
    'bit' : '2c',
    'cmp' : 'cd',
    'cpx' : 'ec',
    'cpy' : 'cc',
    'dec' : 'ce',
    'eor' : '4d',
    'inc' : 'ee',
    'jmp' : '4c',
    'lda' : 'ad',
    'ldx' : 'ae',
    'ldy' : 'ac',
    'lsr' : '4e',
    'ora' : '0d',
    'rol' : '2e',
    'ror' : '6e',
    'sbc' : 'ed'
    }


def chunker(iterable, n, factory=tuple):
    """Helper function to make it easier to create proper length lines"""
    i = iter(iterable)
    r = range(n)
    while True:
        t = factory(next(i) for _ in r)
        if len(t) > 0:
            yield t
        else:
            break


def from_asm(filename):
    """Builds a COE file from a 6502 assembly source file

    Args:
      filename (str) - Name of source file to read from

    Returns:
      None

    """
    instructions = tokenizer(filename)
    assembled = ' '.join([decode(instruction) for instruction in instructions])
    formatted = '\n'.join(' '.join(x) for x in chunker(assembled.split(), 64))
    sys.stdout.write(formatted)


def tokenizer(filename):
    """Parses an iterable and returns the instruction and any operand

    """
    with open(filename, 'r') as source:
        for line in source:
            if line.strip().startswith(';'):
                continue
            if line.strip().startswith('.'):
                continue
            elif line.strip():
                # Remove any trailing comments and whitespace
                stem = line.split(';')[0].strip()
                if ':' in stem:
                    # Remove label if it is present
                    instruction = stem.split(':')[1].strip()
                else:
                    instruction = stem.strip()
                tokens = instruction.split()
                yield tokens

def decode(token):
    """Returns opcode and any operands

    """
    if len(token) == 1:
        # Implied addressing mode
        opcode = implied[token[0]]
        return opcode
    else:
        if token[1].startswith('#'):
            opcode = immediate[token[0]]
            operand_1 = token[1].strip('#$')
            return ' '.join([opcode, operand_1])
        else:
            # Absolute addressing mode
            opcode = absolute[token[0]]
            operand = token[1].strip('$')
            operand_1 = operand[2:4]
            operand_2 = operand[0:2]
            return ' '.join([opcode, operand_1, operand_2])

def main(args):
    if len(args) == 1:
        print("Usage: coe.py <filename>")
        return 1

    from_asm(args[1])

if __name__ == "__main__":
    sys.exit(main(sys.argv))
