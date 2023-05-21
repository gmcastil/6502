Xilinx IP is notoriously hard to source control, particularly for complicated IP
such as a memory controller.  The fragility increases when IP configuration
extends beyond the normal Xilinx core instance (XCI) files and requires
additional information.  The expected method for controlling these parameters is
to create a Vivado project, use IP Integrator to manage the sources, module
customization parameters, and generally everything else, while concealing the
details behind many layers of obfuscation and indirection.

One of the most difficult pieces of IP to control is the processing subsystem
that is used in designs targeting Zynq-7000 and Zynq UltraScale+ devices.  These
IP blocks are more than abstractions of RTL and represent the configuration of
the entire processing subsystem (PS) and its interface to the programmable logic
(PL) of the device.  This includes the PS-PL interface, interrupt generation,
hard IP configuration within the ARM cores (e.g., ethernet), the SDRAM
controller, clocking, and much more.

To offer such a configurable device to its end customers, it is understandable
that Xilinx has chosen to develop the block design flow, where a GUI is used to
interactively configure the PS and programmatically generate the configuration
information as a collection of XML files. The PS is then treated by the
synthesis engine as another piece of Xilinx IP like any other and can then be
snapped into IP Integrator based block designs.  In principal, this works great,
and the marketing folks at Xilinx have spilled no shortage of ink in proclaiming
the superiority of their design flow over the traditional RTL based design flow,
where one simply controls a giant list of VHDL or Verilog files, fires the
synthesizer at the pile, and comes back to a netlist that can then be placed and
routed.

For a variety of reasons, which should be clear to anyone that has spent a
significant amount of time working with SoC or MPSoC based designs, the existing
design flow can be a real nightmare to work with, particularly when trying to
apply source control.  The Xilinx approved approach to source control of IP
Integrator designs has been something of a moving target from version to version
and is still unacceptable to many.  Most engineers appear to have embraced some
sort of measured approach where the Xilinx project flow is preserved, but with
substantial pruning of non-essential so that the commit history is not
absolutely wrecked every time a minor change is made to the IP.

This project is an attempt to develop a non-trivial hardware and software design
using the Zynq-7000, with a Linux kernel running on the PS and as little
involvement of the Xilinx IP Integrator tool as possible.  IP Integrator is not
required for tradition FPGA based designs - all Xilinx IP, at least for
7-Series, UltraScale, and UltraScale+ - can be stored off as XCI files or TCL
scripts which can then be used by Vivado (see for example, the `import_ip`
command) to recreate the IP and directly instantiated in RTL based designs. The
entire flow can be automated using various combinations of shell and Vivado TCL
scripts with very little interactive involvement.  For large projects,
particularly those that rely on third party synthesis or simulation tools, this
is very much the professional approach.

The picture changes dramatically with the entrance of PS configuration - since
the required information is no longer synthesizable RTL but low level software,
the piles of RTL and shell scripts do not completely describe the necessary
output. To determine the configuration and allow instantiation of the processing
subsystem, Vivado appears to rely upon several things:
- The XCI file, which is an XML file containing processing subsystem
  configuration information. This file is sufficient to recreate the processing
  subsystem configuration *ex nihilo* for a particular board and can be dragged
  into a design using the `import_ip` command.
- In principle, the XCI is sufficient to allow one to instantiate the component.
  However, the number of ports and generics is large (about 700 ports for a
Zynq-7000 and another 300 generics) and getting them all correct is not
practical, particularly given that the moment one abandons the block design
features, very little direct documentation exists on any of this. Furthermore,
many of the ports that leave the processing subsystem IP instantiation do not
connect to anything in the top level netlist (e.g., the `ENET0_GMII_TX_CLK` pin)
do not connect to anything else in the top-level synthesizable netlist from
Vivado.  The tool needs to be instructed on how to handle what are very specific
details about the PS-PL interface. This appears to be handled through the use of
synthesis attributes. In principle, one could probably instantiate the
processing subsystem like any other piece of IP, manually craft the appropriate
synthesis pragmas, and run the RTL through the synthesis engine and emerge with
the final output product.  That is not particularly feasible and it is far
better to rely on the tools, particularly the block designer, to generate that
information instead and then instantiate that block like any other design
entity. After the Zynq PS is configured in the block designer as desired (and
strongly indicated by Xilinx), the block design can be completed by generating
the output products, which instantiates the IP core and generates all of the
necessary information. This is distinct from generating an HDL wrapper around
the block design, which creates another piece of abstraction (more wrappers of
wrappers). The central detail to understand is that a standalone PS,
appropriately configured, can be created as a block design with only a Zynq
processing subsystem and whatever higher level ports are made external to the
block. The RTL file created when the output products for a block design are
created is dropped into several locations, all of which are identical, and can
be plucked from a project in the
`<project-name>.gen/sources_1/bd/zynq_ps/synth/` directory, or something similar
to that.  One can see from opening it that it contains, depending upon the
configuration, a truncated `zynq_ps_processing_system7_0_0` component
instantiation, along with a number of synthesis pragmas and directives. It also
exposes whichever interfaces the user set as external in the block designer.
- That HDL wrapper around the PS core instance contains a reference to a
  hardware definition file, which is an archive containing more XML files, one
of which carries PS configuration information and is potentially needed for
exporting a design to the SDK.

This entire discussion naturally needs to be understood in context - none of
this is how Xilinx intends its tools to be used and it is entirely based on
trial and error, experiement, and what is essentially reverse engineering.
Also, it is largely focused around applications that will be running a Linux
kernel and U-boot as the bootloader, both of which are flexible and capable
enough to make up for any shortcomings that are introduced by ignoring the
typical flow from Vivado -> Vitis -> PetaLinux.  It also relies upon the
developer to not only understand device trees, hardware configuration, the boot
process, and a great many other concepts, but to also be willing to take
responsibility for writing their own device tree entries and drivers, handling
the details of cross-compiling for their target platform, and quite a few other
things.  Indeed, this complexity is the raison d'etre for the IP Integrator
based flow that Xilinx has developed, which seeks to hide as much of those
implementation details from engineers.  Also, it should be noted that there are
design flows through Vivado and Vitis that are not feasible to unravel in this
manner (e.g., accelerated applications). This project and design approach is
very specific to the application at hand and it was acknowledge at the beginning
that specific responsibilities would be made on the designer to manage the
complexities incurred by choosing to not use the recommended design
flow.

