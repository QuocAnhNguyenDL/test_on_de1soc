set_global_assignment -entity "clk165" -library "lib_clk165" -name IP_TOOL_NAME "altera_pll"
set_global_assignment -entity "clk165" -library "lib_clk165" -name IP_TOOL_VERSION "20.1"
set_global_assignment -entity "clk165" -library "lib_clk165" -name IP_TOOL_ENV "mwpim"
set_global_assignment -library "lib_clk165" -name SPD_FILE [file join $::quartus(sip_path) "clk165.spd"]

set_global_assignment -library "lib_clk165" -name MISC_FILE [file join $::quartus(sip_path) "clk165_sim/clk165.vo"]
