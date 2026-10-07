## OLED screen (through Pmod Header JD)
set_property -dict { PACKAGE_PIN T14 IOSTANDARD LVCMOS33   } [get_ports { OLED_CSEL }];
set_property -dict { PACKAGE_PIN T15 IOSTANDARD LVCMOS33   } [get_ports { OLED_SDIN }];
set_property -dict { PACKAGE_PIN R14 IOSTANDARD LVCMOS33   } [get_ports { OLED_SCLK }];
set_property -dict { PACKAGE_PIN U14 IOSTANDARD LVCMOS33   } [get_ports { OLED_MODE }];
set_property -dict { PACKAGE_PIN U15 IOSTANDARD LVCMOS33   } [get_ports { OLED_RSET }];
set_property -dict { PACKAGE_PIN V17 IOSTANDARD LVCMOS33   } [get_ports { OLED_VSCR }];
set_property -dict { PACKAGE_PIN V18 IOSTANDARD LVCMOS33   } [get_ports { OLED_VLOG }];
