set_global_assignment -entity "ufm" -library "lib_ufm" -name IP_TOOL_NAME "Qsys"
set_global_assignment -entity "ufm" -library "lib_ufm" -name IP_TOOL_VERSION "20.1"
set_global_assignment -entity "ufm" -library "lib_ufm" -name IP_TOOL_ENV "Qsys"
set_global_assignment -library "lib_ufm" -name SPD_FILE [file join $::quartus(sip_path) "../ufm.spd"]
set_global_assignment -library "lib_ufm" -name MISC_FILE [file join $::quartus(sip_path) "../../ufm.qsys"]

set_global_assignment -library "lib_ufm" -name MISC_FILE [file join $::quartus(sip_path) "ufm.v"]
set_global_assignment -library "lib_ufm" -name MISC_FILE [file join $::quartus(sip_path) "submodules/altera_onchip_flash_util.v"]
set_global_assignment -library "lib_ufm" -name MISC_FILE [file join $::quartus(sip_path) "submodules/altera_onchip_flash.v"]
set_global_assignment -library "lib_ufm" -name MISC_FILE [file join $::quartus(sip_path) "submodules/altera_onchip_flash_avmm_data_controller.v"]
