interface axi_interface #
(
    parameter IMPLICIT_FRAMING = 0,                  // implicit framing (ignore tlast, look for start)
    parameter COUNT_SIZE = 16,                       // size of word count register
    parameter AXIS_DATA_WIDTH = 8,                   // width of AXI data bus
    parameter AXIS_KEEP_WIDTH = (AXIS_DATA_WIDTH/8), // width of AXI bus tkeep signal
    parameter WB_DATA_WIDTH = 32,                    // width of data bus in bits (8, 16, 32, or 64)
    parameter WB_ADDR_WIDTH = 32,                    // width of address bus in bits
    parameter WB_SELECT_WIDTH = (WB_DATA_WIDTH/8),   // width of word select bus (1, 2, 4, or 8)
    parameter READ_REQ = 8'hA1,                      // read requst type
    parameter WRITE_REQ = 8'hA2,                     // write requst type
    parameter READ_RESP = 8'hA3,                     // read response type
    parameter WRITE_RESP = 8'hA4                     // write response type
)(input clock,reset);

 

    logic [AXIS_DATA_WIDTH-1:0] tb_input_axis_tdata ; 
    logic [AXIS_KEEP_WIDTH-1:0] tb_input_axis_tkeep ;
    logic tb_input_axis_tvalid ;
    logic tb_input_axis_tready ;   //output wire ?
    logic tb_input_axis_tlast ;
    logic tb_input_axis_tuser ;
    
    logic [AXIS_DATA_WIDTH-1:0] tb_output_axis_tdata;
    logic [AXIS_KEEP_WIDTH-1:0] tb_output_axis_tkeep;
    logic tb_output_axis_tvalid;
    logic tb_output_axis_tready;  //input wire
    logic tb_output_axis_tlast;
    logic tb_output_axis_tuser;
    logic tb_busy;

endinterface 
 

