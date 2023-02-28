`include "uvm_macros.svh"
import uvm_pkg::*;

class wb_bfm_agent extends uvm_agent;

  wb_bfm_driver wb_bfm_drv;
  wb_bfm_monitor wb_bfm_mntr;
  wb_bfm_sequencer wb_bfm_seqr;

  `uvm_component_utils(wb_bfm_agent);

   //constructor  
 	 function new(string name = "wb_bfm_agent",uvm_component parent);  
    super.new(name,parent); 
   endfunction

  function void build_phase (uvm_phase phase);
    super.build_phase(phase);

    wb_bfm_drv = wb_bfm_driver::type_id::create("wb_bfm_drv",this);
    wb_bfm_mntr = wb_bfm_monitor::type_id::create("wb_bfm_mntr",this);
    wb_bfm_seqr = wb_bfm_sequencer::type_id::create("wb_bfm_seqr",this);
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    wb_bfm_drv.seq_item_port.connect(wb_bfm_seqr.seq_item_export);
  endfunction


endclass
