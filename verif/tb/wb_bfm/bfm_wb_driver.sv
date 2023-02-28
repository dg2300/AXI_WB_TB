`include "uvm_macros.svh"
import uvm_pkg::*;

class wb_bfm_driver extends uvm_driver#(wb_bfm_seq_item);
    
  virtual wb_bfm_interface wb_intf_vif;
  wb_bfm_seq_item wb_bfm_seq_item_h;

  `uvm_component_utils(wb_bfm_driver);

  function new(string name = "wb_bfm_driver", uvm_component parent);  
   super.new(name,parent); 
  endfunction;

  function void build_phase (uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual wb_bfm_interface)::get(this,"","wb_intf_vif",wb_intf_vif)) begin
        `uvm_fatal(get_type_name(),"Didnt get handle to virtual interface if_name");
    end
  endfunction

  virtual task run_phase(uvm_phase phase);
    forever begin  
    //seq_item_port.get_next_item(wb_bfm_seq_item_h); //FIXME :: maybe dont need this
      `uvm_info(get_type_name(),$sformatf("DEBUG Driver got packet now sending packet"),UVM_LOW); 
      drive(); //user defined drive function 
    //seq_item_port.item_done(); //FIXME :: Maybe dont need this 
    end 
  endtask

  task drive();
    @(posedge wb_intf_vif.clk);
        `uvm_info(get_type_name(),$sformatf("DEBUG clock came"),UVM_LOW);
      wait(!wb_intf_vif.rst);
        `uvm_info(get_type_name(),$sformatf("DEBUG reset came"),UVM_LOW);
      wait(wb_intf_vif.bfm_wbm_stb_i); 
        `uvm_info(get_type_name(),$sformatf("DEBUG look alive"),UVM_LOW);
          wb_intf_vif.bfm_wbm_ack_o ='b1;
  endtask

endclass
  
