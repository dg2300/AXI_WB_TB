`include "uvm_macros.svh"
import uvm_pkg::*;


class env extends uvm_env ; 
  axi_agent axi_agnt ;
  wb_bfm_agent wb_bfm_agnt;
  axi_scoreboard axi_scrbd ;
 `uvm_component_utils(env); 

 	 //constructor  
 	 function new(string name = "env",uvm_component parent);  
    super.new(name,parent); 
   endfunction 

 	 //build phase  
 	 function void build_phase(uvm_phase phase);  
    super.build_phase(phase);
    axi_agnt = axi_agent::type_id::create("axi_agnt",this); 
    wb_bfm_agnt = wb_bfm_agent::type_id::create("wb_bfm_agnt",this); 
    axi_scrbd = axi_scoreboard::type_id::create("axi_scrbd",this); 
   endfunction 

  //---------------------------------------
  // connect_phase - connecting monitor and scoreboard port
  //---------------------------------------
  function void connect_phase(uvm_phase phase);
    axi_agnt.axi_mntr.item_collected_port.connect(axi_scrbd.item_collected_export);
  endfunction : connect_phase



endclass
