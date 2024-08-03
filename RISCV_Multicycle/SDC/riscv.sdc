derive_pll_clocks
derive_clock_uncertainty
create_clock -period 50MHz -name {clk} [get_ports {clk}]


set_false_path -from [get_ports {rst}] -to [all_clocks]
set_false_path -from [get_ports {leds[*]}] -to [all_clocks]
