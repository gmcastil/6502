#!/usr/bin/env python3

"""
Produces a .MIF file from a Xilinx .COE file for use in simulation

"""
class Foo(object):

    def __init__(self, filenmame):
        self.filename = filename

    def __iter__(self):
        return self

    def next(self):
        with open(self.filename, 'r') as lines:
            if line.startswith(';') or line.startswith('memory'):
                pass
            else:
                for byte in line.split():
                    return byte.lower()
