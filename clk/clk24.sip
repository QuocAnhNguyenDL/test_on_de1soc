set_global_assignment -entity "clk24" -library "lib_clk24" -name IP_TOOL_NAME "altera_pll"
set_global_assignment -entity "clk24" -library "lib_clk24" -name IP_TOOL_VERSION "20.1"
set_global_assignment -entity "clk24" -library "lib_clk24" -name IP_TOOL_ENV "mwpim"
set_global_assignment -library "lib_clk24" -name SPD_FILE [file join $::quartus(sip_path) "clk24.spd"]

set_global_assignment -library "lib_clk24" -name MISC_FILE [file join $::quartus(sip_path) "clk24_sim/clk24.vo"]
