`include "uvm_macros.svh"
import uvm_pkg::*;

class axi_driver extends uvm_driver#(axi_seq_item) ; 

 `uvm_component_utils(axi_driver); 
 
  axi_seq_item axi_seq_item_h ;
  //interface declaration
  virtual axi_interface axi_interface_vif; 


 	//constructor  
 	function new(string name = "axi_driver", uvm_component parent);  
   super.new(name,parent); 
  endfunction; 


 	//build phase  
 	function void build_phase(uvm_phase phase);  
    super.build_phase(phase);   
     if(!uvm_config_db#(virtual axi_interface)::get(this,"","axi_interface_vif",axi_interface_vif)) begin
        `uvm_fatal(get_type_name(),"Didnt get handle to virtual interface if_name"); 
     end

  endfunction 


 	//run_phase  
 	virtual task run_phase(uvm_phase phase);  
   forever begin 
    seq_item_port.get_next_item(axi_seq_item_h);
      `uvm_info(get_type_name(),$sformatf("DEBUG Driver got packet now sending packet"),UVM_LOW); 
      drive_item(); //user defined drive function 
    seq_item_port.item_done(); 
    end 
  endtask; 


 	virtual task drive_item(); 
  bit[7:0] lsb =0 , msb =7 ;
    `uvm_info(get_type_name(),$sformatf("Inside Drive item task"),UVM_LOW); 
    @(posedge axi_interface_vif.clock);
      `uvm_info(get_type_name(),$sformatf("DEBUG clock came"),UVM_LOW);
    
        wait(!axi_interface_vif.reset);
        `uvm_info(get_type_name(),$sformatf("DEBUG reset came"),UVM_LOW);
          `uvm_info(get_type_name(),$sformatf("Sending tvalid == %h , tdata == %h",axi_seq_item_h.input_axis_tvalid,axi_seq_item_h.input_axis_tdata),UVM_LOW);
          `uvm_info(get_type_name(),$sformatf("Sending tdata_req == %h , tdata_address == %h, tdata_data == %h ",axi_seq_item_h.input_axis_tdata_req,axi_seq_item_h.input_axis_tdata_address,axi_seq_item_h.input_axis_tdata_data),UVM_LOW);
          
          axi_interface_vif.tb_output_axis_tready <= 'hd1; //added here TODO
          axi_interface_vif.tb_input_axis_tuser <= 'hd1; //added here TODO   //start of packet
          axi_interface_vif.tb_input_axis_tvalid <= axi_seq_item_h.input_axis_tvalid; //no need of sequence item for now.
          
          axi_interface_vif.tb_input_axis_tdata <= axi_seq_item_h.input_axis_tdata_req ; //request type 
 
          @(posedge axi_interface_vif.clock);
            //deassert tuser -> tsuer indicating start of packet is 1 clock cycle pulse
            axi_interface_vif.tb_input_axis_tuser <= 'hd0;

          
          lsb =0 ;
          msb =7 ;
          //sending address flits - 32 bit wide , 8 bit flits iteration = 4
            for(int index = 0;index < 4 ; index++)begin
                 //axi_interface_vif.tb_input_axis_tdata <= axi_seq_item_h.input_axis_tdata_address[lsb:msb];
                 axi_interface_vif.tb_input_axis_tdata <= axi_seq_item_h.input_axis_tdata_address[lsb+:8]; 
                 `uvm_info(get_type_name(),$sformatf("Sending address flit pos[%d:%d] = %h",lsb,msb,axi_seq_item_h.input_axis_tdata_address[lsb+:8]),UVM_LOW);
                 lsb = msb+1;
                 msb = msb+8;
                 if(axi_seq_item_h.input_axis_tdata_req==8'hA1) begin 
                    `uvm_info(get_type_name(),$sformatf("DEBUG No write req"),UVM_LOW); 
                    if(index == 3) begin 
                      axi_interface_vif.tb_input_axis_tlast <= 'h1;                      
                    end 
                  end//sending tlast with last data flit
                 @(posedge axi_interface_vif.clock); //wait for next clock
            end
            
         
            if(axi_seq_item_h.input_axis_tdata_req==8'hA1) begin axi_interface_vif.tb_input_axis_tvalid <= 0; end



    if(axi_seq_item_h.input_axis_tdata_req==8'hA2) begin
            for(int index = 0;index < 2 ; index++)begin      //FIXME : sending zz data  for 2 clock cycles    
              axi_interface_vif.tb_input_axis_tdata <= 'hz;  // FIXME : Not sure why these needs to be like this - but it works somehow
              @(posedge axi_interface_vif.clock);           
            end
      axi_interface_vif.tb_input_axis_tvalid <= 1;
 //DATA works fine           
            //lsb = 24 ; 
            //msb = 31 ;
          lsb =0 ;
          msb =7 ;
          //sending data flits - 32 bit wide , 8 bit flits iteration = 4
            for(int index = 0;index < 4 ; index++)begin
                 //axi_interface_vif.tb_input_axis_tdata <= axi_seq_item_h.input_axis_tdata_data[lsb:msb];
                 //axi_interface_vif.tb_input_axis_tdata <= axi_seq_item_h.input_axis_tdata_data[msb-:8];
                 //`uvm_info(get_type_name(),$sformatf("Sending data flit pos[%d:%d] = %h",lsb,msb,axi_seq_item_h.input_axis_tdata_data[msb-:8]),UVM_LOW);
                 //msb = lsb - 1;
                 //lsb = (msb+1)-8;
                 axi_interface_vif.tb_input_axis_tdata <= axi_seq_item_h.input_axis_tdata_data[lsb+:8]; 
                 `uvm_info(get_type_name(),$sformatf("Sending data flit pos[%d:%d] = %h",lsb,msb,axi_seq_item_h.input_axis_tdata_data[lsb+:8]),UVM_LOW);
                 lsb = msb+1;
                 msb = msb+8;

                 if(index == 3) axi_interface_vif.tb_input_axis_tlast <= 'h1; //sending tlast with last data flit
                 @(posedge axi_interface_vif.clock); //wait for next clock
            end 
    end

      axi_interface_vif.tb_input_axis_tvalid <= 'h0;
      axi_interface_vif.tb_input_axis_tdata <= 'hdzz;
      axi_interface_vif.tb_input_axis_tlast <= 'h0;
    endtask 
endclass
