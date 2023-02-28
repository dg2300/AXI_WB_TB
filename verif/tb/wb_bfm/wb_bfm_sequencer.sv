`include "uvm_macros.svh"
import uvm_pkg::*;
//NOT USING THIS FOR BFM , Placeholder only 
class wb_bfm_sequencer extends uvm_sequencer#(wb_bfm_seq_item);

  `uvm_component_utils(wb_bfm_sequencer); 
  //constructor  
 	 function new(string name = "wb_bfm_sequencer",uvm_component parent);  
    super.new(name,parent); 
   endfunction 

   //build phase  
 	 function void build_phase(uvm_phase phase);  
    super.build_phase(phase); 
   endfunction

endclass
