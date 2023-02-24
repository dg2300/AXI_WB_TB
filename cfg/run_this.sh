#!/bin/bash
#USAGE  default run cmd : run_this.sh &  
#USAGE  switches run cmd : run_this.sh -d dump_en -t all -s "+axi_write_req"&  
#USAGE  switches  -d can be dump_en or dump_dis , default is dump_dis , to enable or disable dump generation 
#USAGE  switches  -t can be build_only or run_only or all , default is all ,  
#USAGE  switches  -s is run time commands for simv execution passed like < "+arg1 +arg2" >

echo "Running run_this.sh..."

#alias runme 'cfg/run_this.sh'

#defaults
dump_en='dump_dis';
type_ex='all';
run_cmd_args='';

while getopts "d:t:s:h:" opt; do
  case $opt in
    d) dump_en="$OPTARG";;
    t) type_ex="$OPTARG";;
    s) run_cmd_args="$OPTARG";;
    h) echo "#USAGE  default run cmd : runme   
            #USAGE  switches run cmd : runme -d dump_en -t all -s "+test_plus_arg +value_plus_arg=var"&  
            #USAGE  switches  -d can be dump_en or dump_dis , default is dump_dis , to enable or disable dump generation 
            #USAGE  switches  -t can be build_only or run_only or all , default is all ,  
            #USAGE  switches  -s is run time commands for simv execution passed like < "+arg1 +arg2" >" exit 1;;
    \?) echo "Invalid option: -$OPTARG" >&2; exit 1;;
  esac
done

echo "DUMP: $dump_en"
echo "EXEC TYPE: $type_ex"
echo "RUN CMD ARG: $run_cmd_args"

 function build() {
    #============
    #COMPILE COMMAND
    #============ 
    echo "#################################STARTING SCRIPT##########################################"
    if [[ $dump_en == "dump_en" ]]; then
      echo "Starting Compile with dump..."
      echo "##########################################################################################"
      echo "vcs  -timescale=1ns/1ns -licqueue -kdb -debug_access+all -lca -ntb_opts uvm -sverilog +define+ENABLE_DUMP  +incdir+ $UVM_HOME/src -f $WBTB/cfg/filelist.f -l target.log  &"
      vcs  -timescale=1ns/1ns -licqueue -kdb -debug_access+all -lca -ntb_opts uvm -sverilog +define+ENABLE_DUMP  +incdir+ $UVM_HOME/src -f $WBTB/cfg/filelist.f -l target.log  &
        PID=$!
        wait $PID
    else
      echo "Starting Compile without dump..."
      echo "##########################################################################################"
      echo "vcs  -timescale=1ns/1ns -licqueue -kdb -debug_access+all -lca -ntb_opts uvm -sverilog +incdir+ $UVM_HOME/src -f $WBTB/cfg/filelist.f -l target.log &"
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
}
commandvar=$run_cmd_args;
function run() {
    # Generate a random integer between 0 and 32767
    rand=$RANDOM     
    echo "cmd var  $commandvar"
    #============
    #RUN COMMAND
    #============
    if [ -f "simv" ]; then
        echo '#################################EXECUTION START#########################################'
    
        echo "simv exists. Running command..."
        # command to run if simv exists
        echo "Seed = $rand"
        echo "simv +UVM_TESTNAME=axi_test +UVM_TIMEOUT=150ns $commandvar -l run.log +ntb_random_seed=$rand &"
        simv +UVM_TESTNAME=axi_test +UVM_TIMEOUT=150ns $commandvar -l run.log +ntb_random_seed=$rand &
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
}

function dump() {
    #============
    #DUMP COMMAND
    #============
    if [[ $dump_en == "dump_en" ]]; then
      echo "Starting dump..."
      verdi -ssf novas.fsdb &
    echo '########################################################################################'
    echo '#################################DUMP DONE##############################################'
    echo '########################################################################################'
    else
      echo "No dump... Exiting script"
    fi
}

if [[ $type_ex == "build_only" ]]; then
  build;
elif [[ $type_ex == "run_only" ]]; then
  run;
  dump;
else
  build;
  run;
  dump;
fi  

echo '########################################################################################'
echo '#################################END OF SCRIPT##########################################'
echo '########################################################################################'


exit 0
