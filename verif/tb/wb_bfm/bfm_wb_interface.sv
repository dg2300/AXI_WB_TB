interface wb_bfm_interface #(
    parameter ADDR_WIDTH = 32,                        // width of address bus in bits
    parameter WBM_DATA_WIDTH = 32,                    // width of master data bus in bits (8, 16, 32, or 64)
    parameter WBM_SELECT_WIDTH = (WBM_DATA_WIDTH/8),  // width of master word select bus (1, 2, 4, or 8)
    parameter WBS_DATA_WIDTH = 32,                    // width of slave data bus in bits (8, 16, 32, or 64)
    parameter WBS_SELECT_WIDTH = (WBS_DATA_WIDTH/8)   // width of slave word select bus (1, 2, 4, or 8)
)(input clk , rst);

  logic [ADDR_WIDTH-1:0]       bfm_wbm_adr_i;  //keep from axi
  logic [WBM_DATA_WIDTH-1:0]   bfm_wbm_dat_i; //keep from axi
  logic [WBM_DATA_WIDTH-1:0]   bfm_wbm_dat_o; //keep to axi
    
  logic                        bfm_wbm_we_i;   //keep from axi
  logic [WBM_SELECT_WIDTH-1:0] bfm_wbm_sel_i;  //keep from axi
  logic                        bfm_wbm_stb_i;  //keep from axi
  logic                        bfm_wbm_ack_o;  //keep to axi
  logic                        bfm_wbm_err_o;  //keep to axi
  logic                        bfm_wbm_rty_o;  //keep to axi
  logic                        bfm_wbm_cyc_i; //keep from axi


endinterface
