# Makefile for Interfaces - Lab02 


# SIMULATOR = Questa for Mentor's Questasim
# SIMULATOR = VCS for Synopsys's VCS

SIMULATOR = VCS


FSDB_PATH=/home/cad/eda/SYNOPSYS/VERDI_2022/verdi/T-2022.06-SP1/share/PLI/VCS/LINUX64

RTL= ../rtl/*.v
work= work #library name
SVTB2= ../test/top.sv
INC = +incdir+../env +incdir+../env_lib +incdir+../test
SVTB1 = ../env/ram_if.sv  ../test/ram_pkg.sv
VSIMOPT= -vopt -voptargs=+acc  
VSIMBATCH= -c -do  " log -r /* ;run -all; exit"

help:
	@echo =================================================================================
	@echo " USAGE   	--  make target                             				"
	@echo " clean   	=>  clean the earlier log and intermediate files.       	"
	@echo " sv_cmp    	=>  Create library and compile the code.                   	"
	@echo " run_sim    =>  run the simulation in batch mode.                   		"
	@echo " run_test	=>  clean, compile & run the simulation in batch mode.		" 
	@echo " view_wave  =>  To view the waveform.    								" 
	@echo =================================================================================

clean : clean_$(SIMULATOR)
sv_cmp : sv_cmp_$(SIMULATOR)
run_sim : run_sim_$(SIMULATOR)
run_test : run_test_$(SIMULATOR)
view_wave : view_wave_$(SIMULATOR)
	
# ---- Start of Definitions for Mentor's Questa Specific Targets -----#

sv_cmp_Questa:
	vlib $(work)
	vmap work $(work)
	vlog -work $(work) $(RTL) $(INC) $(SVTB1) $(SVTB2)
	
run_sim_Questa:
	vsim  $(VSIMOPT) $(VSIMBATCH)  -wlf wave_file.wlf -l test.log -sv_seed random work.top
		 
clean_Questa:
	rm -rf transcript* *log* *.wlf modelsim.ini work
	clear

run_test_Questa: clean_Questa sv_cmp_Questa run_sim_Questa

view_wave_Questa:
	vsim -view wave_file.wlf


# ---- End of Definitions for Mentor's Questa Specific Targets -----#

# ---- Start of Definitions for Synopsys VCS Specific Targets -----#

sv_cmp_VCS:
	vcs -full64 -l comp.log -sverilog -debug_access+all -kdb -lca -P $(FSDB_PATH)/novas.tab $(FSDB_PATH)/pli.a $(RTL) $(INC) $(SVTB1) $(SVTB2)
 
run_sim_VCS: 
	./simv -l vcs.log -vdb mem_cov.vdb +ntb_random_seed=$(SEED)
	
clean_VCS:
	rm -rf *simv* csrc* *.tmp *.vpd *.vdb *.key *.log *.fsdb *hdrs.h novas* verdi*
	clear 
	
run_test_VCS: clean_VCS sv_cmp_VCS run_sim_VCS

view_wave_VCS:
	verdi -ssf novas.fsdb

# ---- End of Definitions for Synopsys VCS Specific Targets -----#
	


