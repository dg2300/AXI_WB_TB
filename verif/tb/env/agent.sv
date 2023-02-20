`include "uvm_macros.svh"
import uvm_pkg::*;

class axi_agent extends uvm_agent ; 

  axi_driver    axi_drv;
  axi_sequencer axi_seqr;
  axi_monitor   axi_mntr;

 `uvm_component_utils(axi_agent); 


 	 //constructor  
 	 function new(string name = "axi_agent",uvm_component parent);  
    super.new(name,parent); 
   endfunction 

 	 //build phase  
 	 function void build_phase(uvm_phase phase);  
    super.build_phase(phase); 
    axi_drv  = axi_driver::type_id::create("axi_drv",this); 
    axi_seqr = axi_sequencer::type_id::create("axi_seqr",this);
    axi_mntr = axi_monitor::type_id::create("axi_mntr",this);
   endfunction 

 	 //connect phase  
 	 function void connect_phase(uvm_phase phase);  
    super.connect_phase(phase); 
    axi_drv.seq_item_port.connect(axi_seqr.seq_item_export);
   endfunction 


endclass
