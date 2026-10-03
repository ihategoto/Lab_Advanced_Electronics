## Clock signal
set_property -dict { PACKAGE_PIN K17 IOSTANDARD LVCMOS33 } [get_ports { CLK_125M }];

## Switches
set_property -dict { PACKAGE_PIN G15 IOSTANDARD LVCMOS33 } [get_ports { SW[0] }];
set_property -dict { PACKAGE_PIN P15 IOSTANDARD LVCMOS33 } [get_ports { SW[1] }];
set_property -dict { PACKAGE_PIN W13 IOSTANDARD LVCMOS33 } [get_ports { SW[2] }];
set_property -dict { PACKAGE_PIN T16 IOSTANDARD LVCMOS33 } [get_ports { SW[3] }];
## Buttons
set_property -dict { PACKAGE_PIN K18 IOSTANDARD LVCMOS33 } [get_ports { BTN_0 }];
set_property -dict { PACKAGE_PIN P16 IOSTANDARD LVCMOS33 } [get_ports { BTN_1 }];
set_property -dict { PACKAGE_PIN K19 IOSTANDARD LVCMOS33 } [get_ports { BTN_2 }];
set_property -dict { PACKAGE_PIN Y16 IOSTANDARD LVCMOS33 } [get_ports { BTN_3 }];

## LEDs (through Pmod Header JE)
set_property -dict { PACKAGE_PIN V12 IOSTANDARD LVCMOS33 } [get_ports { LED[0] }];
set_property -dict { PACKAGE_PIN W16 IOSTANDARD LVCMOS33 } [get_ports { LED[1] }];
set_property -dict { PACKAGE_PIN J15 IOSTANDARD LVCMOS33 } [get_ports { LED[2] }];
set_property -dict { PACKAGE_PIN H15 IOSTANDARD LVCMOS33 } [get_ports { LED[3] }];
set_property -dict { PACKAGE_PIN V13 IOSTANDARD LVCMOS33 } [get_ports { LED[4] }];
set_property -dict { PACKAGE_PIN U17 IOSTANDARD LVCMOS33 } [get_ports { LED[5] }];
set_property -dict { PACKAGE_PIN T17 IOSTANDARD LVCMOS33 } [get_ports { LED[6] }];
set_property -dict { PACKAGE_PIN Y17 IOSTANDARD LVCMOS33 } [get_ports { LED[7] }];

## OLED screen (through Pmod Header JD)
set_property -dict { PACKAGE_PIN T14 IOSTANDARD LVCMOS33   } [get_ports { OLED_CSEL }];
set_property -dict { PACKAGE_PIN T15 IOSTANDARD LVCMOS33   } [get_ports { OLED_SDIN }];
set_property -dict { PACKAGE_PIN R14 IOSTANDARD LVCMOS33   } [get_ports { OLED_SCLK }];
set_property -dict { PACKAGE_PIN U14 IOSTANDARD LVCMOS33   } [get_ports { OLED_MODE }];
set_property -dict { PACKAGE_PIN U15 IOSTANDARD LVCMOS33   } [get_ports { OLED_RSET }];
set_property -dict { PACKAGE_PIN V17 IOSTANDARD LVCMOS33   } [get_ports { OLED_VSCR }];
set_property -dict { PACKAGE_PIN V18 IOSTANDARD LVCMOS33   } [get_ports { OLED_VLOG }];

## DAC (through Pmod Header JC1)
set_property -dict { PACKAGE_PIN W14 IOSTANDARD LVCMOS33 } [get_ports { DAC_CSEL }];
set_property -dict { PACKAGE_PIN Y14 IOSTANDARD LVCMOS33 } [get_ports { DAC_SDA1 }];
set_property -dict { PACKAGE_PIN T12 IOSTANDARD LVCMOS33 } [get_ports { DAC_SDA2 }];
set_property -dict { PACKAGE_PIN U12 IOSTANDARD LVCMOS33 } [get_ports { DAC_SCLK }];

## ADC (through Pmod Header JC2)
set_property -dict { PACKAGE_PIN V15 IOSTANDARD LVCMOS33 } [get_ports { ADC_CSEL }];
set_property -dict { PACKAGE_PIN W15 IOSTANDARD LVCMOS33 } [get_ports { ADC_SDA1 }];
set_property -dict { PACKAGE_PIN T11 IOSTANDARD LVCMOS33 } [get_ports { ADC_SDA2 }];
set_property -dict { PACKAGE_PIN T10 IOSTANDARD LVCMOS33 } [get_ports { ADC_SCLK }];

## On-board LEDs
set_property -dict { PACKAGE_PIN M14 IOSTANDARD LVCMOS33 } [get_ports { B_LED[0] }];
set_property -dict { PACKAGE_PIN M15 IOSTANDARD LVCMOS33 } [get_ports { B_LED[1] }];
set_property -dict { PACKAGE_PIN G14 IOSTANDARD LVCMOS33 } [get_ports { B_LED[2] }];
set_property -dict { PACKAGE_PIN D18 IOSTANDARD LVCMOS33 } [get_ports { B_LED[3] }];
## On-board RGB LED
set_property -dict { PACKAGE_PIN V16 IOSTANDARD LVCMOS33 } [get_ports { RGBLED_R }];
set_property -dict { PACKAGE_PIN F17 IOSTANDARD LVCMOS33 } [get_ports { RGBLED_G }];
set_property -dict { PACKAGE_PIN M17 IOSTANDARD LVCMOS33 } [get_ports { RGBLED_B }];
