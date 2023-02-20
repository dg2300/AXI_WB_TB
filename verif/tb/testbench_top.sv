`include "uvm_macros.svh"
import uvm_pkg::*;

`include "verif/tb_axi_interface.sv"
`include "verif/tb/seqlib/sequence.sv"
`include "verif/tb/env/sequencer.sv"
`include "verif/tb/env/monitor.sv"
`include "verif/tb/env/driver.sv"
`include "verif/tb/env/agent.sv"
`include "verif/tb/env/scoreboard.sv"
`include "verif/tb/env/env.sv"
`include "verif/test/new_test/test_1.sv"

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
     .busy                (axi_intf.tb_busy)
  );

  //something to do with virtual interface TODO: understand
  initial begin
    uvm_config_db#(virtual axi_interface)::set(uvm_root::get(),"*","axi_interface_vif",axi_intf); 
   
    `ifdef ENABLE_DUMP
      //generate dump method 
      $fsdbDumpvars(0,axis_wb_master,axi_interface);
    `endif
  end

  initial begin
    run_test();
  end

endmodule
