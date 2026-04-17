// Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2021.2 (lin64) Build 3367213 Tue Oct 19 02:47:39 MDT 2021
// Date        : Mon Apr 13 23:37:43 2026
// Host        : ece-lnx-07 running 64-bit Red Hat Enterprise Linux Server release 7.9 (Maipo)
// Command     : write_verilog -force -mode funcsim -rename_top weight_bram -prefix
//               weight_bram_ weight_bram_sim_netlist.v
// Design      : weight_bram
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xczu3eg-sbva484-1-e
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "weight_bram,blk_mem_gen_v8_4_5,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "blk_mem_gen_v8_4_5,Vivado 2021.2" *) 
(* NotValidForBitStream *)
module weight_bram
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
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA ADDR" *) input [8:0]addra;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA DIN" *) input [63:0]dina;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA DOUT" *) output [63:0]douta;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB CLK" *) (* x_interface_parameter = "XIL_INTERFACENAME BRAM_PORTB, MEM_SIZE 8192, MEM_WIDTH 32, MEM_ECC NONE, MASTER_TYPE OTHER, READ_LATENCY 1" *) input clkb;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB EN" *) input enb;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB WE" *) input [0:0]web;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB ADDR" *) input [10:0]addrb;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB DIN" *) input [15:0]dinb;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB DOUT" *) output [15:0]doutb;

  wire [8:0]addra;
  wire [10:0]addrb;
  wire clka;
  wire clkb;
  wire [63:0]dina;
  wire [15:0]dinb;
  wire [63:0]douta;
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

  (* C_ADDRA_WIDTH = "9" *) 
  (* C_ADDRB_WIDTH = "11" *) 
  (* C_ALGORITHM = "1" *) 
  (* C_AXI_ID_WIDTH = "4" *) 
  (* C_AXI_SLAVE_TYPE = "0" *) 
  (* C_AXI_TYPE = "1" *) 
  (* C_BYTE_SIZE = "9" *) 
  (* C_COMMON_CLK = "0" *) 
  (* C_COUNT_18K_BRAM = "0" *) 
  (* C_COUNT_36K_BRAM = "2" *) 
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
  (* C_EST_POWER_SUMMARY = "Estimated Power for IP     :     6.863192 mW" *) 
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
  (* C_INIT_FILE = "weight_bram.mem" *) 
  (* C_INIT_FILE_NAME = "no_coe_file_loaded" *) 
  (* C_INTERFACE_TYPE = "0" *) 
  (* C_LOAD_INIT_FILE = "0" *) 
  (* C_MEM_TYPE = "2" *) 
  (* C_MUX_PIPELINE_STAGES = "0" *) 
  (* C_PRIM_TYPE = "1" *) 
  (* C_READ_DEPTH_A = "512" *) 
  (* C_READ_DEPTH_B = "2048" *) 
  (* C_READ_LATENCY_A = "1" *) 
  (* C_READ_LATENCY_B = "1" *) 
  (* C_READ_WIDTH_A = "64" *) 
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
  (* C_WRITE_DEPTH_A = "512" *) 
  (* C_WRITE_DEPTH_B = "2048" *) 
  (* C_WRITE_MODE_A = "WRITE_FIRST" *) 
  (* C_WRITE_MODE_B = "WRITE_FIRST" *) 
  (* C_WRITE_WIDTH_A = "64" *) 
  (* C_WRITE_WIDTH_B = "16" *) 
  (* C_XDEVICEFAMILY = "zynquplus" *) 
  (* downgradeipidentifiedwarnings = "yes" *) 
  (* is_du_within_envelope = "true" *) 
  weight_bram_blk_mem_gen_v8_4_5 U0
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
        .s_axi_wdata({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
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
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 50688)
`pragma protect data_block
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
GDnEa/+q0r2AJlwbsC8X
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
