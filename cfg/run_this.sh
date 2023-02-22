#!/bin/bash
#============
#COMPILE COMMAND
#============
echo "Running run_this.sh..."
echo "#################################STARTING SCRIPT##########################################"
if [[ $1 == "w_dump" ]]; then
  echo "Starting Compile with dump..."
  echo "##########################################################################################"
  vcs  -timescale=1ns/1ns -licqueue -kdb -debug_access+all -lca -ntb_opts uvm -sverilog +define+ENABLE_DUMP  +incdir+ $UVM_HOME/src -f $WBTB/cfg/filelist.f -l target.log  &
    PID=$!
    wait $PID
else
  echo "Starting Compile without dump..."
  echo "##########################################################################################"
  vcs  -timescale=1ns/1ns -licqueue -kdb -debug_access+all -lca -ntb_opts uvm -sverilog +incdir+ $UVM_HOME/src -f $WBTB/cfg/filelist.f -l target.log &
    PID=$!
    wait $PID
fi

 if [ $? -eq 0 ]
 then
   echo "########################################################################################"
   echo "#################################BUILD SUCCESS##########################################"
   echo "########################################################################################"
 else
   echo "!!!!!!!!!!!!!!!!!!!!!!!!!!BUILD FAILED!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
   exit 1
 fi


#vcs  -timescale=1ns/1ns -licqueue -kdb -debug_access+all -lca -ntb_opts uvm -sverilog +define+ENABLE_DUMP  +incdir+ $UVM_HOME/src -f $WBTB/cfg/filelist.f  &&
#vcs -timescale=1ns/1ns -licqueue -kdb -debug_access+all -lca -ntb_opts uvm -sverilog +incdir+ $UVM_HOME/src  -f $WBTB/cfg/filelist.f   &&

#============
#RUN COMMAND
#============
if [ -f "simv" ]; then
    echo '#################################EXECUTION START#########################################'

    echo "simv exists. Running command..."
    # command to run if simv exists
    simv +UVM_TESTNAME=axi_test +UVM_TIMEOUT=150ns +AXI_WRITE_REQ -l run.log &
    PID=$!
    wait $PID
    echo '########################################################################################'
    echo '#################################EXEC DONE##############################################'
    echo '########################################################################################'
else
    echo "simv does not exist."
    echo '!!!!!!!!!!!!!!!!!!!!!!!!!!BUILD FAILED!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!'
    exit 1
fi
 
#============
#DUMP COMMAND
#============
if [[ $1 == "w_dump" ]]; then
  echo "Starting dump..."
  verdi -ssf novas.fsdb &
echo '########################################################################################'
echo '#################################DUMP DONE##############################################'
echo '########################################################################################'
else
  echo "No dump... Exiting script"
fi

echo '########################################################################################'
echo '#################################END OF SCRIPT##########################################'
echo '########################################################################################'


exit 0

