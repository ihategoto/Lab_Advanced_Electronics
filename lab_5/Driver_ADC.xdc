## ADC (through Pmod Header JC)
set_property -dict { PACKAGE_PIN V15 IOSTANDARD LVCMOS33 } [get_ports { ADC_CSEL }];
set_property -dict { PACKAGE_PIN W15 IOSTANDARD LVCMOS33 } [get_ports { ADC_SDA1 }];
set_property -dict { PACKAGE_PIN T11 IOSTANDARD LVCMOS33 } [get_ports { ADC_SDA2 }];
set_property -dict { PACKAGE_PIN T10 IOSTANDARD LVCMOS33 } [get_ports { ADC_SCLK }];
