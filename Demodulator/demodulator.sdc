derive_clock_uncertainty
create_clock -period 50MHz -name {clk} [get_ports {clk}]
derive_pll_clocks
set_clock_groups -exclusive -group {pll|altpll_component|auto_generated|pll1|clk[0]} -group {pll|altpll_component|auto_generated|pll1|clk[1]}
