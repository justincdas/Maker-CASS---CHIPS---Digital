#--------------------------------------
# Icarus Verilog and GTK Wave Makefile
# Author :: Justin C Das
#-------------------------------------
# make comp :: For Compilation only
# make sim  :: For Compilation + Simulation
# make wave :: For Compilation + Simulation + Waveform view
# make clean :: Cleanup the Directory
#--------------------------------------

#--------------------------------------
#Change This
SRC      = elevator.v
TB       = tb.v
#--------------------------------------

#--------------------------------------
#Tools
SIMULATOR = vvp
VIEWER    = gtkwave

#Tool Options
CFLAGS  = -v -Wall -Winfloop 
SFLAGS  = -v
COUTPUT  = comp.out

#Tool Output
COUTPUT = compiler.out
#--------------------------------------

#--------------------------------------
comp  : $(TB) $(SRC)
	iverilog $(SFLAGS) -o $(COUTPUT) $(SRC) $(TB) | tee comp.log

sim   : comp
	vvp $(SFLAGS) $(COUTPUT) | tee sim.log
        
wave  : sim 
	gtkwave waves.vcd &

clean : 
	rm -rf *.log *.out *.vcd
        
