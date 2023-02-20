`include "uvm_macros.svh"
import uvm_pkg::*;

class axi_monitor extends uvm_monitor ; 


 `uvm_component_utils(axi_monitor); 
  bit[7:0] local_tdata_var_temp = 0 ;
  bit[7:0] store_tdata_var_temp = 0 ;
  axi_seq_item trans_collected_axi_seq_item_h ;
  //interface declaration
  virtual axi_interface axi_interface_vif;

  //---------------------------------------
  // analysis port, to send the transaction to scoreboard
  //---------------------------------------
  uvm_analysis_port #(axi_seq_item) item_collected_port;


 	 //constructor  
 	 function new(string name = "axi_monitor",uvm_component parent);  
    super.new(name,parent);
    trans_collected_axi_seq_item_h = axi_seq_item::type_id::create("trans_collected_axi_seq_item_h",this);
    item_collected_port = new("item_collected_port", this);
   endfunction 

 	 //build phase  
 	 function void build_phase(uvm_phase phase);  
    super.build_phase(phase); 
     if(!uvm_config_db#(virtual axi_interface)::get(this,"","axi_interface_vif",axi_interface_vif)) begin
        `uvm_fatal(get_type_name(),"Didnt get handle to virtual interface if_name"); 
     end
   endfunction 

   virtual task run_phase (uvm_phase phase) ; 
    forever begin 

      @(posedge axi_interface_vif.clock);
        `uvm_info(get_type_name(),$sformatf("DEBUG clock came"),UVM_LOW);
      
        wait(!axi_interface_vif.reset);
        `uvm_info(get_type_name(),$sformatf("DEBUG reset came"),UVM_LOW);
        wait(axi_interface_vif.tb_input_axis_tvalid);
        trans_collected_axi_seq_item_h.input_axis_tvalid = axi_interface_vif.tb_input_axis_tvalid;
        trans_collected_axi_seq_item_h.input_axis_tdata = axi_interface_vif.tb_input_axis_tdata;
        store_tdata_var_temp = axi_interface_vif.tb_input_axis_tdata;

        @(posedge axi_interface_vif.clock);
        #1;
        trans_collected_axi_seq_item_h.output_axis_tdata = axi_interface_vif.tb_output_axis_tdata;
        
        if( local_tdata_var_temp != store_tdata_var_temp) begin
          `uvm_info(get_type_name(),$sformatf("Sending to scoreboard tvalid == %h , in tdata == %h , out tdata == %h",trans_collected_axi_seq_item_h.input_axis_tvalid,trans_collected_axi_seq_item_h.input_axis_tdata,trans_collected_axi_seq_item_h.output_axis_tdata),UVM_LOW);
          item_collected_port.write(trans_collected_axi_seq_item_h);
          
          local_tdata_var_temp = store_tdata_var_temp ;
        end
      end 
  endtask : run_phase

endclass
