`include "uvm_macros.svh"
import uvm_pkg::*;

class axi_test extends uvm_test ; 

  env env_h;
  axi_random_sequence axi_random_sequence_h;
  axi_read_sequence axi_read_sequence_h;
  axi_write_sequence axi_write_sequence_h;
 `uvm_component_utils(axi_test); 


 	 //constructor  
 	 function new(string name = "axi_test",uvm_component parent);  
    super.new(name,parent); 
   endfunction 



 	 //build phase  
 	 function void build_phase(uvm_phase phase);  
    super.build_phase(phase); 
    env_h = env::type_id::create("env_h",this);
    axi_read_sequence_h = axi_read_sequence::type_id::create("axi_read_sequence_h",this);
    axi_random_sequence_h = axi_random_sequence::type_id::create("axi_random_sequence_h",this);
    axi_write_sequence_h = axi_write_sequence::type_id::create("axi_read_sequence_h",this);
   endfunction 

  //---------------------------------------
  // end_of_elobaration phase
  //---------------------------------------  
  virtual function void end_of_elaboration();
    //print's the topology
    print();
  endfunction

   task run_phase(uvm_phase phase);
    
    phase.raise_objection(this);

      if($test$plusargs("AXI_WRITE_REQ"))begin
        `uvm_info(get_type_name(),$sformatf("DEBUG Sending AXI write req sequence"),UVM_LOW);
        axi_write_sequence_h.start(env_h.axi_agnt.axi_seqr);
      end 
      else if($test$plusargs("AXI_READ_REQ"))begin
        `uvm_info(get_type_name(),$sformatf("DEBUG Sending AXI read req sequence"),UVM_LOW);
        axi_read_sequence_h.start(env_h.axi_agnt.axi_seqr);
      end else begin
        `uvm_info(get_type_name(),$sformatf("DEBUG Sending AXI random req sequence"),UVM_LOW);
        axi_random_sequence_h.start(env_h.axi_agnt.axi_seqr);
      end
   
      //#1000ns;
    phase.drop_objection(this);
     
    //phase.phase_done.set_drain_time(this,50);
  endtask : run_phase

 function void report_phase(uvm_phase phase);
   uvm_report_server svr;
   super.report_phase(phase);
   
   svr = uvm_report_server::get_server();
   if(svr.get_severity_count(UVM_FATAL)+svr.get_severity_count(UVM_ERROR)>0) begin
     `uvm_info(get_type_name(), "---------------------------------------", UVM_NONE)
     `uvm_info(get_type_name(), "----            TEST FAIL          ----", UVM_NONE)
     `uvm_info(get_type_name(), "---------------------------------------", UVM_NONE)
    end
    else begin
     `uvm_info(get_type_name(), "---------------------------------------", UVM_NONE)
     `uvm_info(get_type_name(), "----           TEST PASS           ----", UVM_NONE)
     `uvm_info(get_type_name(), "---------------------------------------", UVM_NONE)
    end
  endfunction 

endclass
