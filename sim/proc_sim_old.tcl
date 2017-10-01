


















# Set some top level locations
set src "../src/"
set ip "../build/"

set design_lib [list $src/proc.v $src/alu.v $ip/memory_block/memory_block_sim_netlist.v $ip/memory_block/sim/memory_block.v]

set test_lib [list $src/proc_tb.v]
}

set top_module test_lib.proc_tb

set time_now [clock seconds]
if [catch {set time_last_compile}] {
   set time_last_compile 0
}

foreach {library file_list} $libraries {
   puts $library

   vlib $library
   vmap work $library
   foreach file $file_list {
      if { $time_last_compile < [file mtime $file] } {
         if [regexp {.vhdl?$} $file] {
            vcom -93 $file
         } else {
            vlog $file
         }
         set time_last_compile 0
      }
   }
}
set time_last_compile 0
