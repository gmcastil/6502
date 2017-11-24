This directory contains a collection of test ROMs that I will create as my
codebase grows in size.

`absolute.asm` - ROM for testing absolute addressing mode

To use a ROM with a Xilinx block memory, the file first needs to be 'assembled'
into a coefficients file (.coe) and then provided as an argument when invoking
the Block Memory Generator (the `scripts` directory contains tools for
generating block memory of the correct size). Alternatively, an existing block
memory can be used with a memory initialization file (.mif).
