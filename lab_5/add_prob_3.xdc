## Clock signal
set_property -dict { PACKAGE_PIN K17 IOSTANDARD LVCMOS33 } [get_ports { CLK_125M }];

# pushButton
set_property -dict { PACKAGE_PIN K18 IOSTANDARD LVCMOS33 } [get_ports { pushButton }];

# Switch
set_property -dict { PACKAGE_PIN G15 IOSTANDARD LVCMOS33 } [get_ports { SW }];

# LED
set_property -dict { PACKAGE_PIN V12 IOSTANDARD LVCMOS33 } [get_ports { LED[0] }];
set_property -dict { PACKAGE_PIN W16 IOSTANDARD LVCMOS33 } [get_ports { LED[1] }];
set_property -dict { PACKAGE_PIN J15 IOSTANDARD LVCMOS33 } [get_ports { LED[2] }];
set_property -dict { PACKAGE_PIN H15 IOSTANDARD LVCMOS33 } [get_ports { LED[3] }];
set_property -dict { PACKAGE_PIN V13 IOSTANDARD LVCMOS33 } [get_ports { LED[4] }];
set_property -dict { PACKAGE_PIN U17 IOSTANDARD LVCMOS33 } [get_ports { LED[5] }];
set_property -dict { PACKAGE_PIN T17 IOSTANDARD LVCMOS33 } [get_ports { LED[6] }];
set_property -dict { PACKAGE_PIN Y17 IOSTANDARD LVCMOS33 } [get_ports { LED[7] }];

# Board LED
set_property -dict { PACKAGE_PIN M14 IOSTANDARD LVCMOS33 } [get_ports { B_LED }];