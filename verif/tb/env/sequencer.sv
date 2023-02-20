class axi_sequencer extends uvm_sequencer#(axi_seq_item) ; 

 `uvm_component_utils(axi_sequencer); 

 	 //constructor  
 	 function new(string name = "axi_sequencer",uvm_component parent);  
    super.new(name,parent); 
   endfunction 

   //build phase  
 	 function void build_phase(uvm_phase phase);  
    super.build_phase(phase); 
   endfunction 

endclass