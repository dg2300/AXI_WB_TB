`include "uvm_macros.svh"
import uvm_pkg::*;

module top;
  bit clock;
  bit reset;

  //clock generation  
  always #1 clock = ~clock;
  
  //reset generation
  initial begin
    reset = 1;
    #5 reset = 0;
  end

 //axi_tb_interface
 axi_interface axi_intf(clock,reset);
 wb_bfm_interface wb_bfm_intf(clock,reset); //add here

 //Dut instance
 axis_wb_master axi_dut( 
     .clk                 (axi_intf.clock),
     .rst                 (axi_intf.reset),
     .input_axis_tdata    (axi_intf.tb_input_axis_tdata),
     .input_axis_tkeep    (axi_intf.tb_input_axis_tkeep),
     .input_axis_tvalid   (axi_intf.tb_input_axis_tvalid),
     .input_axis_tready   (axi_intf.tb_input_axis_tready),
     .input_axis_tlast    (axi_intf.tb_input_axis_tlast),
     .input_axis_tuser    (axi_intf.tb_input_axis_tuser),

     .output_axis_tdata   (axi_intf.tb_output_axis_tdata),
     .output_axis_tkeep   (axi_intf.tb_output_axis_tkeep),
     .output_axis_tvalid  (axi_intf.tb_output_axis_tvalid),
     .output_axis_tready  (axi_intf.tb_output_axis_tready),
     .output_axis_tlast   (axi_intf.tb_output_axis_tlast),
     .output_axis_tuser   (axi_intf.tb_output_axis_tuser),
     .busy                (axi_intf.tb_busy),

     .wb_adr_o            (axi_intf.tb_wb_adr_o),
     //.wb_dat_i            (axi_intf.tb_wb_dat_i), //connect bfm
     .wb_dat_i            (wb_bfm_intf.bfm_wbm_dat_o), //connect bfm
     .wb_dat_o            (axi_intf.tb_wb_dat_o),
     .wb_we_o             (axi_intf.tb_wb_we_o),
     .wb_sel_o            (axi_intf.tb_wb_sel_o),
     .wb_stb_o            (axi_intf.tb_wb_stb_o),
     //.wb_ack_i            (axi_intf.tb_wb_ack_i), //connect bfm
     .wb_ack_i            (wb_bfm_intf.bfm_wbm_ack_o), //connect bfm
     //.wb_err_i            (axi_intf.tb_wb_err_i), //connect bfm
     .wb_err_i            (wb_bfm_intf.bfm_wbm_err_o), //connect bfm
     .wb_cyc_o            (axi_intf.tb_wb_cyc_o)
  );

  assign wb_bfm_intf.bfm_wbm_adr_i  = axi_intf.tb_wb_adr_o;
  assign wb_bfm_intf.bfm_wbm_dat_i  = axi_intf.tb_wb_dat_o;
  assign wb_bfm_intf.bfm_wbm_we_i   = axi_intf.tb_wb_we_o;
  assign wb_bfm_intf.bfm_wbm_sel_i  = axi_intf.tb_wb_sel_o;
  assign wb_bfm_intf.bfm_wbm_stb_i  = axi_intf.tb_wb_stb_o;
  assign wb_bfm_intf.bfm_wbm_cyc_i  = axi_intf.tb_wb_cyc_o;
  
  assign axi_intf.tb_wb_dat_i = wb_bfm_intf.bfm_wbm_dat_o;
  assign axi_intf.tb_wb_ack_i = wb_bfm_intf.bfm_wbm_ack_o;
  assign axi_intf.tb_wb_err_i = wb_bfm_intf.bfm_wbm_err_o;

  //something to do with virtual interface TODO: understand
  initial begin
    uvm_config_db#(virtual axi_interface)::set(uvm_root::get(),"*","axi_interface_vif",axi_intf);
   uvm_config_db#(virtual wb_bfm_interface)::set(uvm_root::get(),"*","wb_intf_vif",wb_bfm_intf);
   
    `ifdef ENABLE_DUMP
      //generate dump method 
      $fsdbDumpvars(0,axis_wb_master,axi_interface,wb_bfm_interface);
    `endif
  end

  initial begin
    run_test();
  end

endmodule
