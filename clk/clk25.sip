set_global_assignment -entity "clk25" -library "lib_clk25" -name IP_TOOL_NAME "altera_pll"
set_global_assignment -entity "clk25" -library "lib_clk25" -name IP_TOOL_VERSION "20.1"
set_global_assignment -entity "clk25" -library "lib_clk25" -name IP_TOOL_ENV "mwpim"
set_global_assignment -library "lib_clk25" -name SPD_FILE [file join $::quartus(sip_path) "clk25.spd"]

set_global_assignment -library "lib_clk25" -name MISC_FILE [file join $::quartus(sip_path) "clk25_sim/clk25.vo"]
