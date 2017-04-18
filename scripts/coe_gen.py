"""
Builds a COE file filled with 65C02 NOP codes

This is an initial script developed to create a COE file filled with NOP opcodes
for initializing memory content with the Xilinx Distributed Memory Generator
(8.0).  It builds it in a sensible way that is still somewhat reasonable.  For
example:

;; $0000 to $0FFF
0F 0F 0F 0F 0F 0F 0F 0F 0F 0F 0F 0F 0F 0F 0F 0F 0F 0F ...
0F 0F 0F 0F 0F 0F 0F 0F 0F 0F 0F 0F 0F 0F 0F 0F 0F 0F ...
...
...
;; $1000 to $1FFF
...
...

This is not very flexible but it is useful for generating a quick COE file for
completely defining the entire space.  Note that distributed memories larger
than 64k (65,536) are not supported by the Xilinx memory generation tool.

; Sample Initialization file for a 16x32 distributed ROM
memory_initialization_radix = 16;
memory_initialization_vector =

"""
COE_FILE = "./basic.coe"

HIGH_ADDRESS = 2**16  # 64k address space
MAX_ADDRESS = 2**16  # this is the largest that the memory generator accepts

PAGE_SIZE = 2**12  # 4096 addresses per page
ROW_SIZE = 2**6  # number of rows per page
COL_SIZE = 2**6  # number of cols per page

OPCODE = "0F"  # opcode to fill COE file with

def make_page():
    """Constructs a range of addresses for writing a page to a COE file

    Args:
        start_addr: (int) - Starting address of the page

    Returns:
        list: Rows of strings to write to a COE file

    """
    page = [make_row() for row in range(ROW_SIZE)]
    return "\n".join(page)

def make_row(opcode=OPCODE):
    """Constructs a row filled with `opcode`

    Args:
        opcode (str): Opcode to fill the row with

    Returns:
        str: Row of opcodes

    """
    row = [opcode for addr in range(COL_SIZE)]
    return " ".join(row)

def main():
    """Builds a COE file with the supplied dimensions filled with `opcode`

    Args:
        None

    Returns:
        None

    """
    if (ROW_SIZE * COL_SIZE != PAGE_SIZE):
        print "Page dimensions are incorrect. Check row and column sizes"
        return None
    if (HIGH_ADDRESS > MAX_ADDRESS):
        print "Requested dimensions are too large.  Check address space size"
        return None
    with open(COE_FILE, 'wb') as coe_file:
        header = [";; Distributed Memory Generator COE file\n",
                  ";; \tAddress Size = {HIGH_ADDRESS}\n".format(HIGH_ADDRESS=HIGH_ADDRESS),
                  ";; \tPage Size = {PAGE_SIZE}\n.".format(PAGE_SIZE=PAGE_SIZE),
                  ";; memory_initialization_radix = 16;\n",
                  ";; memory_initialization_vector = \n"]
        coe_file.write("".join(header))
        page_numbers = 2**16 / 2**12
        for page_number in range(page_numbers):
            start_addr = hex(page_number * PAGE_SIZE)
            end_addr = hex((page_number + 1) * PAGE_SIZE - 1)
            page_hdr = (";; Addresses from {start_addr} to {end_addr}.\n".format(start_addr=start_addr,end_addr=end_addr))
            lines = (page_hdr, make_page(), "\n")
            coe_file.writelines(lines)

if __name__ == "__main__":
    main()
