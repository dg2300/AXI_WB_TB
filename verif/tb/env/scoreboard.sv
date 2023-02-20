`include "uvm_macros.svh"
import uvm_pkg::*;

class axi_scoreboard extends uvm_scoreboard ; 


 `uvm_component_utils(axi_scoreboard); 
  //interface declaration
  virtual axi_interface axi_interface_vif;
  axi_seq_item axi_qu[$];
  axi_seq_item axi_pkt; //used to store queue feeds

  //---------------------------------------
  //Array to store 
  //---------------------------------------
  //bit [7:0] sc_axi_pkt_q[*];  //TODO : not needed for now

  //---------------------------------------
  //port to recive packets from monitor
  //---------------------------------------
  uvm_analysis_imp#(axi_seq_item, axi_scoreboard) item_collected_export;

 	 //constructor  
 	 function new(string name = "axi_scoreboard",uvm_component parent);  
    super.new(name,parent); 
   endfunction 

 	 //build phase  
 	 function void build_phase(uvm_phase phase);  
    super.build_phase(phase); 
    item_collected_export = new("item_collected_export", this);
   endfunction 


  virtual function void write(axi_seq_item axi_pkt);  //Is it callback ? - Yes
  //the uvm_analysis_port class, which is used for communication between components, also provides a .write() method for writing data to connected components.
    //axi_pkt.print();
    axi_qu.push_back(axi_pkt);
  endfunction : write

  virtual task run_phase(uvm_phase phase);
    forever begin
      wait(axi_qu.size()>0);
      axi_pkt = axi_qu.pop_front();
      //axi_pkt.print();
      if(axi_pkt.input_axis_tdata == 'ha1 && axi_pkt.input_axis_tvalid) begin //read req
        if(axi_pkt.output_axis_tdata == 'ha3) begin  //read resp
          `uvm_info(get_type_name(),$sformatf("------ :: Expected Response recieved:: ------"),UVM_LOW)
          `uvm_info(get_type_name(),$sformatf("Input_axis_tdata : %0h",axi_pkt.input_axis_tdata),UVM_LOW)
          `uvm_info(get_type_name(),$sformatf("output_axis_tdata : %0h",axi_pkt.output_axis_tdata),UVM_LOW)
          `uvm_info(get_type_name(),"------------------------------------",UVM_LOW)
        end else begin
          `uvm_error(get_type_name(),$sformatf("------ ::Un-Expected Response recieved:: ------"))
          `uvm_info(get_type_name(),$sformatf("Input_axis_tdata : %0h",axi_pkt.input_axis_tdata),UVM_LOW)
          `uvm_info(get_type_name(),$sformatf("output_axis_tdata : %0h",axi_pkt.output_axis_tdata),UVM_LOW)
          `uvm_info(get_type_name(),"------------------------------------",UVM_LOW)           
        end
      end //read check
      if(axi_pkt.input_axis_tdata == 'ha2 && axi_pkt.input_axis_tvalid) begin //read req
        if(axi_pkt.output_axis_tdata == 'ha4) begin  //read resp
          `uvm_info(get_type_name(),$sformatf("------ :: Expected Response recieved:: ------"),UVM_LOW)
          `uvm_info(get_type_name(),$sformatf("Input_axis_tdata : %0h",axi_pkt.input_axis_tdata),UVM_LOW)
          `uvm_info(get_type_name(),$sformatf("output_axis_tdata : %0h",axi_pkt.output_axis_tdata),UVM_LOW)
          `uvm_info(get_type_name(),"------------------------------------",UVM_LOW)
        end else begin
          `uvm_error(get_type_name(),$sformatf("------ ::Un-Expected Response recieved:: ------"))
          `uvm_info(get_type_name(),$sformatf("Input_axis_tdata : %0h",axi_pkt.input_axis_tdata),UVM_LOW)
          `uvm_info(get_type_name(),$sformatf("output_axis_tdata : %0h",axi_pkt.output_axis_tdata),UVM_LOW)
          `uvm_info(get_type_name(),"------------------------------------",UVM_LOW)
        end 
      end // write check

    end //forever
  endtask : run_phase 

endclass
