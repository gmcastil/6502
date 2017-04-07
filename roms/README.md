This directory contains a collection of test ROMs that I will create as my
codebase grows in size.

/basic.rom/ - A very simple test ROM that contains an entire 64kB space filled
with mostly illegal opcodes and a reset vector.  The reset vector points to a
very simple program that performs a sequence of NOP ($EA) and then jumps back to
the beginning of the program.  The intent with this is to show that the
processor is emerging from reset, finding the location of the reset routine, and
some very basic instructions (which do not require much logic) are being
executed.  My plan is to put this into hardware and put chipscope on the program
counter so that I can observe what is happening inside.
