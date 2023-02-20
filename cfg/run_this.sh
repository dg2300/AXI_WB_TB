#============
#COMPILE COMMAND
#============

#vcs  -timescale=1ns/1ns -licqueue -kdb -debug_access+all -lca -ntb_opts uvm -sverilog +define+ENABLE_DUMP  +incdir+ $UVM_HOME/src -f $WBTB/cfg/filelist.f  &&
vcs -timescale=1ns/1ns -licqueue -kdb -debug_access+all -lca -ntb_opts uvm -sverilog +incdir+ $UVM_HOME/src  -f $WBTB/cfg/filelist.f   &&

echo '########################################################################################'
echo '#################################BUILD DONE#############################################'
echo '########################################################################################'
#============
#RUN COMMAND
#============
simv +UVM_TESTNAME=axi_test +UVM_TIMEOUT=150ns -l run.log && 
#============
#DUMP COMMAND
#============
verdi -ssf novas.fsdb
