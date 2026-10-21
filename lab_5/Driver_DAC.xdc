## DAC (through Pmod Header JC)
set_property -dict { PACKAGE_PIN W14 IOSTANDARD LVCMOS33 } [get_ports { DAC_CSEL }];
set_property -dict { PACKAGE_PIN Y14 IOSTANDARD LVCMOS33 } [get_ports { DAC_SDA1 }];
set_property -dict { PACKAGE_PIN T12 IOSTANDARD LVCMOS33 } [get_ports { DAC_SDA2 }];
set_property -dict { PACKAGE_PIN U12 IOSTANDARD LVCMOS33 } [get_ports { DAC_SCLK }];
