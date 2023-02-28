`include "uvm_macros.svh"
import uvm_pkg::*;

class wb_bfm_monitor extends uvm_monitor;
    
  virtual wb_bfm_interface wb_intf_vif;

  `uvm_component_utils(wb_bfm_monitor)

  function new(string name = "wb_bfm_monitor", uvm_component parent);  
   super.new(name,parent); 
  endfunction;

  function void build_phase (uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual wb_bfm_interface)::get(this,"","wb_intf_vif",wb_intf_vif)) begin
        `uvm_fatal(get_type_name(),"Didnt get handle to virtual interface if_name");
      end
  endfunction

  virtual task run_phase(uvm_phase phase);
  endtask

  task monitor();
  endtask

endclass

