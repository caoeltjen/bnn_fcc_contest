// Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2021.2 (lin64) Build 3367213 Tue Oct 19 02:47:39 MDT 2021
// Date        : Mon Apr 13 23:39:52 2026
// Host        : ece-lnx-07 running 64-bit Red Hat Enterprise Linux Server release 7.9 (Maipo)
// Command     : write_verilog -force -mode funcsim
//               /ecel/UFAD/ca.oeltjen/Desktop/BNN/bnn_synth/bnn_synthesis/bnn_synthesis.gen/sources_1/ip/threshold_bram/threshold_bram_sim_netlist.v
// Design      : threshold_bram
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xczu3eg-sbva484-1-e
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "threshold_bram,blk_mem_gen_v8_4_5,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "blk_mem_gen_v8_4_5,Vivado 2021.2" *) 
(* NotValidForBitStream *)
module threshold_bram
   (clka,
    ena,
    wea,
    addra,
    dina,
    douta,
    clkb,
    enb,
    web,
    addrb,
    dinb,
    doutb);
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA CLK" *) (* x_interface_parameter = "XIL_INTERFACENAME BRAM_PORTA, MEM_SIZE 8192, MEM_WIDTH 32, MEM_ECC NONE, MASTER_TYPE OTHER, READ_LATENCY 1" *) input clka;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA EN" *) input ena;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA WE" *) input [0:0]wea;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA ADDR" *) input [10:0]addra;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA DIN" *) input [15:0]dina;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA DOUT" *) output [15:0]douta;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB CLK" *) (* x_interface_parameter = "XIL_INTERFACENAME BRAM_PORTB, MEM_SIZE 8192, MEM_WIDTH 32, MEM_ECC NONE, MASTER_TYPE OTHER, READ_LATENCY 1" *) input clkb;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB EN" *) input enb;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB WE" *) input [0:0]web;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB ADDR" *) input [10:0]addrb;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB DIN" *) input [15:0]dinb;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB DOUT" *) output [15:0]doutb;

  wire [10:0]addra;
  wire [10:0]addrb;
  wire clka;
  wire clkb;
  wire [15:0]dina;
  wire [15:0]dinb;
  wire [15:0]douta;
  wire [15:0]doutb;
  wire ena;
  wire enb;
  wire [0:0]wea;
  wire [0:0]web;
  wire NLW_U0_dbiterr_UNCONNECTED;
  wire NLW_U0_rsta_busy_UNCONNECTED;
  wire NLW_U0_rstb_busy_UNCONNECTED;
  wire NLW_U0_s_axi_arready_UNCONNECTED;
  wire NLW_U0_s_axi_awready_UNCONNECTED;
  wire NLW_U0_s_axi_bvalid_UNCONNECTED;
  wire NLW_U0_s_axi_dbiterr_UNCONNECTED;
  wire NLW_U0_s_axi_rlast_UNCONNECTED;
  wire NLW_U0_s_axi_rvalid_UNCONNECTED;
  wire NLW_U0_s_axi_sbiterr_UNCONNECTED;
  wire NLW_U0_s_axi_wready_UNCONNECTED;
  wire NLW_U0_sbiterr_UNCONNECTED;
  wire [10:0]NLW_U0_rdaddrecc_UNCONNECTED;
  wire [3:0]NLW_U0_s_axi_bid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_bresp_UNCONNECTED;
  wire [10:0]NLW_U0_s_axi_rdaddrecc_UNCONNECTED;
  wire [15:0]NLW_U0_s_axi_rdata_UNCONNECTED;
  wire [3:0]NLW_U0_s_axi_rid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_rresp_UNCONNECTED;

  (* C_ADDRA_WIDTH = "11" *) 
  (* C_ADDRB_WIDTH = "11" *) 
  (* C_ALGORITHM = "1" *) 
  (* C_AXI_ID_WIDTH = "4" *) 
  (* C_AXI_SLAVE_TYPE = "0" *) 
  (* C_AXI_TYPE = "1" *) 
  (* C_BYTE_SIZE = "9" *) 
  (* C_COMMON_CLK = "0" *) 
  (* C_COUNT_18K_BRAM = "0" *) 
  (* C_COUNT_36K_BRAM = "1" *) 
  (* C_CTRL_ECC_ALGO = "NONE" *) 
  (* C_DEFAULT_DATA = "0" *) 
  (* C_DISABLE_WARN_BHV_COLL = "0" *) 
  (* C_DISABLE_WARN_BHV_RANGE = "0" *) 
  (* C_ELABORATION_DIR = "./" *) 
  (* C_ENABLE_32BIT_ADDRESS = "0" *) 
  (* C_EN_DEEPSLEEP_PIN = "0" *) 
  (* C_EN_ECC_PIPE = "0" *) 
  (* C_EN_RDADDRA_CHG = "0" *) 
  (* C_EN_RDADDRB_CHG = "0" *) 
  (* C_EN_SAFETY_CKT = "0" *) 
  (* C_EN_SHUTDOWN_PIN = "0" *) 
  (* C_EN_SLEEP_PIN = "0" *) 
  (* C_EST_POWER_SUMMARY = "Estimated Power for IP     :     3.762151 mW" *) 
  (* C_FAMILY = "zynquplus" *) 
  (* C_HAS_AXI_ID = "0" *) 
  (* C_HAS_ENA = "1" *) 
  (* C_HAS_ENB = "1" *) 
  (* C_HAS_INJECTERR = "0" *) 
  (* C_HAS_MEM_OUTPUT_REGS_A = "1" *) 
  (* C_HAS_MEM_OUTPUT_REGS_B = "1" *) 
  (* C_HAS_MUX_OUTPUT_REGS_A = "0" *) 
  (* C_HAS_MUX_OUTPUT_REGS_B = "0" *) 
  (* C_HAS_REGCEA = "0" *) 
  (* C_HAS_REGCEB = "0" *) 
  (* C_HAS_RSTA = "0" *) 
  (* C_HAS_RSTB = "0" *) 
  (* C_HAS_SOFTECC_INPUT_REGS_A = "0" *) 
  (* C_HAS_SOFTECC_OUTPUT_REGS_B = "0" *) 
  (* C_INITA_VAL = "0" *) 
  (* C_INITB_VAL = "0" *) 
  (* C_INIT_FILE = "threshold_bram.mem" *) 
  (* C_INIT_FILE_NAME = "threshold_bram.mif" *) 
  (* C_INTERFACE_TYPE = "0" *) 
  (* C_LOAD_INIT_FILE = "1" *) 
  (* C_MEM_TYPE = "2" *) 
  (* C_MUX_PIPELINE_STAGES = "0" *) 
  (* C_PRIM_TYPE = "1" *) 
  (* C_READ_DEPTH_A = "2048" *) 
  (* C_READ_DEPTH_B = "2048" *) 
  (* C_READ_LATENCY_A = "1" *) 
  (* C_READ_LATENCY_B = "1" *) 
  (* C_READ_WIDTH_A = "16" *) 
  (* C_READ_WIDTH_B = "16" *) 
  (* C_RSTRAM_A = "0" *) 
  (* C_RSTRAM_B = "0" *) 
  (* C_RST_PRIORITY_A = "CE" *) 
  (* C_RST_PRIORITY_B = "CE" *) 
  (* C_SIM_COLLISION_CHECK = "ALL" *) 
  (* C_USE_BRAM_BLOCK = "0" *) 
  (* C_USE_BYTE_WEA = "0" *) 
  (* C_USE_BYTE_WEB = "0" *) 
  (* C_USE_DEFAULT_DATA = "0" *) 
  (* C_USE_ECC = "0" *) 
  (* C_USE_SOFTECC = "0" *) 
  (* C_USE_URAM = "0" *) 
  (* C_WEA_WIDTH = "1" *) 
  (* C_WEB_WIDTH = "1" *) 
  (* C_WRITE_DEPTH_A = "2048" *) 
  (* C_WRITE_DEPTH_B = "2048" *) 
  (* C_WRITE_MODE_A = "WRITE_FIRST" *) 
  (* C_WRITE_MODE_B = "WRITE_FIRST" *) 
  (* C_WRITE_WIDTH_A = "16" *) 
  (* C_WRITE_WIDTH_B = "16" *) 
  (* C_XDEVICEFAMILY = "zynquplus" *) 
  (* downgradeipidentifiedwarnings = "yes" *) 
  (* is_du_within_envelope = "true" *) 
  threshold_bram_blk_mem_gen_v8_4_5 U0
       (.addra(addra),
        .addrb(addrb),
        .clka(clka),
        .clkb(clkb),
        .dbiterr(NLW_U0_dbiterr_UNCONNECTED),
        .deepsleep(1'b0),
        .dina(dina),
        .dinb(dinb),
        .douta(douta),
        .doutb(doutb),
        .eccpipece(1'b0),
        .ena(ena),
        .enb(enb),
        .injectdbiterr(1'b0),
        .injectsbiterr(1'b0),
        .rdaddrecc(NLW_U0_rdaddrecc_UNCONNECTED[10:0]),
        .regcea(1'b0),
        .regceb(1'b0),
        .rsta(1'b0),
        .rsta_busy(NLW_U0_rsta_busy_UNCONNECTED),
        .rstb(1'b0),
        .rstb_busy(NLW_U0_rstb_busy_UNCONNECTED),
        .s_aclk(1'b0),
        .s_aresetn(1'b0),
        .s_axi_araddr({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arburst({1'b0,1'b0}),
        .s_axi_arid({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arlen({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arready(NLW_U0_s_axi_arready_UNCONNECTED),
        .s_axi_arsize({1'b0,1'b0,1'b0}),
        .s_axi_arvalid(1'b0),
        .s_axi_awaddr({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awburst({1'b0,1'b0}),
        .s_axi_awid({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awlen({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awready(NLW_U0_s_axi_awready_UNCONNECTED),
        .s_axi_awsize({1'b0,1'b0,1'b0}),
        .s_axi_awvalid(1'b0),
        .s_axi_bid(NLW_U0_s_axi_bid_UNCONNECTED[3:0]),
        .s_axi_bready(1'b0),
        .s_axi_bresp(NLW_U0_s_axi_bresp_UNCONNECTED[1:0]),
        .s_axi_bvalid(NLW_U0_s_axi_bvalid_UNCONNECTED),
        .s_axi_dbiterr(NLW_U0_s_axi_dbiterr_UNCONNECTED),
        .s_axi_injectdbiterr(1'b0),
        .s_axi_injectsbiterr(1'b0),
        .s_axi_rdaddrecc(NLW_U0_s_axi_rdaddrecc_UNCONNECTED[10:0]),
        .s_axi_rdata(NLW_U0_s_axi_rdata_UNCONNECTED[15:0]),
        .s_axi_rid(NLW_U0_s_axi_rid_UNCONNECTED[3:0]),
        .s_axi_rlast(NLW_U0_s_axi_rlast_UNCONNECTED),
        .s_axi_rready(1'b0),
        .s_axi_rresp(NLW_U0_s_axi_rresp_UNCONNECTED[1:0]),
        .s_axi_rvalid(NLW_U0_s_axi_rvalid_UNCONNECTED),
        .s_axi_sbiterr(NLW_U0_s_axi_sbiterr_UNCONNECTED),
        .s_axi_wdata({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_wlast(1'b0),
        .s_axi_wready(NLW_U0_s_axi_wready_UNCONNECTED),
        .s_axi_wstrb(1'b0),
        .s_axi_wvalid(1'b0),
        .sbiterr(NLW_U0_sbiterr_UNCONNECTED),
        .shutdown(1'b0),
        .sleep(1'b0),
        .wea(wea),
        .web(web));
endmodule
`pragma protect begin_protected
`pragma protect version = 1
`pragma protect encrypt_agent = "XILINX"
`pragma protect encrypt_agent_info = "Xilinx Encryption Tool 2021.2"
`pragma protect key_keyowner="Synopsys", key_keyname="SNPS-VCS-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
oESHD2Q5NORrmTVTCApB+YFZJwjA1ezq7U6VZh96by+ofPCvSFp06AIoCLvB4BhPvxfob6kIkBpR
xVCOLM7HsDk7nO1JVWiYIJ6okoWTA8hAlPj3sdGuMwRlZNSBKn/c6F+CW5Jl37TEGotkhycSB3Bg
B/uu1THUZwIG87RPahE=

`pragma protect key_keyowner="Aldec", key_keyname="ALDEC15_001", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
RovEhaqHrFqzjckk+DIWG8LQeqg2Y/nACQDyXKKtSav7YHlgpKmgHZnsxwwNpqrqVRGyjTecSQ+e
6Mr/Pi9au3AgJVPL6VOgwNVE0yj2LpA4LPyWzxLN3+DiSDmsaCBNCBlVQi2MRKUabou8nLaXldbL
+7pv4pYhQdcyjDzuC2dx3HmzADqstdEiyXeU3ktJ29CDLDmGwDWdmsrl90s4YQSfBV2nj4/Vut3L
p/8dzphf1htPaNMujMxxgp3z4JzUEDJJokDL+gNutEEHiaWpI3URIA5v22vJu+NPD+eEraSioHfL
DPKAajZTwK5FHnonu4O2D0co8GWqWW5cUqZz9A==

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VELOCE-RSA", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
jBQ6Th9yy7jtKQD1h235YLT6qO6XiBaBKGJrV1Z8H9M9ePJ9R/fA8E1okt4LyBvoWjR7tmCbIg7A
0/vuKOogkLtDE/BtTlp4z1iurO8rQrAcdZy/e+7GATawyJxFY7kZhnXASu9zB8TiOBELSlapkpxe
WuAzXLde9FBMBkq4RSc=

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VERIF-SIM-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
eucSNV2Zbm4zYc2tIGRlGmlVM8+WHY1NHe9drZdgDhGPOHz8PTqHapfnZ1kWuTLtPBLSMvcXNScn
UTvpULofBV6qD7WHLPg7UJcjpZVDL69lk88chgqrlc/RqaJXKNVv+Ubku53ZLU20uZK71bNymjSM
855RVWw5lvTHTCNC2MYIS94Fmrzuq8i0+tFh5qBKkHK2BC+fD7xVyyfuh4mZR2yr/hRs/emoI79E
IKoJnLiglVp6RXTsXFzZW4pIthbjWSuZlOQvoYkS2RMj8a0r9lyariphRQunoudc0bLO4Phk578c
40gusaaS/MI7idMT7k1Di96kvu5mHi23loRcZQ==

`pragma protect key_keyowner="Real Intent", key_keyname="RI-RSA-KEY-1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
E/syLaRG2Ss/xTTkuAkOKXzm53+rCptYO2DkVukWhvlLmEB2daHCPrXt4gKeuG+0hIGWedSwCiLJ
7KNtEAiTumJ/j+3p7s3oXN9ftCSRolXoACsCclEAmwYjVM0ubCXUx6JNFOGt0yDl2Jsd5+W10mSJ
bYEKvRKi7koXM/eYJqbhTrtsrHDwRJEY0JVUPh8EOkLLqaIKbnjb6ENEY6qZOamp5PaWsSS30gJM
N6fB8D1AmGKnFbfY+d5TexS55Z92aYcAHNX2XwHsKnm45az1vHeZ0rTEU/oONIaSZfikRni1iDBg
x2GOue6sLiwxTEHaVkTJsOVR4mx0VsfFxavwRg==

`pragma protect key_keyowner="Xilinx", key_keyname="xilinxt_2021_01", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
dSHHpkQiOEzzKs4D71WVyDXLpkKuR9h9h3pBLtnCq2bXiwE/eQHmk5HeQb+qREg0Yv193OukqaQz
RZyuF5GQcqOpqFHMxO62HQ2pdjdpMT5CC7gHvmgiw9qBkJJrXpihIHER4X7OF2iNUfeqxJ8eiSz3
C0V20NlIwKG7Mxg8MVj++xmb32KMUqL7ptikkym20vVdhecVMNvpPoXp8uvaGT7991enWP9HGKUC
9kLY2DEYwRGE71UJJLGWo4n49R50ExFRj91xWnYfvp7uJsMNwnBp5l3GTZiMELX2RkRVSPOHr7l1
n2p5Vq7Uee2drny1IxZ/4c0hYY6y3QWSEqpESw==

`pragma protect key_keyowner="Metrics Technologies Inc.", key_keyname="DSim", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
HUtfqZ9dh5oZTOAt9a0ebo+wQbzg3izFQ0kVqZN81S4cBjQEF53WUiVlTKBDVjvLNUby4Se9WZjj
j86TQzuGJxLPDTohmbytErsg5JrlXHbHGwR4zGNGTbBs12X7PkxtS8wVCp+7b1rX6pOGOPqm6FoG
g6rZY/bTzVfGYF2CAOhjJUqUOXEAKnZRehspRyiBI28/ZZPSAUD/abKprW8PWCxMx2zPWztZz4No
R96jgvHezNzB1Ta8W7uRBFTMp+XVSToxTp2jzSXJZ0V5xJl+gdVjAMmf6+te2vqrK2wDWdMxk3Sf
iyLI4d0s25vCybcY2fZWacq5iO9pSlSaOQWgCA==

`pragma protect key_keyowner="Atrenta", key_keyname="ATR-SG-RSA-1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=384)
`pragma protect key_block
vYYu2Kvhv3RZi0pFbjRTQ/BBwfilCrGpkMls+Dz6HBGTZvSaC/anWgymoDS0XnoSENGG3Pz3EBF0
19OqLbyna95IHFe2bA7f8RgU9SEUffZ8eXGigfOjAWpZCN07Q77RkhGUKal7okWe3Q6xHtZy83l2
kW8ma3kOYL7GzQjtpbP3lINHLMqpGEo0dzbOHiJ5r6W5U6DsILGsoLQOXcw+MwrevvNRB0KkSklj
QnL8K2AK8PIsJGM6F8dj5KwRYhSBYNb1opuVpiJWlbHgADoeM+dhiRxBLmnaDE8PWs1ReY6uMzzH
SvvO6UEyxQtvS/Smm/uogr1eUFedUaBHPMEXnYlTAv/SKrh942GeknsqfrjGkZxWTN2NEnvpRUwT
fS0pyd/Err0s94b0srmcTYyxZfJGRUct2T8MCphZFaScAlhn655pxW9RaHMfcvDJUHpW8Qa+KhRt
9CWYScPIH6YNDByLQbhKL5BTpAYMNYPF2W7vM2ZzDob2NB7m6GGeKRr3

`pragma protect key_keyowner="Cadence Design Systems.", key_keyname="CDS_RSA_KEY_VER_1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
QSNmIeTT4pBji+CTjknWXN6sH9Wff8+t8KF+AC3fIoIw08jtLtShcB9ZGeEKG02RGCO4lNIUf5YB
2TVYk6EJ5XyCav12qDhc60n56UVrnpfo7drorY0NmOypuxECgO43h6SDWp9W7px3r4CJnQ4+X2Mj
943GdP30WfL5kbWHZJC1Dz9cBIqRa1EbNXvvAqBvRPS2+aXBXAPOC4rNVZGeIUspn/33IW3yJLSp
Jm5GIct87ZuSoz8+DXhUvsTj4hq8lgirVhfz1qhHm8SfODcE91FGUPw3vbpGWXsBX73t2zxFC1Hz
/6m4YqQJVxd+H5iGE4kbHxHyHnH7FIerqc8Phw==

`pragma protect key_keyowner="Synplicity", key_keyname="SYNP15_1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
UhfxKxECbuHK/o9ZExa2zP/MIPmFXuDNZwgpiawuBmPeRI1nJsYB7vzbBGMPKny4yIHLT8mHrQRc
fs05atkjIAbLea4+WNoCdCeg7/0PzuodM1ol3it6BHQ6Yzq4mnZbzlk8Xtwmk8ACAbzOr2SYxYWX
ueuUlimUSRusIe4+NiPvzbfHMAOVPjdmSY7zaSyeJuhdAR+fUGeHy5B23Xe2X6cDPeJ75IqcBeul
ox3dTXi3L8r/s1bTKX3FhxRyPZuh/xCWuEajsF2fEYdwWHKtLX6IQniLBJ5ZnVSS8D7IYPsvV4t0
9rWJqto5O1n3rAM44OvKvc9pOYXJupuv7g3gWg==

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-PREC-RSA", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
fmo66vhS7nigYtLDMjdj7hgUnDG/fnO+cIaY/3qHrcwT7u/paj5enLuWHovegu9O9WRq3pPNnjuN
6vZRpuCgz5p4VAV7dVg9fuzg99BAjThp1Q/+HIPfdQ2LM14ZpTh4FXxthHGkTyS5PJArvZ3/UMpW
zwfdYd5+k2/emJ4/nuqoJHQG8k+O5EjSprLTvNZ/wrE1cT/fW/Lu2pxI4msHqVVYAXz7sJ13cQ+C
7tKxCV8vTyf0rpStdE+kZXg+jrc7vFKuPJO0U9axMsC0nXyeYx2jzfAHptGWKvfQaPg/Eo9mgLyN
qSJfFS6aIycuxNmg7L82WK401aWhnUn7GNrudg==

`pragma protect data_method = "AES128-CBC"
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 30704)
`pragma protect data_block
ty02RRAzn1CrFhCtJcW5ED7JpByxdt3kBM4e3JPk5l7a1CDqzauhwwEP6c2b6dxKheRby7tQdCXy
hmwR6I9FObLhZyzMxBYrMYE1RVEgugnJpVy7DDFEDiIE8tc5pXqWFNlbSYjOW0T04QrInV9JK5PT
6wCIu3Mo7RxpsHCHi9Buv9TFA0ORwIMoN+4a/szrFhhvQE9qixK+ZUoo1YUkSqDQjV8qmDZElC7e
L0aeUMOPsV4TMkj+uezTed6lzg8nWtiWfxgcrrSXQ8fbc+BFxySqWsY2xv4riKqepCToiVzm4nVZ
H8LHRtY2PiCfTUzm5WrruBX4M8zjDBOauczUu/pEgMUEM47yzQ0Wt4DR6QCFERQwm2ofr9qdbtCg
bcV4N0dzpysT4/wY8O6tIYBR1+qgBeoVhYzvdXFNpsSJWGGORpK6LPS0l1uNxFynwBdfRyMKmAbx
RBr35tIJYILjLr/97mV7oWdb+KV32ZplZ1LQUZzuwUECB1gQNA+ewExUQDrHMnXnfv/QQyx+Sgr9
tcDiIIfkNlaRuLLavVY+4Jtg62FW1eEZ9/O+aQUKo42eBk5LncAq0Nd7g4hYK5F8TVwvGlBzTJNj
2C4azH9juhZUpZu1wiK40x3Gt9eCeRKlFsVyeFN6z110lNEIy7vKuq8vFTWYrDnvkZDcZxRGJfiD
AE4RrAH+hxasVurzdYZpSVt1oK1kkBkZb5pGzls54yvVHiXuWQYPo1xE7JcaKV3SBRcte1BvGBj/
1YSqC1EffrnUHlOgGsH0efuCAk6CEn4rFA1YbnyXZ5zMbh38s6bh7opo2A2R3xY2HS10esACl9MK
FLIBebK3YguONpLNyvPlRZQZiFSX1+SVD8LsLgygYW3J5YTzRQ4dztURCJvCvD5RoyCmkUD8kwhG
WyJO/1T/AMNCvZ7mK9F4y0ynpPPBbjtK9gaTxLCFcHM8PygG5WGBfMLwEBaJDiflw4/wcjwkDPX3
7ddf0mgvkNVn8zqnWxffbLN6gqrmJ72Sz55OceNhWo0SOASbEI3CkM9nBdUBSK/NTnxFBPorTs5k
to24wU3xET7R3GvRyz95xbUX1pXe65qSEsE/TTWcPKloYpVa39BSjAVK0XDWoPACV+JHSp7iOzZe
HpMaC9jNNptsibmXj3skJ11bj8jbv6eK5oV3NZD+pc9Fzxs/utpUrj1Dvs4nm6lRNIY0Xqgrq2mx
hL35dUOdT2aU7kBN2N6BcpHNi/BarZevl6KwnYU2JWrl1Dkar9RvVgTtzYHr7HD6bYtwqk0FKHgr
DBnLVLIfgNcAtH2bycBQSlSPrm3Jkgj31GX71PH0GKLhLr0hCbqVldrFYdnmdkbicBPN43wN0jvx
y7G1c/aJDQF3d61gvaqxUL+Jj9+J4tjCiGaFqAaaQi58XlCUZNlSenC3625uAMva1cNYUDUHZTRb
/pTjkyX+CwbjK/EbWFiRBZS/313p6r55XrXQTVmgCTQaTV4bFPwwpGzDnwNRXtbLTGS/3Uh7q55y
DB20qhpAX7cIc9h8VtBE/lz17fpZeoQkHHdu/Th9K1petho8t3/3JAbqa9Br7rrh+YYsuD+cobmi
1jFO0KAks+j22L49SFiWIkz9NGf9uJM1kw9RAdiTgOcVEa+rO6Wkj6Yrvzt0CFjlZAZfzPpV3Env
uWaBzdoRh0kQkrhCjWhHCRCxK7kmq6+27hUs/7RroAemvoopNPFLxEtLZYWghpfhk41J6ZgSCNrR
myfUR17K+8LrFsX1jDkChL3Bm9VlEyIR/L06P+SoEPoupTG7E8iJiQwFxcfmJm+sEaANLLTNnIu4
PhKau5T5/dqUwh32zpBWWDz3JJIlGfSSBk4cos0/sY0uw7rysUl2lWwGEzaKJ+JTVX0CxuejliN3
YXho0Bqsh7fZhTrWU9PglemLdDkA9eQthpDMcqdPGzxkHpnJSOcfo9SixcNB36naCuV/8JwOu4Gt
TXzu/QLkI3cSK/cFESthNY7H9vMbYk4ULD+lMBS2OAmdczMmmbI+YdLNwb6QkOVQRYtQw0dIjfJ+
8wN6Ay179WzuxrViR/I4xAqe+PPYffKrYHIjoLHTMT6egzEUVVsYXwE0Ex1TKsBA9wvz9Sv8Rpi7
V/APqYQkdX4Owg/h8qEfCFVsbAQY9Jw2xwApvCFEYKVkplrGTuVktm68jvFbLqGxxZkYAV5HdJhz
1xJpcFsHDXDiOeGspZgB+Pbo2dHkHGQhIVH2Nkzp4rwZW54dxvh5mchIuhirfq0AiorMkmhiNJPI
gYZqlzQHOlfIO62xhQAWJE8Kfy53IHdsZD+9W+t0OidppCGA+401IQY6/TSYD/ImVyjr08wK5MAW
z9wWK09nkrqs4S/e7ByWuhs2Gpt4pHHFkaMefRBcFrKAcnnnD7dqFEt+vGdJRq4P9+48ZeylU9Q2
b+EyBb5P6L3kZJpr+cxsFinpmN7P06fjQZ+KKCrqtuv2hFNyUfzfVq0Is5Zni06Dax8aUzprvmh6
WQJDuTEUelPAWOeXVoBJASuG33nHHXRQ7JgUlS4IiHsjvDK4TSCxZIJ8f2Ld12HizIEifiFZTtb6
gbEWnDgRFAIulBYHequiMNKEIMgiffBd3oax8P29fgh7cfWftO4/jkdrIPFY/oIbyQUihetCXIbq
GnejgURirzfB5rdrCzzAD2Ob1mUTegn57z60giAzI/qJ15xD5A2bxTVrprezJXG+Ntm4goPeHuOG
PsJh1b7+XIn5HSaOk7gHXI6PBVYu1ki/0vpZiG7UKQR+Ov8zuaAZTE8MMi9BoNKMU9Usyajpb22i
ncaDblGUq7AIAmqKLgozlH1iqA3VEpbzPP2qGFKex0blNZJ93mf/UaJSRYl4HQ+32WHhsEKb8mQB
Oc3q47wzbvqFARvE/YNkus04w7btSq25D+T+LFvX7g8E+T6LnEL7aYIyzwKkYj35Hdj18QTTio+b
prSVnUPkQnkRUrg/HyuSJN+lpDBAS0peQuf2Avg/aqKpL1KRUdrYV4uh0hg438qvEl7k07tml5Hm
5dlwMl8/VpGF7BbA3Mf+lBBuI7/Kv0FzfjAIbLwQMT/4HqdX2MBh3qJLRy/mSMRJxjRgaLTsj32i
XyWllIHKKE43kj7FzqhmctcOQBP87pyl6IYONQ8YfqUDnwOFwONXZDzn9h2AqEQGgZZejMCAN5CL
zDjnoDcv5OEhcoWsELkRlYGyma8c7mcIjsy/S8coVemfCrj2oSB5BOnXrdfckNjEOBhqsKwfgX4l
haS6/SJJDWEMEZAcClzZ95NA8dgtuHE2s+43jAl6tYiXM+s80Y45T8pOc0ZImqJKmdMrVeQmux4J
jI1oYtopWVR3HSh6EBarP6oAGNnv/RHR6vj1s4X+DAAoAJ3hNSyt7KNwLosn0vSUM+QXXQVZnsDN
xyLdACHlFyszazHUmtFj8eff4cTUmIM9qerDWO+Er3rvUi/HwPL9izE8uoC87WYoodVV43ZljY/T
2If7x71ojL4DxsMwCXvM1HRXpm2yeIcDt4fABPIMLFRdbHT/IxBOXFEO/6BDbKm6KXOIKGb0jizW
1oI1UDvSbXUuW4yQA05qXga/0ILNZhDRthKXcbUVH/7ITMIPDil4c2QMm/IJFSQYxt//UHpSI6o+
Tu41TsQ7+s5h56iC8RtsAvtQ8wV8lF4AqwQDLTW8hGykqefXQ1Yz4uI1UZwdcZBxo7O1emPcRw43
9S9OB2SpzstX9dDfq++a/ODplSh5F3vIa3tMowcXpnLBRbBkyPF9VBa3Awu21fmbVQabJCKDWjcs
dq37Z7TAF/wXNYSiytw882VbFRe6Od0v8JoHFJ4JVUmO38GI0ZAfIur5y0mMa36xoklyKA2g+6dt
8uzA1tcMGJxqNyQ0tpcic/yG8Kn35CsalBckTCQ1dyhTQPysx6ReU5TOTNd4RYyq9B+CEwFE+1xG
djQe+5HHA8ggVikFjmgM+i6IT+DKksE/g5dnEsr/ySmI/HY6rTFIqkWAM98soLHr1WAlYrajfATY
GyxP6i9XGfTzpqduUMqhYIMoSpUrJ3mIGx1WSCknwLpdg2mubw3QiY2xPigebGL9DDczRDZVzXuP
V5drpGnaSa/Q06hzU5xE6R8/ww3x0WuDdfgN9LJE4VAIJElQbXP/Mk193Wm08bxNb9BN2VMAyvHf
CMECZelO/smYf512TcVDErV9KVWza9onlxrcc6O69YzTemgRPrX+gpS6+B3tLIw0QwKsplPbLqXv
g90r5qsiUXleIOGqHhJSknXuJfIxp0MV3SbxMxWIKwZAoa0eX8a7JovNK+ODiGIWUQK2ZWvWz8eO
aFucckiFsx8QozNJiitUkMqyp3uR6EdpvPoEofZm8Ni63Xm4s9vRXXyS6I5WQfty2l0YZTuRL64Y
D0Ue2LKpShFZIvP1YozJUkpcodsIOrQAyKVn+wAwG63WqoHx0e0btxs+ER7q4JBEuIVjz65Iv2q3
8eVK3GRibspKWB5dArGmYClMnhOI3AK8SV0LVrEpF43GgZeH0QF8Y+RM4j8GURc/11Lmhnea2nud
MqZU35Ij9yV+aNlXyTrRBYDDbKVxHKu2OtVgCpv/j/4kVwmv5QD26GS1gPd0iBkaQ02pZAgKAczF
7tO91L+6WK3bxh9fFUTsVGbLiYZmJFziopreUl3NqyEDNqPHEnl5beLCu3Zokisw9WuOKEsxmrj2
w/h6c5bL/Nt6t0RGYtQBL0Q489t6f/yd3oJOKmGqYkPUjGmuF6bY8QOlKquLtRE945u53iVrIW00
5axlM+rvRGSK06Lne2IPKJNdDYEYkvO9IEH75uHP/CYV4ZnDYg1DRUMQhz80Gbz1EiROEXYvhjl4
CDDLk+lkty1kBNEIaN3OSSIH/riaVKR8W4b7+u08X1caWTL5r7oXb1bcGshl2ppENIdJC/MFDSfn
m85X3lGMhXY0MjzvGdgCdlqupBF+iajXXr4Bv5/I67u1gA7Nw4zd8PLi54qoTl5bvB6YlAOFwooF
2VXhbK310WMsQsNnSdKkDIxyiyKk7nPqIqBA47hIs+bh+u0QkwNstUaR74ErbFjyfolb1wcke6mx
WLEV5TkxSIISFMxeyTHYpf3PjJCHYmOr6SChtMZIPpdF1peDk+Fpyb1+oX96Fyp24d1030MLEtEV
7tWcwz39gZDOn+zV/z3YtN8Gm45hGVUJ5rS05j7o/MrmQgLwVd3ybr4dmlEQWjVXEIcfhsjEgo2M
fOW+QAil2Hdsvdh7e22SEPlr5M99wkFunYqO58dFlD9LaxCCrt3fkSM1/D/W8RxXR5qYoziOWfMA
f86UhdpdmBwKjlLuBbQ9lH2BePELnYmXfoN3h1DMQKNOvUOdN/Oa07NDSOUk9rC1zVQa+uLyOADD
FhVnGTuW1ZQ0euCWDXNTxBBsQze0VzHd7pXxpGxb6uq7L9AlElJsq9DehCpsujBaW6okq9NWLe26
EYrys5rZb3/w7TkurDwvEkgV+NfBQ+MmFAiCMZ4wgdRuGMqwf9eLFOOUhCa5BYbH6UpHMJfJcPX3
OVTtyUfSunFurWuCEYcPIHi16z/DaGmPneiqLaGudZ2FIUMhU1daEeZuTwtpDGL4ws5gW/4Ukoz3
OFRsWLXluczuX9n41NV8qWtFaR8MLMdnLM+N7O0CriXDnKV7zBlurRUY9+D1cw0hwHICE0/ohnpP
i5EFjK30Jr9hVyaVzLBoQwR2VUsoleq5LA13CzHHVv2nE8BdO/5/pf5JgALbhRRdR19LSpDanjee
MtOkEDyWPbDaYs5AJPUV0BCdsvRPtTO+ZB1DZxpL3ShkCg6w38K7+lhIhII41MWeV1paQguYzMDf
plmXTpcKDEdTITmV8FC/y+ZkZxClwOZg+Dh4Zb9kBa/2rhfKVy6maz0GgR5OoD/mpb7CMR9LaI22
H899NcZkAmvCHZ6fiZBJcAJtcyIx+pldLOjBX5GOHmm12+5Meoc1AmUkJIRnCPRkRqAQ84ckwibp
I8lfJ5N5TnQgXIImSvtKHO8pzo/wiWOvNKX4qEleoNheoLbI5tdRLsnBiO7INjXT+Due4Zxzm1gI
OM+h+Z4H5dGFiEypIb8Utz+WbHNkqvLwXSgejR6ZDarDiLqhw/6N+1T7Ghzu6Z/aWLdgpEEW96Z7
E2fspkOennA9Z/aEALbdZR1gq+62DcMiz5smmOHCvnLm3a/9KQTnpJD5EP+rNKbTVchgudUzUbh2
t9x3IH3xWjYtooBRUYKcDqf3H5Nd2pcoOc0PjDOw/ErSuGJQSRXntbAH1j8+zebzinEfHAbB7ncC
9dvWZbfBqBO5CbPt1zGlAcJlU35y/aQHGHf3A0goL6iehUegq5AvUoKhXBT+ApCJbGqX5Gk+ae47
JedazBeiFxnW0siKxU33dhbokLXDKohPTDMCxZRUPl21FbXYi+fL3utX+7R7JqPOq2q3daynwlr1
apLSTV9oDNYjt87+tXV+Tct8ZoYhgsQ2akc4tEAUhmfeE8Go6IhKP3soW8koqhB08EvKe7bXna++
heicAi6cDTKZkO2fuXDNQoF8X3sgqTuFiXX6Rn+fT5SEykpHjJk68K5RZ2UpiwNuEnsCBYOm5ITo
MaH84CBu6ZMzUG0FsFE9n1iLfpOyMQWOBqLMjbKFtG2P9oWJKTu84br7dLY0Rcgd7kCZ4yg06nu/
JJ/IvSKI9pL2H/zStzR63JhpnQA3O7TtPeNEbZRChhR11Bw+/KwrE2vZZaDwrPGkodgIu7jfYesU
fWtGqCG+QELON2WmCNnT4CUe5kfOgzenALKGNNdIX+kZ45u84FBp9CWTIZ37Iia7paa0WnxTV6kR
LCNb8qIPGL7ZdNJnNNJiAWE1J1xPSMELC1QzfgZuaBA+tvVqldv6vS6/2fpt1+pOqMh1vxgu51eK
6jE/awfFDEn9JUF/K+PPVWJgZ7CFr5D+mWzhV2Kyh8uoXUeOj75RFPXQF4RmK6lHsM/R3azg3Tfp
P4fF9OdHTEHrkOdALOK9JxPIVQRq9QgbwccUak9kqUUu69Wvmiqxuwo31NerNhsyqvAWQpUyuUf7
glsf3M0G4Nn99m8/PV7NbFEtkh8peM0quhe4h5ZuVx1N6VU2wVAAOYByTMKC92uRyEAT1HPRMNiW
I4pDfdB8iW1UUy+705uWGg60ZQXzPaXP0VvX8L1d27h030Q8ZqGosHOsejREWF51EhmqUwpeoX/Q
4JFnnS8gAhllC3QFSwPVb/vX3C+e+Bnj43nKXulZTnEQGbvrMmfDIfhovYZWHxGlh0XfN2lZy/B8
9u8Dvu4fDE80yi+DIC0XvCgt6JxTf1l7C/60YlvHHBwvpH3l4fFhOeF9zGeLwZ5Cs4YCpys44c8h
LmEMoblkcfXzShCWx3717uO8F+ZEOGz+uV1DzUkB3ZfHAnU4SzL0m48AouhDYKMQsALtmwMKw3GK
1AJamv1IMYFpwdrANJhZLF3bWgFdA+YdVa4j4RFGpdwHUE8cJ/DuHCKfyBv94RUoMVMx/9VQ7EP3
/hPpUKG1ZAXBJ6WGdpDscuP67M/rDmADGWUnmlErfw6NtfcC0xtR3uecort2f3OpJ6HEQzA7xjQm
4KmF5ARaMsksAAi7QOvV0gLUi3y8beYjWGJ8zX8Z/TcBOnQVjeTeb9sxKgr4LUVLUFpVAiEQmXn9
O1MIVTF2pQB5PPUL/e5o5v5o+ekior3uZv6AcpRWEX3a16fvLRcH9PiX5oi08IjAp6/VTMaUrs93
Th2HD+3k+zpom2TCisDSreoMvADGSzmq6UaI61ueGnm1P7a37F//bLwX7J2Viz3DGud/x0G05ljL
267Qhn9TCA3qksuaAu+w+Xb+zvZfOTtaIaNJEtuW2HlqazbbIgBFdHEMbw4I1elyeuBGMH2SXKFp
tXfYtBJhTSz/N+o8lvjOkeKuvnzX9S71cAYv4UPitzPNj97Ri2EjhLyZA3pPE4cIar5Tf8FjlAZV
77QiJ+Dxx1tQf9RWFdjIYzueIOTLjb4LLf3xXUHNY1T9nsnOaMlJiKEVTOFkpqY0eKe7tJCnSvlC
jThK+cGdBTL7XZTkVgqmT+Ad/5UdV0JyEEpTPPr0ayFSUBZQ+Ls8V4btRCxiDKKb3+dFdvswDTAj
N1kcSU3+SxuSfTYyU8S8NnAq1KXPENaBFWVKuAZNblnna85ZOOPQYlqSZ32/BMFnLGeSiVNb6YyJ
mP4P1cMl235aqf3Utls3/mUjWuLHYUeRSyR+Epn0piDEZTEOTn2yQ2oYsejkv6r5X8C6wQGGb//o
HTgtRVILXpVoqD7SGvohiYG1A5N28QpqS1usjsDSi+3zKDkMeEKJNDmXbs+V9wmJNaptkFgU8LOK
3QCMNL2OnW42jXIPGrpy9Z78dFUzYQO9qprXelQ8MdzYllWQG1TLNXPHtJumba9TSi1CBrjKtsih
61Jt+K7A2vdMDk/0jpUPc9I6ma5fmaKqIHMdbQZkirCVdCcRpUt6Q88dRwxSPRJ0NTSP4Efh9H1v
Ufzz8D0ErffvHX8G60d9X4YYNaBZPLaUjn3665cL1bCY9QRss/m1/5BTAoXJ/B19+jescwD8xwhb
ELg6QXVH8IyWg+hqyyI5VrqVtIitrVMBq4BRdRAWQkpMecrxYipb+vdvz4kDt0dn7jU9YHb3T9u6
YQBytuH+fsVXDBFME6I6IE92m9YV3pP1+FuIjmFobBBjudilPxUuXCBX9wjxAMPDRe5RXjVnEd/t
TatjoZpQrBB90y+Lfzj5bwP1d6wwW5taoe+ZQiAgEWrvMUXlbheXLbWyHh65bQr5YFW+MLXE3x1K
PdleceD+ivfDuQefUQHNdQVL9barFJQ6O7RM7hhGU1wC06Vu6/qSIGm5mjKh2AwU3HRQRDC659QM
E1so/bX4zTB3R+ykw6l++oBqr+DzJ6JAn/hVfWcmrRgqB0llsaGN/vQCSI+hZvMbpAlWyucJMt2Z
EGbYeCUV8P9kicKK75CcvLEbc+HXxPlGIjK1EemJ+AP5bgE3ZHF0rjmpFLzalol4QqLZLbrAjJ+u
BPqtSWLequRVdRH3q4HwsvJytsukJl+97yMOh6q9xcQHi2h3C6phzcbm3nzz0FxViCnfow8Mr8bE
Qnhiddz7GPx1HpBM9s/wCwCqMWCxP2d5uuPWayGcigwBu7/kEu65cNhDZmx0zl5O/R6FWADBAUEU
suku0elMjaxBcp91ts5sQW3EGUcPztYNaPmEQ8YjApFlsYlPFRUTjkFvgqfB0wuiOSpz1bUXY5BS
UTc8PW3OHSxew1KzM+7yaQwz2iGyT+tkvht773lvbI6+7m1TOyM+pTGDuP2xE0DMYJkpMM13UoEv
CzlHdu+iTANUatE+UUrxSc3bm+NEKdgwBetk7jCkBxvisOXetgzV4jp6hHScHiyz4VwauDUMu/SF
qFoy5L4ehrgKkhJXhMaiIthqPEh9wL36NqS24tz4EfvMTct6OKtRYiLTAjRCbjSLnNsZG8Js33ua
bLg3a9ARVGj9+pagZ+HpuG6XAfB0nogwCuWlTv+hlQT9FrXZtmCyqcNJYBK8lz2r8S/5xDLwqE0d
biPclLKpdsuESYkxWCOwec39eaDSM4wJMUFyZQkUoLkRNBWPsovLvZGOqQhOopKj3fostuZGsdIp
H4/trDObxdm5hPjlq3RFWgcVAaoR0WmXoGU+UeGxEWfzHq2oilV7JAK/lSJbIrKYF20hQEHDaQ3c
AB9JTM3rJH25/Z52XVUKetUAbHQa6KXpmyXHezGfhA7+FpFQ+fC5PCSEOrefyptPUGIBrGMoft0c
nlYWSVsglLUKaPaKzrMxCNyX/MDc6u8cU0mSZ9Y5oLpqnksGarGPCMdfkE9pyV4y13wNBq/UFHbT
1YvybkaDvENCiWX9dCvarXoYrrUvQ5wzn9OEJlgRlLP9hCZe72a3n+REnY9878RN65JQy7dDin1A
xk1bOEiywRbnzYQ+F+bAs369Sl6DS6/tSDsp164C7+d43iM4buMSerw0d0DiawmTEZUivhLYqm7/
5eVegwFYn7xPAo8nR0zA4KzeLq8tKKGlCVT+z/hEcjUSg5S7gM3VJ8oVZQGCBN74oUPg5LNWa7Vm
N7F1Wm0Wps60TCiNLYwV8Egk2QGYVOuexcApdBLscJkh6/G64IO2GNSo2a2d8sjYD8QGoG0Ej7vP
HnRpukd620Fk5qPEUuY//kaYyxDkojW5lNmYATgQw6PC82Ll+IPtw0t0zNaXX+hFlPigaD+qvBq0
3dYDQoZHiYraTuWadFxgqG9LiVddEM/dJ1JMkVeaMQA0mpaPyWPcmFLNiJEhFioTozQKuVYNLP4x
aE0uPlc8G2vxR7bS9YmfEwLfrUg7LHvboKzHVoOmXR2qIOSA727xN5bGkiiWwQWEZJQYUs/5x4qK
+TNJmdz+ktdbICpojPowBT8N2UFrIU2tpVBqnKTRFzgGeq1G0mqQMyrctRW0IDLOuSSTx2bSoxit
m/kXUpP2nDpyaDC2C0ZGCfY6zYBDc9vNNDycP2QAvSBhaCG+kIS1H2eZHrRH2Hsf1N9KnSpixpcL
6s3Z8QNwU6cDCm2BZTlsgtY/gZGVml8/tzNUy7lUWFYDSBGRLCXEtn7TU/In/rJaf8bloNssfx7H
0XJScTHytQjPpz/xo8tP6fQAsHOLcy/CVR39RHaomjhDfThh50+2J+VPBxu7JwnCBPHUNylDXe5+
85//dAxGygN2ytne+aGFb5Ur5NCzV4zKvQgdG1OGv7IxYINtBuYNpX47tL53mt9HdkyttIUVdZU+
ulkZwgiEcyQN9WqMq/7PIexzvRPxh7FQQ7kR3QcHpQy56RiiRDCy51XrajGIzQNG0oNyLYlmcp7U
Q6qEwfRbE8aCZuNdYsNzlx5XDZSK6NSPl+YynoMlPvHFGkDa1a8WmLZ4FTwEjVH6Yhrv47xWPksh
IeQnGZ4H7eXrfNVnspwKEuzP9YENTEljU++Rq6CVhNGxFuXMuZJolgM3QgPFczGEcn9FTthxsGVR
r0ONtz7ZWFN7FV2oCDT+W/txsdv8WYw5rEqcMAXtzyn4LFuBZYJatV5zOXTazMDLLLy+mKhcWcAi
lZYjUZs25c4BHv2wMQCWqqqMKuYXVAL9xpjNYG26/1QhRrEmNOhLNdWYV7VwfvnVJa+FeFI+Dy3s
h/LSQDmWKW8SA3LqtyNxdDylHWhr0ShH1Rn1n10+PURjVaBqVuF7vw9tXlSBrszHR6FvEia0RuEB
XQYBK3NvzstIluL9JMs8hfG/iogX4/JW1wsplr8C8xdfsI4BkBbUzi2PoXlysoQAL6PyJX0+HG/D
6FRdbVkkbFYsMQ4JEtZ2O9VN6dPfNozXl8O244zLUgCRd8EdBObG5uYCej6SgSMhmPgdMHCbr5tv
HXGqmrQpwt9lRrXijNA+iBBcaK6rXf2xEKB18QPyWHQejWMvSScZywPB8Q/PsEusA42S6RBSRo6w
P3kYqlGhChmlAONqk4R2LsOGm/WhLaG79kl7EP5K6We4HFgCSIfNgJ+XeKxlREbh9BRjupF6Ab5n
+A/FYOTjAgiHAPPcdHpS4CJ2wbz7cZq1LOuaq7lILJ60elZNfj6UurPaYf9G/RRcwfbGMUkAHxPv
Uq/rxwomFdrgrG9MIiziljKd14xxzJ7D3mMWdtR7lK5kRzmX7pDDu8ge/lJ/b/u7W5vijsx9C/tI
yU6tDSwh/9Y2m6PfNACWDlLiw8/jrYYULrQcW+Kv6k+EksoM5hGiOvqIAA8D4k6f+htNWQEEvq2C
qOOi8HxCYPPSU18Q9tlY7hOVABhh8HWgGtlzRyzJV+lGtWVsFDTzUniz77jS1oyXEVHMpM/h/tr0
eBRrmpovo9ZOKSOklljilqAq7bBC0wYOyR4UZ7diFJK/77NXD19iZ1hgWEd//l8YSGe0/vsueUFJ
dmebswlrBwlywg5zS00WXhCo5XLLSLCykByCF9QwutrClhFsq6Aj89kkMxCP4dgmj+faQx8Xfnm3
Yt0j2SiwkpMlBnv99g45rvmoafIUqeiTsA0ntnM0q8dXjHz7QmyutbfIJPGWw9g6U7//gFFFPMYu
90YVQ0rRn/Q2dcuGdb0ISpMLr5DcmBp5QZJ3bgvrdG2AYK60Qei4xj16ZauQGwRQBB4cagV6cvwq
MHHS5aKT1uXPN+ih+Pm986k/jo7wgri1zen0Ub0Vfs3Ycu/EU0ZNIRnaghIDnSnWwVg+vQU2abuv
X0tvOvREPwSeiuCmTNUMLbBiZN6/DOxAKn5tdcjeC1xP2A+6lcBqd71YCG3I3D5sL9f2NUeSWTZt
Pr7oN4R+RpRrwBmjF2+SWFQfudxbJvuxgUsLPmQmKLAa+rzAQ/NV7mf8GVkAoZi8SIKQAw105X5Z
COw+vkJsttgxMUHRIdW+SVM/J1fdI66WC18GVQuPczVCa3DNFLRpetcbrodhYLsRCh7PDvcg5Kp9
2ppZgfvndRr4oAgyTzXR20WCo6TsG6n70muxP1eENrwNHI72S6igqvdFc/4xz/XHsIZNtpbsRMoy
jw3u4RTmh5HjFdx9nm7v5wsfXCdQWa9yNOFcbVHyZ4EgXdQWXihH9Mhu9Ro0W+WErSFE1IWGrQfR
mS27rJRCQiG/OdisXyyeI6HGXhcGQwCIz/krI+NvqC+s92praZydpj7v5qG9XJOSbITPd2a+wU/E
4iety0VO1phA8DCOzlIKlsNdVHbYdWthslZtYz4xKItZ4K694gulO833Vpno8jOyfh1voKDKOsGD
bLIOCgzpH5qzwT1vYzebICmoQKcCB/r70R8h2802pVqeeWl4TosNxTEFB6CyvWX25a99ggLool1g
p6ZH4am+nPdT+UsZwfEXabJOzLONUYTslv5AE8cSZCe823lsAs1UzBjFoUqd/lwFB7cKfME7h2F2
abmIeMXSpTr3QE8NVOY3R1WXCk9GehKYQ/U21oxkuwIbqikxCQc9kqr5sn4EONxvduciaGx70EUm
eCPd7EZ4kpKDWrH2sGCoTbTC7O/bML/ZVzGURYdRCWk9W05lIgi5wGVxfeXTqt2dNKDQ5H2CDrMJ
O3TNOXfkZGErzRnY7lw/9xUFQ/ezNxcMKsa7yb7M2T6zE7E0ehBIFnFFhi7bceVJ4wI1az3KT2JK
DwRpAE8IuNiywwVuVxNXpahKikDSedY1OOVqyQM27sfEa7FrmAJBXbhtk4/oflz9n+//BegBGiBl
lx69Rb5ZYY6MH5Q2T3XTBh0sc5fJTaLOGJCovTScfCU4/R6y99CSegFl3aj9TUU8+G/FHCuHLREl
8hC20XdJGSd7NNZ3U/vjjAh7dNhEusB7tqEFKwVB/GdHjsuMu27DJ7uq16hCV1mCxz5Z061T6gns
ziapr4wPkih+pXrpuSJLcN45ecz7lG3W6aaGeIdhIqj3TOGEmENmCjwXjlUSoxpGYNS/kYdTpxyz
N9INGm38Tp9PGumc/LxJzC6uXHTF7/nA3RoDq1HKdDTu3ZExHMEWUOfkX62xUNcGOrOdA/Afjp0u
06F7dYSy1wRZ7d+GOpXc01QgKsw/OnmUMvFzEspjDFOY/1TEUYhSIv251dAVxcodXx0lyLIly+UX
MbONPcy2lUOj65HCWJtcq2XUqa3g/9r82mxNqn0Ldl2JuISMPuUQmSjWYrkVTaDG3rTy9hqvM+b5
CV4ZQ04Pzj74EPu2o/HTTc0F1LtXcJaBxnqueMOPnBHV+vYd8hPwUgyYSs3yqw3x0ksFhaZh22bH
GStyZMhp5C75iYWVZO1gw2FoovLzacODHbrIF2qwE+Ca3QNUdB4XpHRbY8InUvbM5tgzDapAQspI
ydYAWhG9Ga6yWgTmw9GHMUrRekD0mDXVaHWAADAlaVAtSXTqSixYk9sg92L6awXGH1+jlXyfazRt
QIzWiMZNq2VE+M7tZOo7CqOQwsF2m5d50Nkk6xC55j38R9qYAoZXoBootx0bLhbAHpwN5x764Nt3
9gR4Ve6cNn5ricekhzq4qhjCOJwkdHeGvujlwvSa/9+Pi7AX+m5oEMlFA2egFGjqCsVycwNvuaRB
QrddzHQEdhPn8S44psJu31HnD1ET3kTWDZNAwVOPE03tkjENrSnoQq7KJ6OQlr2/PC5GIXO1hb7r
CnHVt0eLpr3TOFhf1x8KDP7T7gF341EZahYCVuLxDx5GjxfPO8Kh5dboOFaQ6M0hZeAJjjmTuBcK
k+oOt/To8Bi8qxnajFYWzRR4CLgx/bm5ACgrc2s5tu2Vm13mr8t6bKkDYCT2H0dR8HV7NkpF4uvN
XnYuqjqoFyxxgp/Vm+kLLx41QD/7eAau3wrLI2/4m1jny8zG/vItDQiCdQiMTuH+fgd1lr0EBJZJ
C1BLDbC5z3qetJAvqLNP9ANoTSviu855ZZmJJogtkZbMzpFe0AXLFk2XmRg9e/a8/NulFcmNh9p2
3ZwJX4s6FUTxgteqWkV8IDC3RkEZ4y4sGZqqLQHthIaXadNprmMR/ei5LfSOHPMBDSHsiuwz8une
FLwG1qUzgGKr5c6HyPQZhBGv3nWKBHbW6vGrFJUAt9e/xXPt8prC7+3TWadGkAwlCRuBuN7jf3wm
F7ehfulPLpcpxYdOKSVYBuB2xwDboUjXUDZgYClpTL6GQViOCOCjW5F/7HEEXdrbcoXdlZbA51Wn
gey6cWpILEOCa0yD9n3T1XLpLW9NX1KPyGcuLN6kNiYD0PeBtsUTtDC+078PgXJx0tuJcmPt2+vI
shkEChTi28rSEXszzXR1OGHHxk4fPWQRsAB6cZk5ns7eurO3TIG/cHEoIF1yRg10YycuDwjuM1nV
IQ5XZIkIuDTf+4th7f37RxTUHMMEXdsQmG7wmp6vGJ+cwAmirvoGd55L4/TIoxVa/Uvl/YpCQ80d
eHqdfot4KnPctdTMLW9wiirRTXCoGeLe+JOeVrqn/1bEOWf9NrkXYDUtA9SdzGxwxKx+irKWh/QQ
11zOTuW1dUFOgaHFSLXOjmJ3MDxSH4teYKeDVLmKpzpbB0xLGtDU9mu4LfhyQB8C1Zg/+jwGeDvA
P9hFWB0fKPCEvVP5vpMnPHKVpkBpH4drVWbOi+vNNZZxM1HOgwlg5uPhtsJFyNAmy1cHpgQNHSpd
F485DfOvsr4OGP0I1nWR59uHywt7vc+ElcYK5Od7ZC9bOsfJZ+yRMJxWl/aXTYNnv0LZHzF4iMBM
ZtZmthBZkzSJDCq45oaE0XnEa6uln5lGt7FnVVVSFVuioD8I0e189Kj7HD2WjukZP56blkro7Uk7
wJbc7+DcgMde5GFb9dzRh70BEHmAq9m6dDICdgDmoI80yKV3DbmX3g5LAjFI19xtcKi6XqIOrfvj
E7VEMBYAbbtb/2ilUcgBYFhFDyHBKitiOIMHAfhXrGVS22FIKAt1RstFJleofyNT+lAt5aQsMBlF
HOsiNX7cjOsRYic4eDfSNQjptggFmpglVh8ZXYSgn6kwmEJImtp5wMoHRK3sYQRvd/DVHriVno3B
5cA532ab7v+ZoRL08e7Cvq4bnh0q4Uv5Dq/46TkEc4Ey4AZPn5gCNYyTJrgHUElr3YdGls4K6RGK
rSW4bC+m6l0BxzrmnQGtmW1N01Uy9WcAAIDIF4M7miWYo+q2EamYwmOMw1VOMTS0SRjKu6Rb3ayW
5MIwmOBL3199ROJSeIw/MQHQTJrCK/kQ9lHOa8Lu3A+p+Ub0WYA7j9dwthpC1U9u5XvQnA84oCvL
gCpmrrAWswef6zppKHzXLCVcO9ZlS9i8TB6P9qy3cR2WUpfHa81fOUiam00c4hs8ewSoHPchViEi
UdRU3hZoRTk1dDS+Q2rGk5ZZmiZbxKxs+vRS0ZswELcpwIN3PmGLFSYEP5yJoQUXY3cOz4Jwr0d+
0wAtkBQPzgmLz/WaTiYhAcI71H37HOu9nrVgsEt21usJHng4CZPDkud7VnAO2c0tch5Auid/rGJz
59WmM1mkdg3bsz0bjNDLrwM9w1FUvTG+AecamPT0j8rh8DVqPiq559JKXTP8Jd6EHaYWz8hfr9Vw
dTS+/C9ouLZZ0RCPHlqQd25f87sqwoom9mqpClLan8vlmILw9QdXcgD+Qe8lkIqmJpX2uTxCovhT
H/QixomvfSDC6qMl/LOXBLkAhVFusLvbm3PFJOqbps5ot/2aQdzDz1Kysp83UPAn6r23vQAOxprk
6EsghrlEL9G8+zqvvAgUSd3Q6N0ZEE0h5HHGfHyJIwdygCzA/Nw3vqXMCQzF++la3Dix3GWMO1Tp
Oj29XkXVFWs2fMl0mzZUxxP2h1FPbUZUQaSFvHatd6zAMGMrU2pvPfwHpptrBcMlCvQzxtDX9so+
7LGQaxA6tSylIgJgYK0Z4U1IHcfY2o7FO8XyQhZtCSQYtiNAWKb8hUGqfvj9IBbkIYNRvKn5R3nS
nlRpHKr+siyMnCWDS6y8MgaJ4ObR9/gMr9WsasiGJPF6NL09DXge9LwxcHzPSANS5XPxIUfkO1zO
+ZpTOjIh566A43xQJOkS3TqJa1SeWYXjqGauT+58ibRgUh8sdjCx/qQYPE6kJTwQKgA36M0DSWEZ
HGPOkq/Qv2JWVTULYXIM3cRaOz42B3f+fLzNo0g2iSiJrR2zYdo7hpmrNKzA0Xf4CbDpDTrYOp2V
82jQpRklR9UC4JLlwddvZtr11x0oz7rQjNpnQc17GhWEZfg9Ri1pJNbyHN1HMkOBtgRsY2WElTOw
cbiu4DnRSxkBnqn9qcGo4l9IXXEacozRDmApulEfpQ56S1RbAXnUE00CqUceCUvd9cAe/t5JZnaJ
H7BRfcYPZD4lB9VY5YygfJJURZKLh+x/Z5WLDtOyHsgYdk4EwA7Z2KveVxMl02t/pViPULJIAojW
XdVUSaAx1V7QJnPSX9p0tPxC5qvY5tOJcK4TInBvSEifZV0FX63NPnGLNAIVr4sjHAz2XK42gp/P
8tXvvjkm+qK00q3YnH853ETZjOQA2RmTM9pOB0AWVaTtG8rfz+dwBaJ4JKwo7PnfClOXkzC8ImgO
TnEbnWE7j7fEECFBJRCkqVFaBoVDyGPdACzbmsyP/QevjrjhDB5LhU/GgnR71wsuCLst8F60FCcN
e2zeIQaEXxmRHh0qbru3KIM1Nfq2O7+zchcTEZnOt/OUWaO6dl7JpWaFmNAUnAhefgR1BvaG6u3h
qM8+xqOhY5WXAXlrViyYhtbhXhhiTX3PQHWfaeFiB32Ny9GfzrDdIFDVV03K2Ny+ui96qKYEmbEy
FRPbRW+C4VRJiKtGUTzEE98LV/fh9DY4gi/bucb3GLOKCSiklUkh/mcRadrEWNua3M16EgX4U/6D
ML8/uZdOnVJJNUCCMOojCMEvGaGOYNTjugzgL07ISf6KHKtIb96Yl/zmYF80DgaiOUVxkxZtJTTv
4uU8ZlbT73lRQBvdLJhZv4vZCEdX4mxtqpa/bS0rcIMa/PBs5SobJ3tydN+oyBQPhyCvXrpcLWr6
crn9PxdXP22kn3R7i7va7l4oAVk6sZnCGQQu06tHEIChkPnS4kqlDSSu4k7QIO2M5hG1mJecLwW6
MJjf7Ckuk93S9IQSdjCbtRPl1egetP5GpqwBxl33BWLLs0jHiMMkhhSVmkNwLcR7aj82mfnm7B4S
uuW49t2N6KeEgMppelI8A8m1Sb6DetwFAKKh8yDd54DC0IWgCO04QdLdXtCKRJCK22IgLUbjCt2l
elQ0l920QJ2QDoB36cbEHzcJHAAkbFUw56iDtDzT1lhyjuMr5wmY00SWdo7ij6iByjgvmZwOjRGs
NRsimPxkwTsv8vWUouJ4RiZskAJgj7UjYN9Bs5R7nK2syNbIEwGDHGKnFRRApkMk3CGyAGwzgxbh
lejCEK6KBF2O6EHgFrTmoK8VXIqp8QFG2J4UJCz0EMpfrflamikb1e4H6cpu9FiEUBXLGJHUC1tc
0Ji9mStNjgeVY26USmQdXjUTnuix8p4PAFqj9xSiNCprKwNCON6ufb8eaYAXGsHgCdtwZp/DgwIU
y0IDmaTXVe3aqERkJmhmIPPRShUomA101UUUYaHU1YQtjBn5NoyA+DhImRe5pvNvS5Uzw56Q9Xuj
4dlfNTVw+tbW0VQ/qGHKMS69EKM8oMoR1sRPjRHsX0CThJUqhWytXrqcPlatWT0W1phtBt+Ck5Z2
yPwNY6JFUAV478T3dU42vhj7+Wr3SIKQ0Y3kddEGTNTbiLFQHS2RPvpr/j1njUO0IYyRoIL3edv0
JsbNZg6inVWuSvm4JstycV/Wpn7yaFfh19Z098U5GTn8MKZKXpNKkUF3kREw7+IgfXP9t1pDWQlp
a8PpRaYnNS6a7r/Iq7jTMJh6sY62F7YUWnwwnMRGgH8kRWHIfi/veEnz3DyFN1zRzqUIiqfP5qUZ
QSLfJYNbIcoePOFJQ83rnCDL4GS5/AeGxD5j5mEJjbRV9P1M8b4l+Z/8fIKggAu0yqeTVBZEWqSI
Wl9HwQJZNjDgVKn39RWmS3fxg/BwJ970AiUQVEbY9rbMMJE+i9xvsGXLCLPULj3tSCEDQVt/HbUT
97L8SvD33yGYDIwyOc4u5KYruJU+1ZpZOiXA7onS0WEhDlD5fC7K33C8IO5Q7EhS/fTj6I2MPIt9
kE/uXz0DSl/NiY5IZuwn2oQMld/0NMidmHlf/FNr/0aci+kZQ3PPqOlfv9yf67+wwibgiN4XItpR
saPF3Tqa8n/izQzDrqCXMbGq/4XQQMy2fvuxQO8Hu7z7VHbris0AJC28ENJD8BQRnTAgonzauL9W
cM/WPIBtevMLwxR30axcqKwa5Cy7Ci5nf5PkpU0cC8RhopQ7DLuSK9AhnYMJYIb3vpZNNhepwGQY
AL4ixwXkmb7UsFAGTR7LjqfKfg8Rgya+kv9RHr9N4lQw/AuctwOj+amuXPyN+OKE7sRDIE2NXe/7
bQaFd2SRsOs5K0PhLC6WL5xb7NhEId1OeMwnqLT2witBVhbzR547mJot8UzppTin6aTe+b3NBW3K
x3zs6ErnrEGZPwJEsciFCbF++dDPoIaeoGUA7kP6IXUr+32jgdMR6GMufQ/XZBZ94Ro7IhSfhRzl
UnEKlMHkiueDxQ4tPNyKG8XnqaM1Kys716pCX06Ro5LSOGNyLtISnRAUqAckzpltuTKxea/B8dJE
H74aMNDtw1ehKGoEGD4FcEQqUgzDuZ3btmLpOpbp9Drt+mCSKjpK0ZtMUs+3rJlbiljUChruS0/d
pl7B4gkOmI/cGE0ehblb8QdnjvQtttbdMeDiHordblOSDGhWcelqB9SiS4VwBaNrX1sOmsEbC/ti
Pk48J6blu93kAzu6ozlQmTq3FlqduLQoZFu3kDcOBvNRZoXlQTNz0xffybuuFnrnBZa4lLksxHDA
eHaaH0JSJZtVgHjxu/YV9irNKSdEvc8Dt3DgAaa9yMP592LwoyEO6eeNVzzb8vAffBS/dFA2E1uz
0gMoa1zIZ3aH0JJJFJ0i16bnwSo0stCChsOsuS72GFWcQQr87JSenFA3CGk3+4nj8zUfX6OYUz0R
c8alAiZwVikgUeT9aJhUkXtw7Nm0kvM+vIyFieS/0b1foj3xvySfznBQgRUgDbnrTSwKvzgV+83R
0brgVCJ+QrEQfhyWhf/0en9/8DkXhgN2fnrm39gTzwqC+jXyGP58+RwQOPdEb+ep3e8IHqLr4/2o
U2qhLeB2o8be+9biOJuWu0r/WXqEAa1E+5FSCwTHIBPJHzEhE3AyqZ1Nmf/SizMXEQh5kCn51gl7
YgE8fhZKdCHY28Mr17AYK1FaviPwhew6rdAJDtc69b9Y/jPB6a4/NxVe7ikX0/bxM0gObZd+NIBh
sqh79/nfozUwKNq38JieiJR/YuLik8kjkw7zO0fH7b5paiwY8fAk1WQALcKk9OcvJ2LWxJH5DjZQ
fYaZ7r+SWkCJx/ckx1UrNHjj0VdUdlb1PU3CBDjBgV0NHDNAfhXDrxy0HOrIoaXRkj2ntD7ErZmt
ZyHzGoodD7GfVr4QXt2lKX/QbtHzubhcf8I7h5QKB9HrezWRxHZyvFWsmsrnvLG37eVNhLfLuBps
NhtaMFUE6VPuL/UV9B2MBRbUsPXkrBwh2x90canOci8l9JN/IKFXaNDDEzyfHFnaURIv2EnMantO
KwGS+k/qwxAGjTvij8Ppab1TVHg0lnr66G4l1jPjEz+N9LiPQcPcnR8EoYdFsmOUMPWQ97vrE32y
O46cM73DGYwYIr/e/GlBB420g/3TsvfDwvidEVoKEZxO+9h6Q9k9YF9hiF3j95gb47ePYhEbANeU
q4LzjGP+d1KrzVnCRDio+jwQbYKIPwuL+rMBSvS3RwQnu8o+9/+NclZdsZzNHVWSJnli59fI5l+i
LXqJ73vV/N+0lY5AWKjHJTeXlkqkfgnDYs+PPUoVynQMrDAxjtZB6iOS7J3M/byoqOO4sGKU80Y+
5L3NCGDLL1usVuYffQL9WgsPvlXVcuWlo0Ha/x202+y3Mk4/RRwcSOYENiXN6Nu+m7Zw4qWVfxY9
s9yLnVFYaMS+YRBrgVaNydJ/FEqI8aHQTF6N7ugcXKSvZ2/mqRgJaASWYVxDX9ELy6zQhCIprZxw
DRCxxaHCqAj0h9OnTlYY0mjMvVmSQNmLfz4kjXItire9/+htl8rUKkmtj8OTwQ3KpmKjFxFZi3Nm
4wCRCOooDI9Vwk0NRFZtZXRlIxaKGkgvsm6wQjxdRRtpiTtpg0SC2DJ8krzlntfSfQrLTZXHtcee
ROJ23jfMQkSlluSQNZxg9LF7mYDTImgvaTMsSp4oRoPDF2GNtRI2XFZdNO+wWgmmwJgOE69cjf6A
IyUwU2XMu5dz/PYUVuHUz/cLmGv6KZb0vNWS3mKNlzM/O9loRxgB9k2NbCpnaUASRcUgge9LvqO3
hKzfcXclEHbnn9zJrYxkGLvauZhAH8B+TtrYQl3jNqAcsCGyHXaQ0sP101F0ip61kgEvuGZ+XSlo
MCxNDULulfhg9At6D0b0Zeb90dqo6VBvhNGnHT3FNguaB7VeqLXGx6zIBS9Eva8vr+RL7mCKyV1Y
5F1B9pyyUz2BxUGwImzZgKIllA5wOZwx5hxXu5gk/OirDautSsIktSwUhHGPCpJnInNqbtFiOHuF
pBYGCwc+QIwzda5O5R5h0QD6h9rx/ZC1fEeW7miTm43riQLhNqOj7F7jc9ldPm46gIqKEJ5gcihE
HACaFTcmmn42K6SnovgOgSFwaYch/D5yYb5s6oDUzpsEr9jvtxfTck7jYL9Wn2AFE3IyTPxXWCs4
T+KAydE1/SGJTi7CAgmQPnOq9/VjLa/SZ7yngGG0T3rr8YgNgeE3cq3LVI7UkNqaW9aci0f0OXYk
HsO0z34gpF+c2LfwQHnIHp1xq6qEBZpV7HoOZCoJ/akZrGlffWovF4m3H7yMLBgW5iejnUMAfjWZ
sOmk/qNREhTdP7Wo9KjIF/0+yXdt7Kod9gKF7fazMEcRTz/ArsQcqSm8fzmSnc36B77cX74uHDCm
ikbbIJ0NEmLur2ERzcE4CHP+klRSGle4b+uPWeX51/rTKt8ktckFvA8Wt4jC0jdk3Q1PULpwATt5
ZSGFEbGVqfC2RukBukdKVbKpalAtPqLE3ittKA/DA9WzFWeOLE7VpJgJBHgvVlZsE0+bouP6GeMO
G0wb2e0ep6SrZ9rZ6rQhP+CM2RRU7tQkkDC++mKmQ31dueRRJ4d5fLEq4VAf1OONkcSl73aV5TX9
tVdj5Ki/C1SKZMuEHGS+PjJKzg4IoKPWhC+iR6TA5qEgD+F/e1DdIuzAQBUb6X15/7VXF0K6E2Iw
VEicxBNOqOl0QMwJrUZmBWxi35XwIqOlcE6QG3FPob7tn0h4LrsrtLy1KaTiDEjwNmcMYCsZKcqz
whVUfzekYU/URjG6I8S3hPi8MmXekzuwYHiEJwGZojCLCrqx+Q5RepTIJrTnc7MLsuvvirIxM4My
FwQ64WT7/8FNT7xXCMJn9ejxnbRTUcMRSofIT0rIk4BqaszpwvtbOo/kO6zqnYR8XZRj2b6/CRkm
S1DUG5fwORwvrmedf5lk9+XYebIdKv5U7l6oMTyPEU1/JrQIiLAieBmYDXBrvC2K3lm0nrGTrbZU
I7cUqZHXn6a9o9rA2+BwNovBZ13DOpgz1IUhrHRMOPWzSROdk+J2LafT1DRWVPubtn+whhUkdken
sVMpWc8FtKEpBZyp7thtZx8SK+UGwGjmcZkY80Z3js6j06onP+egydHjmsvo9Xmfao0IPrZVDFN3
TGHvGOR3ZA2/i02zIIwl30JnNhOtbwlvPCWGQlr0vQXWUMTT+ckvE2adTqRxf1csoS5W12wbCs3s
6XMr5dRfNfrCFZXC9p+VR6HpypwfnR9YC7YLtT+45kmnMpqY3h0yCpFP3hvfhARaLu4o9E2uaseQ
7K2oNSsausBCT6YAkZffI0RI2rydSQQSm2TV1ic3biA3snbGGxXlloWp6RFRQNRwWKNsf0k1WXCs
Cc1rWwJLChrBmjMmEygy8orc0whS+pO6psDxUhxw7+vhHa3F7LaD9FZmux17Q8h40BMjUYCj8JDE
azrveAKQUYUkZV2BMp4sYjCXui/wQPixKGNBgXnOUtsXJUkbG21izzyRHnyP3Dhn93V40/q1oXRb
T9w/YmYuUNPOGcIKHHVJd7o5Fpgo6RTpkvIWsxSRdmXxtM8MurlN6LjzH9a3ycVsz0O3ubU75+1Z
Rh3uuTfVZ4+LNGqVC8o9zjCO01Ybra1FYC9tdyAwmdWZ80d7TOAW7hTbC5ZWhYCR5PyRb4JJEVZN
c/OpE/YokFkcrXUkVuI8497ZYRQyjwJIGiTxeEVgICuZU7f5RinTxOwiDgcjPCZZG0d0P5W+xuJP
h2pG/Gp7s7ESjqxdyMgLkXZiQqpGb97q+euQD/btqn6KpnG75WD08zz68zP33DHnrL+MVa0XlU4d
ZPNyfB6tE91mcXIObxdYwixVi309is3KWwws+ykePj8+jBu0yv4RHJf53AFWh45peYczuJHJ07r2
n95i3RMeDnbEw/cm44A+TXYYTFOP9WHLtMqToxZz1kVpEuOKxy1GGXsPNHifa+A1u4pv6IUdSbC0
DSQ5SA9CGj38k1j10R98NprBpIg3BC3jAuOau92SLHDClhYIq017pxU5+0qI7d3z5UHE5sIDaU25
qfz3QhPD+QFepLjWvhABdgS5Cyst3VDECh/caSivt9BnO8Vu2HkKQCrx8LhyhCI8TSB7Ix6OjQZk
swopHHAZxWMTAiTJVG0FJ1QxMdGs82ouBfGcuq/PC9CG6wUuBFEt8+Lzy9F6JKSUO6DC9Kmzwv8t
kYfFauSjYwJ9YhSMAALIhPd8EKIbPAz02nodekpGnJkReDS8xqdV0IHjwhwMvKh/xbTCI3QKr3yj
GAUWfxh/T+WvYQao7nJ3BoIy8aYm1V3MQtLrEvizzrj1Li5E9DVNRID82oDAJLJ+v81jrZkHTDmb
WkoVEbXnweAmII/P6/gc8tz2jZyCMlEBxEXHzE8kmZIHj5TT/S+K+b3720syS+X0zmIJwGLLUcIj
O7q28imSP6f9h7vpyN2Y6O9RFuLTi2kOdVnuTSlUfs+/hkHatoelkIDSX3ow6NUKzHXmXdeR1j5r
8jsqcc+P8qICYbbXi8y5uHB/hVmEv4qHyG1WlSg8qMYQXa/toqt1eyHQpJHOqnlPsRSLVW/b0FNF
dnxskE0/uUfYmUgsh+UxI0LAk2ZF9GmtXeULtZXvOyLGwY1BzN/R8yrofgoEmrqViHLIi6gwzWMh
0kvRoKBk7BEdqAIvOGtOvcKyOrwFxYQwpBmhDGV1GNu4gQZObbV5h9IhCiQ8FVL5bgrTDvS3/4BW
Z1/B1AZtF08nkyIUaErGjMY8KtjEXnBcUmKZE9z7IlcnUKQ6yJmoVaRtUbjnQ7XkbGvXsYaQoGoQ
HFI5HadNt87yBRdn/eymPRwW4A1ZO03wqVGpKMWgdoHxdz26pf5OItRIdZzNkM1Ca3W8brJOYiJI
GaIh1XsO1jqYHxSyOBjGXPjnxFXdYDAIxdqVivcEumfsJTZxRumqYe/cMbv4CRIelfqCciLZbUd7
HyNxOP5S3oBb5ofyz/arOTrkplLn7IzkEyfdzwu2qAntbnLvN43b06LNSOK76D5tC/51jyNS9LfP
ZneeGbMaw/ONa4EDK3JXz/LICiwHfCstU/rBmpVDHxerZx89K4loPKFN1PFjFO6wVrgyrDk3aHxE
ZyfLeTC/GGZaiwl8zAZPDqmSVUCJoQqzptSf2ZeJGz5P7oFwVkw3cqrohQyMVdTHycr7qY4udt0s
/j36D03xFf2Dx5seb016YCsIxWt1olbQzpMPTwjk9GHJh0RUv4HSJgZv3BISCzSX1zxei8sP4WMi
JMdHmD64HC6Bkzg07kFLZJ4M9kpX1XuIlp4FaaRwukntZtyK6SYRM8JW17PhfYUIeKxHrk8Oo3pF
PYjXsR9dzroG5QhWAXE/12sBKg/ZwS5OQwdMR9dsz3uqfDUUTe2/jUvVnXmTSLE85DXRe5hh1rR0
/YWmlpHq9ZnFxWRbmeeLYglICEim7Bh5LXzI1FP2gEAeaZVlukeJfhDmL1hE/k/rvNTKGKrCftQV
3XM1l4wyzfcNish5g0dTSUZ2o2no/3KgLsQWb+PDVt2v583NEEhIBAnhyD6SkBLYNuwar8NpMBCn
8yddjLkl2Hchj6Qm1FrnG9Zz+q82sLGtmfJe3uqLvu0QP5B5huRjCFLT6ZZ7ZtfbClSqSLsQIwFq
mU8momNPk39Y0Z/TBFJ8lFctFQ9Wfyp8uNZberV8mqknh//snbvqrn9L7n+7VvnMhKEVBFm17Hr6
A6XRf7sED5hMgoHeW2Atg59dC4+WqjuJSZf7tizOv1lAlTP2WPZ6Odk0ZRSCWX893BMYbOL4DlV0
ZtgmvJ0swPYibJ3s+1kK5/SPWnjqkDAXA981xLIrLbwzufdNgIKC1AUINwF3dDqZ+8O0cYK+PmpD
Jci7T12VJ0LPad3h2s9MHIl8pLWuPaScwjv7z0t11dM1V/cE9cf2sTiUcqNhd/X93XE9iL+tUR0k
2yS1Gczd22L8CJOoEGQHpk81sn53H5oJZWUmvB8bJv53LwIqT5PVp6zb4Rvy9QZgbQH8Hz1mzh6B
ai3KfqGs+E2qtxXcIRpM6IczAPMBxnOS4ExvJ0BCgDiMyUtN6gGMEslKED0mnXpYGFKWmEZDehGB
Wlydf6npjSYohqCbtYvKYU0TB6uRNdesITLw+rRHwrkkwlZBF9bTMLUVxdg4mZiX8bSXZg1ySWIG
8mN4CcoQ8f0aPixyeiAQ3A7/VPejB4Iqm7LVuv6USTrf2vFl+ztQwvq8XfxEocXvzh8Vmgpe/Wgg
INi4QIopFbZ/NRYX0O88NR6992Ojf31mvl+EmgLIrr7oud0JAeqnkCe4/vY6uCYaiz1ED5oyewM6
pB/0FoFCRXNPuPuNtYer4gPZtNFn33DBBGsQXu4Z1EFb9Xf9os4n8+yQ0LM1zkU/LmF+5LTV/m1F
czvlR7m5U/BGqiBlDdburWxXj0kmhBe6KSKJkI7cDYhU3gr/lDL3lg7i1sLSN3wOROUYD2yHWENQ
A5dCASZD+C25irx97aRh8V7f6JWv7BzVGaBTB/yb3/2fovK0jcUzpOYqckWg3opRLFLFceyqcaLF
dHn+6CaGBd7CRvYUK8LUq4/xmXQhJvBPUDbgKFVBFj3Zm/wh4GpjMKinOcu2T9dX93sFBUY+BLXB
OdWEReSSY3HJ2EJ8BWVgg+zVp5EkXh6vxPzGdHrS8BOw0ZSor5zVwYqnd6CdbmFfjPIeJz7StYqX
PUouAs6NJIEGvqWbrzhCyZoHrcIVilBAk/vM36aj9AXvAD+SVvnInQixIJQZy8AHjEjj372KCjQn
zb8oLckK/GoL5Y2hZ/qs2TukTLuj57/GeE5Ft7P1bNhsjgQCykbLWoO/w+KAUKlYrgjJo01EyHNi
xkJs8m0Z958bR96O55Z2ayEgqK59yqRgAekMbSTHT/0tJjBKwf+6Ikwjzw+DJ4xvy1UdPEHSvbh8
+LSaaqfVXZZfk0XrMPW9NgkchR+Q1upFx2UmjHN+aZQQxGYAh9Nir+ZocMOoqHkZ3n3zF2BjiDzS
K0ECVqVYfk/auT2a1cK1Oo6rHeusObdKsokfLJQN2GLw5MqaFHrtTA/Ph9Zqt4S/8i2gfpZHrt3S
/2zqJ3D9n3f6P0sMRAvHBRDIP78myvoJJUqCF7yGlcYezOpHlF1JU0VPOPfYUw665gF3XvR4crnk
Glp3XwYhPjYW+S9zAiheX/+bmvf+HWf97RaxFuZd6Pq9FESN5h/qNs6g/Ptd7sGe3/XO6tPgN8tZ
moR0MsEjIttUMyDq75WxWf+DySIkZYuIInKyUbDFN5N5kUuhxOcKUX5tgB1l5VDzxo0TuyXOC0Qu
Bog+wSvUefWRyIMy08iXh8/xoqvVWCSdfx94uy58suzeJyBici8X5Xv3++ORvctT2iMoFS326sz7
C05wOiV/PjNcnQrIL6egJ/9c99+ZkFOdrCMLZx1pun4xNiaAIi+O4XJZa3eHWr9zLzfJF8EEhSmq
q2YmN6EPX11xdflS0qxyEJMaubo2ae9TRLnSsbHMZwatAnjYApiSjK/iU3oJLkszz7oOg7rGfnHY
UzoSzM0yqln4pd9TkTVrJ77X3Wc4s+eDl9gn/1lAfzk+AI9qXgigqejHe9hjTUHkLOVGu8HfyZlb
BzT9XVrNdtYRp++X1tekts1N7GrdeVP0VXQ851g7S463otA+iwMblqzbOOPiQCiz6udl838pwK36
b6I0Ihfkq3lcqzEFfeoTCRlW3wBYqG+lGAizAhFNTd/VjeTAovSKHaR0/KQ6wxFA/qH1VGxxN6oP
bhbKyjDpZloYzrbUWI1RJ9HLfqYkTpYqN0xCHAfxWuRlypXYcE6I939xHlMiCe/OPsLLH7ImLwMm
0CwY8/jO/Uilet2AVGvVhQWfpfq+uAts51Bk5f+pKJH3UjR4Q52bF4am/7FLuVw73xrQFJXDUgyP
hZbN6LbeW/jJEqEwpJsD7PUDDeKK/cijQWYjnYxJ9MPF1mpge0TZ9yosJXbZZX/0yeWA2CKhEUyj
SdLHc+2yhdjo769yNLcmrwkFmkHpxEwUcBev8LK28O6bogd8lv8LshCMHBMnPE8ZYDA3PwSye9Oh
U3kopQFaQOHlm53H7RkyMbM+em27+XV6uSMVmFz7Vr4UBwWbZ3DcfqEzvoWnJj07sO4nQShjeI0p
/wKfR+XFSrE+WoWAPN/V2jXGPHtOW3l66Ld/x5SV2E2PpvHgjX9SU1dFvRehrNn/ZluDlQMEVKF1
0LbsouDNWWhoEMtIu+/vgubK5hgn8BcSg+sRcaEm/tGEqBN+XEkce4QVAMDoNzYtRpMB533C4Zsf
Y8vbrVrXraur+CN3BGIxxssNw1OKL7Ml5Dmyn2zaIPrId+ClB8/4IQQHQQAglZfAOmcxnhxMn5nc
0o9aqsV9hAPiv0qmdhFZlJIuC7t4oQkI34tpihsiDtGolrMr4p/d+Yea3Gms+cxFDYuu31IxJVtC
Btat6HoMktrAlZRDaqY9Dhh3PPrhTdABHgm8UOgBhuUoPH7sFqpL78JOaTLHsVGM8s9IhgoeLujL
KBq64MWnaJ23f1etNUacZN4ls6cvDA9h1r2uDuedi3KWlV8kG/IqaqKfj1yC45j3R0+UiNn8k99p
8wA95awFqEHAvNwhZk79xwSZBMyllvBt1yZWTnljGr1GN46e0spyXa9W5CitMLEeOUAL3niof/B6
5U9rrEdnmZr5eFb4y824TgkoxhZuVjTc2Xeq9sUZYnBdrU9+hbNk52ZLqn19u4fCFZiZmhg5otQs
8rPhlLckMBx8ELAS+l76xXjJp4asNLI/TyNuKHGK+UrsRlYZWG6mS2wZLkMsN7c/3t7JiFkAVJiY
E4XqvZCRnVIqMy48C7oZz/PkX2QUUOAqYMjffUnDZuYrYO/Ul72DPLAmxW427+LnmrXTtl0S10dy
k+J4jX37Rpwh1GXFCyo4RNzqtuBcr3z3/tzRg9Gf1iO1BP/JEKtcCsj7zllynm7k/7drY4VtCmi7
HrsAxYmFcJXgtvz8gn4Ncb8yordnX9DHwqGBT7o24q02T3yjEiZX+5a4xfNS9HBb14M78eperSAt
+QHNPlV8fTUSRfeUJ1Cy+WPnfG2tJIQDA/CR9EDixg9QseBGDjbzrw3CeWvveKP3KK8sGP9T8WU/
iEk7P7Qr7z3DaZQbTPJuHf9pgEhjg8vxyzEK2DjolPSA4kBwIOsx2SRS0x+S8BXwe2sQMEWxlzk3
4WCJ9+du/Al2sgym/6++S4UMIGdTeuCRvJPdhir/qQ33B9P+uZ1sRUh5lfvt9xQYCaUyvOSy5n/K
S7d/gV/hbwhyymkljJcN5a34qzgwZgyxXZsz0dD9OK8AlWZnL5gqCduJpBb5JATYXnTU2hoKSNGi
iZue8Jb5GieuVo1Pq+aXrAKbmaXRvFlM6bolLvlm0ed9IBJ7KvLI6r5RuLqUGXToaweUEZgFWanL
yvZ8+w5G+6vQ0Co23MuMOaoDUtwXig1yuXmkO3oFTK2j201PMtViTF7EnNT63vYvv2HGfMxMOs1y
pgfZwjpCfHcW/epgKD4KFprwefwvwgO4YibZgViWMnDTKzVLVY9WLJ4EaZhqdBUPICgfBkX0UxBR
CPqvXZi32t1U4s1QucD6OmyuxYcJPjHapP9U/Q+mp5oexliVCSYRqk9HRspJ4aJ0W2MWndlqnOAk
vLDlFlezIwwmcf3jq8he26CutDm8Up69lFHATnHWPGuWgeRffoOTtgtLl656j3315O6j+8yVLILt
W8tb4vTTDPPpXws84DY94yXQ5UFoZQy1veq0Kp3wCLv0gX+CLQSOL/wQQXk68HbriTKBM4iwEaJY
gSEu8PCgf8tLZg7vg7feWalHcssSMkbiUBn9sln/awogmduBseuwEFedhIjLEkZPNIEcSPNnFHwD
AZYwBQ02z5bx/iz/nngHBgiGkXXlUqD9vp44jrLI/oj6IoI78VYm34moUdHSrSSwiLOy57aIR08i
mqQJ7RrphSpRgF49z2vbZAfB7jv16XVxaOatlj+aqjBrhgSNVGKfNBMCx2zcWrFeAKHfcLtQ72aR
YVKLoBgB91VyHh2Bd4LcPuiVlRw9g5FCW3AE0ntaxIPvBeo9yy14qrUYuGP0OJhvW1qFurlhi8eA
mMDijX88kYrDs/P0wemzrD1IUKHaU5aACopkfU9b9Q9Hu4QfpCl6vUDSw5tviye+6esBhYNFD8T+
2s4w7zVXEQdPTRDGfIinFVbY5HTVX3yyMEi9KBvumeDb03idplRPa29IEfqT/kgndP7VoPJmmYp2
eA2XcmR3am0pdzPBlqL7aSWsLR+RftZIyF2ITegDa/sLG34gHJreYV0tL43OQEGcSXVlgvfz+plo
pJI8KFqPfD9rMozsQx1EItXkTjPuV8s2HM2zcAm1MlrOAbZCsVo6qqiQr83sc8uMPqhqtdAW5t1E
pZOFwhynf1TOar4OqqWUEWDo2zqpIK4nDeU63d4v9wDH48SO/2SIjY2A6l7TVRvD/LTwAVkF1MGk
9EPbod1deTSNcvG64wdNfbapdfwk1dZOztIguLC6imMcQuUyh3DnVNroIfavuwvJKoV77GUFyfPS
Q4P+mN4lQax5CFyc5bGDemUoL9IMy47ouIxFsWaZfZRoEwVNPCP6pcBfUeClbcLjiBo8BZ+H6k1V
rW0dHz5eHOpoHpS9OqbsnZfKPeKKUW7/N9EtXFh/a0Cwa/ZhLZe9R28K4hibD+QJTZkU8YJFqZLu
kw7am2d4wf12pmwi025e3+ZKuBICW/Y+WEDhRaP2Zr/jngcMnmx9lZO030hlgu/Ufeio9bdGxY+2
3RB1j0yQfon8kyeGLPsuby6KL7T7CjkA0iB6Aucj3PU6ANj/XmhfzZuyVUzPFwS+cG8+Ny3Ype3w
5h6fMOyeD9XJgJtXvy290jvR7lBsQQjSO4RvXZmgsH8M7ObNVD0LZjGstTQwuBs38IVRr/yeqwhh
+ZeqD/WbGbCCSgk+TC92EhvlqJmDpw5oI9mAAr+mOjq0gme5k7t+vJLOMP+aoqfUWRHKqGhxA/Jb
d6eVBFKNzaF0VJrSuSWhgBnmzM0o3d04JnEhhrVNQ4fRNupiiemHvJ0WNFmt3rJYZWLyP2NpDrMD
g5+0GjUzOBcjO6VEw0JtH9BlCb6Jbjb6NdgFQH06OWVi+1gtHF3/4v28DRyl+Rnj0AunL2CKha/O
f/asWzs68HWU4Untq4tFY+ORXT8vXjTn8FY7kKaAsybdEiRfOB9i8YXsWMjj/dWk1RDUEAGgsquv
wX2oBUgxo0684rVCCQxj36oriHTFSwjHvsRKdfu0mxcRQVWdzal4arTOaDyXHWAqasie1MYJ8kMO
lp21Ub2ZFRz2HVTZpCi1pZIJzLPcqX3tZsUXoZjJA4r8r5CWddyDQFhn2c8B7AZqKIGviFjxcgER
CVcagROD5k+qLSuEs1t4Z1Y5tVhJGVqNw/VyNd8Bi9m0vwtxlQCy5JLcGGf5CAyrmf2e74CsXp0O
LqfYOB0uQwHy8i9F4TDcuT6faAPb2ceBUBe43rJ299NOjxpqdbbs7aAoOECxErU98BhNgf/Qjj0v
soua+Z96TbMS1Ru2fGWuyRkrbSjJ4rJ8HHdMjUJ7xin3zQwppcVaXyCR5XqrEEZBSVDCxFEwDOIX
mwANDq2rNvfTJyq0qypf62/JhOuQY1q36844awpQ6WtOl01zrPk2hqED5jlgx4HMTECzRl7FDVOe
/ZVb6fsbTZhRFXR1bP3q1rR3w38lVyLhD9dzXpDZDGIrftW73oQA67A+6ygcoPJ56oeKhnm6nW69
bNryys74Gco7PzqyXVnfuKDJWx0KhzF8zwiWSMyVPh25GQyekpC9fi05VvcczGRm0ap47ZrFVELb
ceGbIEr40GN7Eiu+DaXnVzSH359fO9TTB74X+jwCLPWC/uk8nq1lGQsUYj42o9p+vVWePElxJoMR
pNl7VpoOv6PpTsvddjnCuY5C6bjZxjKd1qRwLrmXz88YhP2BGFHcvVTRXWo7qAyhE53mdGV9O3rc
6Fve/W/lDmfIzMSarjQfrEN4qPJ2Hcu2a1/od3QRXcCDIF6ZWPvwk7JSbDWZZN5iRl10QHLIyFHD
R56aWJUDlud57JR0cOpZL+HJGvAyTkLunlNlQgTIgtXGdiGlB4RDOmeF9H2hok0Sb9bhTHVgMEFI
zo9Eq66B4wczisDuvZsXdgHHwkP/QvdsUGUGdYMB4ZiCEId7JK25TuyWIJeE3HTf3wzw4jmCfQqm
lFIl+t1D0KiemNrmpWWtZzYPu5BiDiC9bjPaUIJG4RDdgHmrt9FXynJ/45Lw4cYKY68nFKXZgYX9
jGB9fKZ7PMUxM9vcyYdpEcDhS36MqCI6ojx3ipsXfrbCBDvfAxFCTB/S4T1BVmVYg1wH/q2aei88
HpAIsJqfyb7ZV7ibBYj7gxhEfMYqgKe2QnvjROUELPPHDhzl6ZWrZb2j6CUkQpwrZ4Zt3O/4bJ1H
Aj6T1j4eks/CyKAhhQoUtKW6GsDoqKUqnbr/Qh31n+iU0osPdlt1AKnxxmtPAn9HQXd6LhQbMwb+
RtaP5wSrJ9oYHIpII0W2Eh1j2xzAygQBDCfMpl+DsUqDKZuVa4ZEW036kPfooCiQ5aKqevZN4m33
2N/PixCgoubjzhsOrs7JMXAcfJjezgB2qXRBqxX5KFRiMkqaIdEAC4yC/Euw541YgzZ0E6F8h4wB
Bw/JTKscG+VOxlXzaaLvq6j2Mc/J2MvU928gDyJXf/O+rFXgfnd3h9s54c2tcoKuZBqcH50w7pvo
PARTjCUhZXiItMwNtUyn04uj8DAseIuz8k8BYEMj4LjgJJG9JF7cHox1pp0UeGWWbzNMmG937dk8
PvSs7bWz53VIFevyCXpgHBOr+NGCpzFJY2FAeAqAkdse5A+KOVcNu+SrDSHOHN1mNEwezEBrV/s/
Kfi2EahJlrsnlGl/9j29eOFiBovmpsGvXhQv1vN4lQ5C2rVMyIzZmXaxPDwPcWUHNuF4QwEJOq6Y
uX8gSJrpluzE3D6ac2YIjFrbtC3eOGHTCCGnNV94u5zXcP60V5kXsyRZtVoexiU23ofPkQScQri0
3oBzAl5ZLVVUCuoba9o9GN72PiJKJQDZtJs66w6MHOGYS9aB86zhsqolLQhEiBQdb/PIUwCFRE/N
Fov6P40GizaqOYiJeojlv0gqkqOi3pz8iFvdATa7tNJCNL8a1/Mug6VnPX6r7kk8FlnwqLDp2kFt
X2h+JoPYOvIncOlrHwvElHX1gu0NQxORpv+Wub+3MNp2Ryyh52NG5WnJldewxebsOg6aAFoUqi3L
tNXYMpvawqCCEs79iQrLqxlxsVstMjz5QST1f1IixJHe3krgzxtxK2dj/WEiH1zsymrvPIAiQ7Iz
rZFyjLCz/G0QKFtCRWGmtoZXd7iDjB3djaz8OUHhN1h7CVXvgoY7X5ZqxujcSJ11mxV6D6IGEXsU
c93sUTHIhhNPBx3qqvSp3qOn/Md6VHn6mxdwWYO27NSakrs3DOupxJ84N9OqL1lIeyjBBXHETvZq
UCCxQ4Jn7fBjSHiKP0vp54keNg6ClSKdmzTxz7R6l1olChNf5y903OVnodfW+sEC3w1mKqD/6vW8
XRZEehIdzc7Qbjfa0j92WuWVmIoVCelCtWityAM1MK7CpBRgokQ5wPGbnxXcv0k/pOgKDjwiwTmF
ySAOEHqlz2nI+rpaITIZ8lyzB9dGqM8pClUMhe5GfUKeeCFu5tUM9IXT3smCbQBq8ccfmlpl5igR
BlFLC2/bbN5teSf4yx/yoh67DJoinK96hKZHtBx8N9jFBv1a1th8KPQBftg9NBnP2aOSvsOdONbg
C/I+L2gZorCEdieUjf1JhVlCM9X17pns/jqofvajT+9BCQ342FRnLO9rmASWLC0Zo41gfIZ9TIfT
4FCG/cnrlfKSUyWjt9i5wTkpyKHLmTKaN9+WpgQM0jpwCNgNuCVZMkMT/HlXKfDNy21qO+29ir5G
6xOoTrLnHyiWAaKeT4CRtyjeklod99ZE+j21YOzVMRYQKpZYEy9IVsieiuoU99Dqe9XpPERQk4fA
Z8THQ8PgKDGxwZcIi3iZQ0sSMsWTI4FQg3y9xepxlxGUXpG1a1YfjPrFvjLfaRi6CNfFOmerObi9
U+5KcNmF6Tg6HtGwEWLTMhCQCVlUW3o2vsLBCIhLwGXMfSWI1dpR1pTfSWXnbqNm6z2LVWmsBFBv
6RCDwYuoUxxuhdhe51/F3d/kzDIN9Dau1BAFM2xh+PHJZgwD/zee9S/8tnEPD+XsMyeaVP0fGbxn
y6RS4qrXQwZap4Qfc0eiDpbyPTExZbIgPw9WUzCQKpYZNX3xG1R1fbp8tTxz6TZ91WZ5tuXXTPvk
gAJMjio93JOonduwx+mYCj2JAuYgVZEKkRta21gKhFCOLiBuLY3DXlST/EIRP74rMOQ/4GcC60LZ
fpri/LnS+rJMaWHNig0+Fm7uyxe8FttXKY01Jy7NITPIRrv3XT2lZcQym71LaCqgc7gsTuZHrCLH
kkTXO7Y5d471o4DCRJ3L/NORNa+CROQoYvhL3+Gb6fkoKkzHMC808IHnwfocXkGm7uVBu2f3CmQt
KHdfop+fHkvKohyCXf5oGwlf7X1u+JvXJp9HthvTIdswOy64RJTagIlOlHSjAONJd+FKJogoMbAl
4xDMhf0Etw96IG+FKPoxrz8NUFlEb7FICG/+K+vaQp7OOwA3v6Y4CZaeVW4Q52stmr9nhFVp/o6U
ZVMUdkRlQfaO3iQs6FsJiEPKVGKxumpXZyk+4KcoHeKcslDi1EhLzQAVkIQy/bjoNMrQz4qooIU9
Q+Ll9UpwfqMAZHyIB4EjTR5RuzZH7283HrG7rDBnHT4n52/bYplqM3vo9/qnur+XPoBhRTfe2yUB
D8rk//a7/0EfWIEtv/a+JeJ+PXEumAqV7XNALAE9S771eKdswivfkxIVgxcVUxccs+uzeqTEMohS
qcP8Tyd4gWs1A4Q79x71sbN5PclDGQcxAfDZ35LrFgcPYYeJ214xONbpMVkQWc6tnE3PvvOcj7/0
gaUjpHfPNA1WFZA9mwYazabfkUuzPlq/IBj576Y6VvLHDrvySAd0STmacW8T71rGu/QWzwXKWCXM
6thf35WZoK2IYZXWQsr8DT6ZHoGRz/AQ7sKlKmbaIBvg2jXNgcucuDJaNJeSjdn/uUNANistV+Xv
pIwiZxPpW5JKRXeyngawtnruV36rwlaOns082aQgp/fO2yxU2KiEkuYS/u/c+J1j7fBdZJGWNBZ0
yXJPKkPjWOR8GMUmLZrH9cAWxjRV6BmF9Sy9pWYsL0YATNP2Gpv3S3TEgS2JKOlbwIab4F+jgxz3
Y2pKgJLyTQ8oznam2RYmt/7BPdJP99AR6SUD2LxBuZUSAKIRS3CUjTZ+m2TuK1SGbWPPaX9ZwiGZ
NDr8+rhQ+oLg1v6KkAw7tmFDzEjJOWaFCpv5K2fbpRth3AG6PNC9FbRjtcZYYcg4rM2GaYwSIsA8
wYV1JhlhtdnLzvWbK+5159YahtzMdC907I5kl24Mw96+fFkmM7K3hRFAp3J4nnj7svoiuwlwtPcc
Wi1FA/YFdlLrCOxqVtK5u2Up9835NUGWMsZtK1SPnAE8ztabADVVve0l4cWEmYemhIcPaUn+UIUp
jR/JTC7TRzHeMEa5uFPC8V8/rdYa3OSzGmfhsqjQGpdHvNuAdpMe/TLOVIvbo9l+pi8D1symIAX/
JOFanuEGVvnD4gWAjW7KeJqBEL4TE/HBCSOxXl9uIdHQOGFbJ68PTxJeq5K8ZdM5ucfEVq6iqMTn
7AGWS9dAvx1j1fvrfBgz/c3HllA+lIPLjoUUiW4Hf5CYl8fzHiIGz1mkSUw4OkpQQNErqRLwtESu
PaCDsqkFu18Wq+RUkDDscf9abQTW6zi50jvcoL8tebpsub3Xm2eSYnbmaywL+zXvcw87KNd/5Ek0
Bgz1RYpwWK7Lno4pvl0er2OF1RtmGIoQ/BsiC5i/wFq1hHUV5TgwyJK7h/JV2xEzrx0UhBSi8R0a
8u1GiB+CAsHEIWqmlEnlGLLN6Dnzkl7CFQsiMqRqbFaGuvtTsOJ3w8tVpnNAoQ2A32C8V0BD4XrU
ASYJJg+YKytDjwTKNkafy3kiwaRyRZk/Dd7TVCkYP+0NXgHpqp0yXijxmO666jKhLoliia+14wW0
qoO6O/8yGUP3zOB80jixCE1cP+T/G8k/joGyuE3kHOgK3Thhb4h7JhElWAh09VC2jde/eX/d8o9z
tc1NyhHAg2DIlBU602YpQh+QJI3NXKPBqUGPUEcGTnyPLiDq/ZhHzClDkC6mPhRw/me0cRUei0yv
62QDRmJUkgy3lqMc4S+tU+ZCNIWAHxtA0asu1G9KxPp8U6xUS5LJv0Y0Y/NhT+8kLPTeDuMySQJj
KoEYiIWHsMVwU+aOP0PwH0mU3vqLyYKqbqLu3QyUtKrJsRt/Jz+JjbZ1U95fD8VkBK4nvqTJq0Uq
wfAf5lWuqTmYuErQ0R1PVyL2P+kW1BgARNaWWxJq1pHi6tvRLCuIQVUd5DHYnNyPAytGwcAgH4yd
+VwtOOV1sxE5Ou1L+27sFoO/YG1vqDXdUCFLkEpbEUHt+TZcuKmb8qdxF6h86Lo67mkGPSvmDvwJ
MSryfWyJ31IIEsxi1d7d0uqQlGWqw/eFBsvSdfxfuj6MO9eh4R1XoXQy/zCK2hyV1tAqldvRlRyf
VYmiOq5XP0omSoM9MWp5+oKJB6oxeNA7IFKflO0obL2BhA4M9yllHnnjCucH/dIEHRr62+hTCQpK
5RqPJFyt7mKm0/hHoW21r6qx31U+hemh1+r/vnJPE38DEwn0f5o1pw0Sc2yRsRUlzFVcQlp0Oics
quYZV6biMXOtLWKeF+7Lzgckd1JxDqERDGZxGScebwo83GdjgFADjw4zXpjyJpEW7F08lFEKBfbj
25c6fxXjneuT+Zpy/r1kfr+Zmc8izq9Gm4J2M39TlKXlUHZ+Gxtlge4S2LraNGALCJQKPnzO6zak
SSaXR8AU/22TymRVOOzgu0sP7dE8T28cvfxtdDJu2N/aI0YG40hv0Zcv9uI79PIuDqMkTgHTH08x
QUGI+L8dklDSH+LYFkH7iLvMW1R1gECbwd0LlMcCbeLEze41/1p2jvCHNUS8h8FeafR2KkeU4Nqp
XrDPFn01X5ttZNgKv/9ZzucfjgkKcvm7kjziAYNL9SBpQFo6H8fU5zBSSKwUpfcL4rCcDjGOp+GL
7YZD5iPqjCETK6Qw2t1P9X7/+29qY8JqEhuTGBhCGKDmXguQ4sydAMKgUyTVd7SVJBm9jUDtXOEU
zQnMsxrJn5Eahg8WId4Kws/Jc5dc7DtB5u/knTDz/nWqpg+dP+fu0sAhEOktKPVtUdOQwwgSx2GY
jjNhv5nGYyXPEEYVjHRkjll0NwVkWcrTrkxIyaJ+dzC2XfCdzLWwHQ4Cdxs740/zWCqmfdlAredp
SQ/05xc09f0E6VzsWxAcy1diAT/mBn1C/L+bb6L4/UkBglEbGaPF6lim69Qw2HepADsur0kNM/q/
HnHXU7vhLnkSEItFZLrRFcU6Sc4MvaZ41cVQp41n/t25Dk2L4wwAcupWFzquW9rcH3d+NYAgogKt
sgIR7vb3NNOk5dlbwPvyBwyCRuy6uqDCTmJw2JAf1+nk03TZE4qnMOfboU4CPTTNNPWSPvYa9pd+
LF6U7vbo9tS84SE7R78nXxaNGOwvdNUbYJhjqPp1lRKkJFKwm5ArnrmGKCW2EYbAc4nMqrit8ic+
vJ0PmCSMrB8lJsXEe6FRHg5Yx0g9WHwVQxii/XMga5L6LFaO5kMtluzgle3OXnJ+xBLD9Jbj1Zf/
6yKk3Kc9d9YsJixsn33rZUZuJHUwH0tw2CB2k3jPjsabXjHAfV2Lt9gQXwoj/fgkLudRsq7p/+Di
Ad43hsE6x1diTFJhBU5bROmPupHHDHQujljy5WB50Vmv9JxJJ273V67PYCVJlqLVjUeP1BQ0w0+7
HmWkKMOaIisru5FA5kBu/j3osR9VgEP8AFZ/JLmTh5skBrnbj9a6ASvhOOrZUWB+laMl+hPZmwHU
+lhXyaBr802ZBTlujeBR1Amrh+c3X6PZZW48wQoWX8Is1sWu2bltqgr9wZ4s3iFTlrPzRgjHxGjd
cm2EBrRg4cbizdkmNiLvwwiAedSwxRUHpqQsCFkV+QqKbEpaQGyK8+7fpoKJ8PB49klJ1tVJnuCX
lMjLHCaSSCAiQo4kSwiO/M9AHTNWCdT7gQb6VWzW1bIQSmdZT5KFlFK1qDrx2onLe2KopAfTGQ0p
AL7wh6BRGy0bNW4dLS6CAxU8dIsQbnEde99HWUsALctobC7GMBLpCR0JOGQXjoxXZApbHFn8hjqo
itnHN85khZgIgs8ZLQY9fDfLyPAHK4qckyr3wqnu1v9vtBvEl6mF/68NzK7TXSp/CO1NcuSFRH0L
CjuMjbMvQCJl5vinJBMKABROw/25Fo4vFt97xJSKWyz7ohAY1SOBm7ihAx48Ixn48Mf69HvOKDbW
iwTHVD2kmJth0Mpf9GkxmQH/GI7/HfAQCuDgbHoAnN7bq9Q9lCgvgg4YYyI+XVqdDZgGSR2nbbE2
2e/8dabSEG1oh/kdZ84uirqkZgzOdsmmfWcOnHuo3ehWtgNC1lq8N2utWo7A4/JoB3kENOF3ptJZ
TDRc4qRQRxnKMn81vNA1mUbskZJVLbYlUVSS+dUuZqfWN3BmqKi1YGfvTcpRNf7RqTy79Jnc4x/6
LhZGSjHxs3oeYXSAWKwm/PuXtrFnbcV1WnRs5Eg2wi8b+qCeHY6fXLDOypaQvldRxs9QYPzPjVaH
6B8d88J8IqDZsePhGHXS1tvnUVo45E0Z8S0+7dEdDIIqjBa885GsXprx0GysxeSxMpfmgxYPxJR6
CgQk7wP2i0LTRFU913tlCc3Exl/XtRG/dMkR3N1FMSt59abBdQKbiPiuDLxdxgkTtwlPue5rAxt/
80ZXSS5WarqhYVtFp/U9YI7LWUM8fuLp0r1IBzr1W6sk8ZBkaexdbmUhmw/+0nTZMkq4zDN7REgW
w+dV6lVckIqIPpR3azgW1SGd8DVQFodREUMMt0UYkOdsyRVqr4lFuMZJAuyhlN7RhLfhJn7c73LR
+XUYCt3/Z3Qh1e7ZHafC8K3SMIxBC2I2Am3Bsi3dsXgk8T5kzr2CpAebTxlT8R3i5224ABXJtHQf
aCbHVcgstAJhvyZqtZewUn0X+z7hakOCOcwJqSvBfkyiYB8ilPzzbmGbZqh5JPa6Li2YQwAbHYyV
/8j9VfsYGqPw0Wwebzkge+1OwIgJLm3taznlaMII28EZuuQMvVsSODYXXJx7pO+gQy4LbLeQxBYj
TPfvkHSKP7I7fDqTTklHDF0mgDiggZWvnGq7OxkzDcxEGq0SVMaM7ADa118DJUqklmDjYgDUm9fq
R1TpbSVg1wHHpZ3T9zS1rlSSB71IpMcv33EAq43+F/fIAkkRw4s68E+atBtH9ld6EYUWZmOdKhfB
W1zxA7lfm9CEVO+w8jOj0ed+hqrKs/MZj7q8q4CvEoUHe+kw2ccaJ6i7ZTDQqS4KnvWT/+x3LVWm
rMWjtd6LZ44HmTu8fbrV/XDatWbO8tcnq4trKOYF4W0LsK8fQ077FZBtwfRv3WSw1QlMHhAfxzQy
u5NFGwppSH/YQ7TeGm5Bf25V3yfjHMfbtNCF4jAOSmJwkzO+tm7z6RYdAT3gHROAmtZNAZdLPa3r
yR+QNDoR4mcBg2gMKkV124ktLRsLOR6C+EDLxZqcI9XmiWKaM5SHcTqqwNK4EssAb38unotVDX/G
GFU+i/jOLI+Se3LKfJQkZLdzDH0YXxhjUquiOQERHtH9pbA1KVN3lQ3e7sBckSzAw1yDqTjzeXq+
0bdHcBX3tKgDArLDFtVbcsYguqXdavXUmeVgfKmVd9zaAklXncxDYFf9n6cFQ+f1wYAeHnpeYaqD
F0WJyNzOUenOFmY+wJYgPuAeazjyG2qlpgoUAnqpcYCTloP2IdJ+wwA+TZxxJ/mxtHuU7WbtYh2e
8kAMDCrB9pPgmalbfeoBY4pc2V/F1c26INom4OCrQeTHn4cnIgyHDo7W3JlRdJzjaI3Agt80gYMk
N9ozfIKcIH9KrFK5rQjDmwpTL2f7Fye6eWd+VsMpf8VeFlSFOZPuhwNmgmj5KYvgm0ipDrQjECHr
vMdrFPc5rQznxldLeMRDcERXSkAG9+n2jgSMb4NdALXrc5FRc2toQ/IsSZ9UtOgnRpMufAPAXb9X
tunw0O0LSAhjsT1i7rFle/YAsmC+y1uhv/PL6uGjQ+GiY4OayD0rOaM83ZYNdMIa1h0xrDnvROSp
NNoKvxoc6BVbZUtBrG7re/8YqS4CT2e6pBe+RYKNxhmh4GgwWc9uCXdLX04Pu7N4SKWqqVlb3KGJ
sT5i8Jt04dwDVMu9pJc8GN64dKDP6deHbLBLs52af5Iv1Y6osZHzvCcD72jH8faNWuS419EDW6I+
/mHT3/8GlB9OVze3KwJeZAnldSrShHOGuK27s1YiKhr2DvX/n+1Z5ljtPavDdXU1va6EDuewBQHA
3nd/Q2F4AnHxweTHHRQo/DDl+pql03amB+M36EaX4kz9Nm8gQ2MnXzmqvPoHvPmWJAjutFBMY69Q
FryBkDQCTt8tCBYChQD6+Mirl2LSNLIyxkvkOyEY6hnFJwL3CTdg1x5cv/fZuuZvlVij5cbJ06Uc
MA33BgJxbuHaojrMd093uoODuYKKOhPkADYxVBMngXxtl8prOiFoIkNV22quqJVOALyZ9zkkNdmh
8Vi2iO1azgsj/g+qA2xoAc+qO0pRaX2xIdFlFcB4HspU9EKN1XluBcvKeBV/VYfD5VwKSwIjjYqN
Ge4NIJibpM9XwbGq2qW27u9yJeRkof7qoTZ/mWuGpaJysB+hHHdfZkS3I0JwJ/mqq4wuQ2jW+ZOc
ohoxjssGUWhm2tpDjxixdcfWJ49PB1T5hcf1lcdfhX0VMar3j8tXq7nK0k0H1iUGbQvMBfwhdmBR
vkdyH3VJ6McscJuFdKdU4I4+QIaPNh2v+k9j+tQrkBQ1TGhXHo1naBSr0V4Mt3TGFmHW+Od6DPCT
Bsbu6j4lxQGiS+xYcpNtipDFPFwJjkMBVcpScWibXWJTKz7LEpQXjWDLtRMGjkG1rqZfFXdAy4UG
ibAjOm05aGAE9qaUMlrm7RJKswI0ey+/4t/7c9sgp6ysdjGDjZHcLMYa8E6KUxCP/f35AIiIOVg6
4L6fbt19Sutm2jsm1nwJGnBrOiwBN7NygoHrCEzzTUqZ/6FvY2XsoQKeZgINAzxrZVu6cwFvZ31R
bkpOz25dqg18FKLZQcMLmZIDucairdNpsWFcyvWUg9beCC25/jwKaV3Iv8c04qkSZJJk5Rr3iYFT
FtHM8IE7fcPCjWZqPx+fOV4tjBduhu1Zfk/ymGo0rIT3sbc8MWySHL5r0vrD92BgXxOhuu2rqZxp
6djuQoh4X+w7PZRwvfIyF0ffVN1OG3+j/qdr8kfYQPSeNrB+PWR8P4N4DdkKjXwc2uDlgtHTKp6c
O+cNCBU9YCo8l8v/z0g8bEn+G868wQKktljI6tbp2Ap5zMLtw8/7jrcpYI0cycA9BshgmCS3OcU8
vpGOzJO7lXRAUNiestHDpI+88lZxw2KKkmHninZY5MyE6iCihjIihxtZ3mUYKK4JHmWAf722pxKf
eM5ClKZKIxXV2g8bKPf3GCnF7On1d2za9vMl9UGWBX+1m4BpyxA=
`pragma protect end_protected
`ifndef GLBL
`define GLBL
`timescale  1 ps / 1 ps

module glbl ();

    parameter ROC_WIDTH = 100000;
    parameter TOC_WIDTH = 0;
    parameter GRES_WIDTH = 10000;
    parameter GRES_START = 10000;

//--------   STARTUP Globals --------------
    wire GSR;
    wire GTS;
    wire GWE;
    wire PRLD;
    wire GRESTORE;
    tri1 p_up_tmp;
    tri (weak1, strong0) PLL_LOCKG = p_up_tmp;

    wire PROGB_GLBL;
    wire CCLKO_GLBL;
    wire FCSBO_GLBL;
    wire [3:0] DO_GLBL;
    wire [3:0] DI_GLBL;
   
    reg GSR_int;
    reg GTS_int;
    reg PRLD_int;
    reg GRESTORE_int;

//--------   JTAG Globals --------------
    wire JTAG_TDO_GLBL;
    wire JTAG_TCK_GLBL;
    wire JTAG_TDI_GLBL;
    wire JTAG_TMS_GLBL;
    wire JTAG_TRST_GLBL;

    reg JTAG_CAPTURE_GLBL;
    reg JTAG_RESET_GLBL;
    reg JTAG_SHIFT_GLBL;
    reg JTAG_UPDATE_GLBL;
    reg JTAG_RUNTEST_GLBL;

    reg JTAG_SEL1_GLBL = 0;
    reg JTAG_SEL2_GLBL = 0 ;
    reg JTAG_SEL3_GLBL = 0;
    reg JTAG_SEL4_GLBL = 0;

    reg JTAG_USER_TDO1_GLBL = 1'bz;
    reg JTAG_USER_TDO2_GLBL = 1'bz;
    reg JTAG_USER_TDO3_GLBL = 1'bz;
    reg JTAG_USER_TDO4_GLBL = 1'bz;

    assign (strong1, weak0) GSR = GSR_int;
    assign (strong1, weak0) GTS = GTS_int;
    assign (weak1, weak0) PRLD = PRLD_int;
    assign (strong1, weak0) GRESTORE = GRESTORE_int;

    initial begin
	GSR_int = 1'b1;
	PRLD_int = 1'b1;
	#(ROC_WIDTH)
	GSR_int = 1'b0;
	PRLD_int = 1'b0;
    end

    initial begin
	GTS_int = 1'b1;
	#(TOC_WIDTH)
	GTS_int = 1'b0;
    end

    initial begin 
	GRESTORE_int = 1'b0;
	#(GRES_START);
	GRESTORE_int = 1'b1;
	#(GRES_WIDTH);
	GRESTORE_int = 1'b0;
    end

endmodule
`endif
