// debug.v

// Generated using ACDS version 14.1 186 at 2021.04.24.16:05:28

`timescale 1 ps / 1 ps
module debug (
		input  wire [9:0] probe,  //  probes.probe
		output wire [7:0] source  // sources.source
	);

	altsource_probe #(
		.sld_auto_instance_index ("YES"),
		.sld_instance_index      (0),
		.instance_id             ("NONE"),
		.probe_width             (10),
		.source_width            (8),
		.source_initial_value    ("0"),
		.enable_metastability    ("NO")
	) in_system_sources_probes_0 (
		.source (source), // sources.source
		.probe  (probe)   //  probes.probe
	);

endmodule
