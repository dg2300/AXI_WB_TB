`include "uvm_macros.svh"
import uvm_pkg::*;

class axi_driver extends uvm_driver#(axi_seq_item) ; 

 `uvm_component_utils(axi_driver); 
 
  axi_seq_item axi_seq_item_h ;
  //interface declaration
  virtual axi_interface axi_interface_vif; 


 	//constructor  
 	function new(string name = "axi_driver", uvm_component parent);  
   super.new(name,parent); 
  endfunction; 


 	//build phase  
 	function void build_phase(uvm_phase phase);  
    super.build_phase(phase);   
     if(!uvm_config_db#(virtual axi_interface)::get(this,"","axi_interface_vif",axi_interface_vif)) begin
        `uvm_fatal(get_type_name(),"Didnt get handle to virtual interface if_name"); 
     end

  endfunction 


 	//run_phase  
 	virtual task run_phase(uvm_phase phase);  
   forever begin 
    seq_item_port.get_next_item(axi_seq_item_h);
      `uvm_info(get_type_name(),$sformatf("DEBUG Driver got packet now sending packet"),UVM_LOW); 
      drive_item(); //user defined drive function 
    seq_item_port.item_done(); 
    end 
  endtask; 


 	virtual task drive_item(); 
  
    `uvm_info(get_type_name(),$sformatf("Inside Drive item task"),UVM_LOW); 
    @(posedge axi_interface_vif.clock);
      `uvm_info(get_type_name(),$sformatf("DEBUG clock came"),UVM_LOW);
    
        wait(!axi_interface_vif.reset);
        `uvm_info(get_type_name(),$sformatf("DEBUG reset came"),UVM_LOW);
          `uvm_info(get_type_name(),$sformatf("Sending tvalid == %h , tdata == %h",axi_seq_item_h.input_axis_tvalid,axi_seq_item_h.input_axis_tdata),UVM_LOW);
          axi_interface_vif.tb_input_axis_tvalid <= axi_seq_item_h.input_axis_tvalid;
          axi_interface_vif.tb_input_axis_tdata <= axi_seq_item_h.input_axis_tdata ;  
    
     
  endtask 
endclass
