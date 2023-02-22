`include "uvm_macros.svh"
import uvm_pkg::*;

class axi_seq_item extends uvm_sequence_item;
  

  rand bit[7:0] input_axis_tdata ;
  rand bit      input_axis_tvalid ;
  bit[7:0]      output_axis_tdata ;

  rand bit[7:0] input_axis_tdata_req ;
  rand bit[31:0] input_axis_tdata_address ; //TODO : tune with param
  rand bit[31:0] input_axis_tdata_data ;


  `uvm_object_utils_begin(axi_seq_item)
    `uvm_field_int (input_axis_tdata,UVM_ALL_ON)
    `uvm_field_int (input_axis_tdata_req,UVM_ALL_ON)
    `uvm_field_int (input_axis_tdata_address,UVM_ALL_ON)
    `uvm_field_int (input_axis_tdata_data,UVM_ALL_ON)
    `uvm_field_int (input_axis_tvalid,UVM_ALL_ON)
  `uvm_object_utils_end 

  function new(string name = "axi_seq_item");
    super.new(name);
  endfunction

  constraint tdata {soft input_axis_tdata_req inside {8'hA1,8'hA2};}   //READ_REQ | WRITE_REQ
  constraint tvalid {soft input_axis_tvalid == 1;}   //READ_REQ | WRITE_REQ
                                                                       
endclass
//*********************************************************************//
class axi_random_sequence extends uvm_sequence#(axi_seq_item) ; 

 `uvm_object_utils(axi_random_sequence);  

  axi_seq_item axi_seq_item_h; 

 	//constructor  
 	function new(string name = "axi_random_sequence");  
    super.new(name); 
  endfunction; 

 	task body();  
    //sequence body here 
    `uvm_do(axi_seq_item_h); 
  endtask 

endclass

//*********************************************************************//
class axi_read_sequence extends uvm_sequence#(axi_seq_item) ; 

 `uvm_object_utils(axi_read_sequence);  

  axi_seq_item axi_seq_item_h;

 	//constructor  
 	function new(string name = "axi_read_sequence");  
    super.new(name); 
  endfunction; 

 	task body();  
    //sequence body here 
    `uvm_info(get_type_name(),$sformatf("Inside axi read sequence"),UVM_LOW);
    `uvm_do_with(axi_seq_item_h,{axi_seq_item_h.input_axis_tdata_req==8'hA1; //READ_REQ
                                 axi_seq_item_h.input_axis_tvalid==1;    
                               });  
  endtask
endclass
//*********************************************************************//
 class axi_write_sequence extends uvm_sequence#(axi_seq_item) ; 

 `uvm_object_utils(axi_write_sequence);  

  axi_seq_item axi_seq_item_h;

 	//constructor  
 	function new(string name = "axi_write_sequence");  
    super.new(name); 
  endfunction; 

 	task body();  
    //sequence body here
    `uvm_info(get_type_name(),$sformatf("Inside axi write sequence"),UVM_LOW); 
    `uvm_do_with(axi_seq_item_h,{axi_seq_item_h.input_axis_tdata_req==8'hA2; //WRITE_REQ
                                 //axi_seq_item_h.input_axis_tdata_address==32'hf7481504;
                                 //axi_seq_item_h.input_axis_tdata_data==32'hd1d2d3d4;
                                 axi_seq_item_h.input_axis_tvalid==1;    
                               });  
  endtask

endclass

