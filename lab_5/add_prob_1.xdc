## Clock signal
set_property -dict { PACKAGE_PIN K17 IOSTANDARD LVCMOS33 } [get_ports { CLK_125M }];

## Buttons
set_property -dict { PACKAGE_PIN K18 IOSTANDARD LVCMOS33 } [get_ports { pushButton }];

## Switches
set_property -dict { PACKAGE_PIN G15 IOSTANDARD LVCMOS33 } [get_ports { SW }];