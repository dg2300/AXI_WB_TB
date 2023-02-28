`include "uvm_macros.svh"
import uvm_pkg::*;
//NOT USING THIS FOR BFM , Placeholder only
class wb_bfm_seq_item extends uvm_sequence_item;

  rand bit[31:0] bfm_item_wbm_adr_i;  //keep from axi
  rand bit[31:0] bfm_item_wbm_dat_i; //keep from axi
    
  rand bit      bfm_item_wbm_we_i;   //keep from axi
  rand bit[3:0] bfm_item_wbm_sel_i;  //keep from axi
  rand bit      bfm_item_wbm_stb_i;  //keep from axi
  bit           bfm_item_wbm_ack_o;  //keep to axi - drive these 
  bit           bfm_item_wbm_err_o;  //keep to axi - drive these
  bit           bfm_item_wbm_rty_o;  //keep to axi - drive these
  rand bit      bfm_item_wbm_cyc_i; //keep from axi

  `uvm_object_utils_begin(wb_bfm_seq_item)
    `uvm_field_int (bfm_item_wbm_adr_i,UVM_ALL_ON);  //keep from axi
    `uvm_field_int (bfm_item_wbm_dat_i,UVM_ALL_ON); //keep from axi
    `uvm_field_int (bfm_item_wbm_we_i,UVM_ALL_ON);   //keep from axi
    `uvm_field_int (bfm_item_wbm_sel_i,UVM_ALL_ON);  //keep from axi
    `uvm_field_int (bfm_item_wbm_stb_i,UVM_ALL_ON);  //keep from axi
    `uvm_field_int (bfm_item_wbm_cyc_i,UVM_ALL_ON); //keep from axi
  `uvm_object_utils_end 

  function new(string name = "axi_seq_item");
    super.new(name);
  endfunction

endclass
