-- Copyright (C) 2022  Intel Corporation. All rights reserved.
-- Your use of Intel Corporation's design tools, logic functions 
-- and other software and tools, and any partner logic 
-- functions, and any output files from any of the foregoing 
-- (including device programming or simulation files), and any 
-- associated documentation or information are expressly subject 
-- to the terms and conditions of the Intel Program License 
-- Subscription Agreement, the Intel Quartus Prime License Agreement,
-- the Intel FPGA IP License Agreement, or other applicable license
-- agreement, including, without limitation, that your use is for
-- the sole purpose of programming logic devices manufactured by
-- Intel and sold by Intel or its authorized distributors.  Please
-- refer to the applicable agreement for further details, at
-- https://fpgasoftware.intel.com/eula.

-- VENDOR "Altera"
-- PROGRAM "Quartus Prime"
-- VERSION "Version 22.1std.0 Build 915 10/25/2022 SC Lite Edition"

-- DATE "08/21/2025 22:16:20"

-- 
-- Device: Altera 5CSXFC6D6F31C6 Package FBGA896
-- 

-- 
-- This VHDL file should be used for ModelSim (VHDL) only
-- 

LIBRARY ALTERA_LNSIM;
LIBRARY CYCLONEV;
LIBRARY IEEE;
USE ALTERA_LNSIM.ALTERA_LNSIM_COMPONENTS.ALL;
USE CYCLONEV.CYCLONEV_COMPONENTS.ALL;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY 	TopLevel IS
    PORT (
	A : IN std_logic_vector(3 DOWNTO 0);
	B : IN std_logic_vector(3 DOWNTO 0);
	Bin : IN std_logic;
	seg : BUFFER std_logic_vector(6 DOWNTO 0);
	Bout : BUFFER std_logic
	);
END TopLevel;

-- Design Ports Information
-- seg[0]	=>  Location: PIN_W17,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 16mA
-- seg[1]	=>  Location: PIN_V18,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 16mA
-- seg[2]	=>  Location: PIN_AG17,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 16mA
-- seg[3]	=>  Location: PIN_AG16,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 16mA
-- seg[4]	=>  Location: PIN_AH17,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 16mA
-- seg[5]	=>  Location: PIN_AG18,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 16mA
-- seg[6]	=>  Location: PIN_AH18,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 16mA
-- Bout	=>  Location: PIN_AC22,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 16mA
-- Bin	=>  Location: PIN_AC29,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: Default
-- A[0]	=>  Location: PIN_AB30,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: Default
-- B[0]	=>  Location: PIN_W25,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: Default
-- A[1]	=>  Location: PIN_Y27,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: Default
-- B[1]	=>  Location: PIN_V25,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: Default
-- A[2]	=>  Location: PIN_AB28,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: Default
-- B[2]	=>  Location: PIN_AC28,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: Default
-- A[3]	=>  Location: PIN_AC30,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: Default
-- B[3]	=>  Location: PIN_AD30,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: Default


ARCHITECTURE structure OF TopLevel IS
SIGNAL gnd : std_logic := '0';
SIGNAL vcc : std_logic := '1';
SIGNAL unknown : std_logic := 'X';
SIGNAL devoe : std_logic := '1';
SIGNAL devclrn : std_logic := '1';
SIGNAL devpor : std_logic := '1';
SIGNAL ww_devoe : std_logic;
SIGNAL ww_devclrn : std_logic;
SIGNAL ww_devpor : std_logic;
SIGNAL ww_A : std_logic_vector(3 DOWNTO 0);
SIGNAL ww_B : std_logic_vector(3 DOWNTO 0);
SIGNAL ww_Bin : std_logic;
SIGNAL ww_seg : std_logic_vector(6 DOWNTO 0);
SIGNAL ww_Bout : std_logic;
SIGNAL \~QUARTUS_CREATED_GND~I_combout\ : std_logic;
SIGNAL \B[0]~input_o\ : std_logic;
SIGNAL \A[0]~input_o\ : std_logic;
SIGNAL \B[1]~input_o\ : std_logic;
SIGNAL \Bin~input_o\ : std_logic;
SIGNAL \A[1]~input_o\ : std_logic;
SIGNAL \U1|R1|D~combout\ : std_logic;
SIGNAL \U1|R0|D~combout\ : std_logic;
SIGNAL \B[2]~input_o\ : std_logic;
SIGNAL \U1|R1|Bout~combout\ : std_logic;
SIGNAL \A[2]~input_o\ : std_logic;
SIGNAL \U1|R2|D~combout\ : std_logic;
SIGNAL \A[3]~input_o\ : std_logic;
SIGNAL \B[3]~input_o\ : std_logic;
SIGNAL \U1|R3|D~combout\ : std_logic;
SIGNAL \U2|Mux6~0_combout\ : std_logic;
SIGNAL \U2|Mux5~0_combout\ : std_logic;
SIGNAL \U2|Mux4~0_combout\ : std_logic;
SIGNAL \U2|Mux3~0_combout\ : std_logic;
SIGNAL \U2|Mux2~0_combout\ : std_logic;
SIGNAL \U2|Mux1~0_combout\ : std_logic;
SIGNAL \U2|Mux0~0_combout\ : std_logic;
SIGNAL \U1|R3|Bout~combout\ : std_logic;
SIGNAL \U1|R3|ALT_INV_D~combout\ : std_logic;
SIGNAL \ALT_INV_B[0]~input_o\ : std_logic;
SIGNAL \U1|R1|ALT_INV_D~combout\ : std_logic;
SIGNAL \U1|R0|ALT_INV_D~combout\ : std_logic;
SIGNAL \ALT_INV_Bin~input_o\ : std_logic;
SIGNAL \ALT_INV_A[2]~input_o\ : std_logic;
SIGNAL \ALT_INV_A[0]~input_o\ : std_logic;
SIGNAL \U1|R1|ALT_INV_Bout~combout\ : std_logic;
SIGNAL \ALT_INV_A[3]~input_o\ : std_logic;
SIGNAL \U1|R2|ALT_INV_D~combout\ : std_logic;
SIGNAL \ALT_INV_B[3]~input_o\ : std_logic;
SIGNAL \ALT_INV_B[1]~input_o\ : std_logic;
SIGNAL \ALT_INV_A[1]~input_o\ : std_logic;
SIGNAL \ALT_INV_B[2]~input_o\ : std_logic;
SIGNAL \U2|ALT_INV_Mux0~0_combout\ : std_logic;

BEGIN

ww_A <= A;
ww_B <= B;
ww_Bin <= Bin;
seg <= ww_seg;
Bout <= ww_Bout;
ww_devoe <= devoe;
ww_devclrn <= devclrn;
ww_devpor <= devpor;
\U1|R3|ALT_INV_D~combout\ <= NOT \U1|R3|D~combout\;
\ALT_INV_B[0]~input_o\ <= NOT \B[0]~input_o\;
\U1|R1|ALT_INV_D~combout\ <= NOT \U1|R1|D~combout\;
\U1|R0|ALT_INV_D~combout\ <= NOT \U1|R0|D~combout\;
\ALT_INV_Bin~input_o\ <= NOT \Bin~input_o\;
\ALT_INV_A[2]~input_o\ <= NOT \A[2]~input_o\;
\ALT_INV_A[0]~input_o\ <= NOT \A[0]~input_o\;
\U1|R1|ALT_INV_Bout~combout\ <= NOT \U1|R1|Bout~combout\;
\ALT_INV_A[3]~input_o\ <= NOT \A[3]~input_o\;
\U1|R2|ALT_INV_D~combout\ <= NOT \U1|R2|D~combout\;
\ALT_INV_B[3]~input_o\ <= NOT \B[3]~input_o\;
\ALT_INV_B[1]~input_o\ <= NOT \B[1]~input_o\;
\ALT_INV_A[1]~input_o\ <= NOT \A[1]~input_o\;
\ALT_INV_B[2]~input_o\ <= NOT \B[2]~input_o\;
\U2|ALT_INV_Mux0~0_combout\ <= NOT \U2|Mux0~0_combout\;

-- Location: IOOBUF_X60_Y0_N19
\seg[0]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \U2|Mux6~0_combout\,
	devoe => ww_devoe,
	o => ww_seg(0));

-- Location: IOOBUF_X80_Y0_N2
\seg[1]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \U2|Mux5~0_combout\,
	devoe => ww_devoe,
	o => ww_seg(1));

-- Location: IOOBUF_X50_Y0_N93
\seg[2]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \U2|Mux4~0_combout\,
	devoe => ww_devoe,
	o => ww_seg(2));

-- Location: IOOBUF_X50_Y0_N76
\seg[3]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \U2|Mux3~0_combout\,
	devoe => ww_devoe,
	o => ww_seg(3));

-- Location: IOOBUF_X56_Y0_N36
\seg[4]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \U2|Mux2~0_combout\,
	devoe => ww_devoe,
	o => ww_seg(4));

-- Location: IOOBUF_X58_Y0_N76
\seg[5]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \U2|Mux1~0_combout\,
	devoe => ww_devoe,
	o => ww_seg(5));

-- Location: IOOBUF_X56_Y0_N53
\seg[6]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \U2|ALT_INV_Mux0~0_combout\,
	devoe => ww_devoe,
	o => ww_seg(6));

-- Location: IOOBUF_X86_Y0_N2
\Bout~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \U1|R3|Bout~combout\,
	devoe => ww_devoe,
	o => ww_Bout);

-- Location: IOIBUF_X89_Y20_N44
\B[0]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_B(0),
	o => \B[0]~input_o\);

-- Location: IOIBUF_X89_Y21_N4
\A[0]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_A(0),
	o => \A[0]~input_o\);

-- Location: IOIBUF_X89_Y20_N61
\B[1]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_B(1),
	o => \B[1]~input_o\);

-- Location: IOIBUF_X89_Y20_N95
\Bin~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_Bin,
	o => \Bin~input_o\);

-- Location: IOIBUF_X89_Y25_N21
\A[1]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_A(1),
	o => \A[1]~input_o\);

-- Location: LABCELL_X83_Y16_N39
\U1|R1|D\ : cyclonev_lcell_comb
-- Equation(s):
-- \U1|R1|D~combout\ = ( \Bin~input_o\ & ( \A[1]~input_o\ & ( !\B[1]~input_o\ $ (((!\A[0]~input_o\) # (\B[0]~input_o\))) ) ) ) # ( !\Bin~input_o\ & ( \A[1]~input_o\ & ( !\B[1]~input_o\ $ (((\B[0]~input_o\ & !\A[0]~input_o\))) ) ) ) # ( \Bin~input_o\ & ( 
-- !\A[1]~input_o\ & ( !\B[1]~input_o\ $ (((!\B[0]~input_o\ & \A[0]~input_o\))) ) ) ) # ( !\Bin~input_o\ & ( !\A[1]~input_o\ & ( !\B[1]~input_o\ $ (((!\B[0]~input_o\) # (\A[0]~input_o\))) ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0101000010101111111101010000101010101111010100000000101011110101",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_B[0]~input_o\,
	datac => \ALT_INV_A[0]~input_o\,
	datad => \ALT_INV_B[1]~input_o\,
	datae => \ALT_INV_Bin~input_o\,
	dataf => \ALT_INV_A[1]~input_o\,
	combout => \U1|R1|D~combout\);

-- Location: LABCELL_X83_Y16_N30
\U1|R0|D\ : cyclonev_lcell_comb
-- Equation(s):
-- \U1|R0|D~combout\ = ( \Bin~input_o\ & ( !\A[0]~input_o\ $ (\B[0]~input_o\) ) ) # ( !\Bin~input_o\ & ( !\A[0]~input_o\ $ (!\B[0]~input_o\) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0011110000111100110000111100001100111100001111001100001111000011",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	datab => \ALT_INV_A[0]~input_o\,
	datac => \ALT_INV_B[0]~input_o\,
	datae => \ALT_INV_Bin~input_o\,
	combout => \U1|R0|D~combout\);

-- Location: IOIBUF_X89_Y20_N78
\B[2]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_B(2),
	o => \B[2]~input_o\);

-- Location: LABCELL_X83_Y16_N42
\U1|R1|Bout\ : cyclonev_lcell_comb
-- Equation(s):
-- \U1|R1|Bout~combout\ = ( \Bin~input_o\ & ( \A[1]~input_o\ & ( (\B[1]~input_o\ & ((!\A[0]~input_o\) # (\B[0]~input_o\))) ) ) ) # ( !\Bin~input_o\ & ( \A[1]~input_o\ & ( (\B[1]~input_o\ & (!\A[0]~input_o\ & \B[0]~input_o\)) ) ) ) # ( \Bin~input_o\ & ( 
-- !\A[1]~input_o\ & ( ((!\A[0]~input_o\) # (\B[0]~input_o\)) # (\B[1]~input_o\) ) ) ) # ( !\Bin~input_o\ & ( !\A[1]~input_o\ & ( ((!\A[0]~input_o\ & \B[0]~input_o\)) # (\B[1]~input_o\) ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0101110101011101110111111101111100000100000001000100010101000101",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_B[1]~input_o\,
	datab => \ALT_INV_A[0]~input_o\,
	datac => \ALT_INV_B[0]~input_o\,
	datae => \ALT_INV_Bin~input_o\,
	dataf => \ALT_INV_A[1]~input_o\,
	combout => \U1|R1|Bout~combout\);

-- Location: IOIBUF_X89_Y21_N38
\A[2]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_A(2),
	o => \A[2]~input_o\);

-- Location: LABCELL_X83_Y16_N21
\U1|R2|D\ : cyclonev_lcell_comb
-- Equation(s):
-- \U1|R2|D~combout\ = ( \A[2]~input_o\ & ( !\B[2]~input_o\ $ (\U1|R1|Bout~combout\) ) ) # ( !\A[2]~input_o\ & ( !\B[2]~input_o\ $ (!\U1|R1|Bout~combout\) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0011110000111100110000111100001100111100001111001100001111000011",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	datab => \ALT_INV_B[2]~input_o\,
	datac => \U1|R1|ALT_INV_Bout~combout\,
	datae => \ALT_INV_A[2]~input_o\,
	combout => \U1|R2|D~combout\);

-- Location: IOIBUF_X89_Y25_N55
\A[3]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_A(3),
	o => \A[3]~input_o\);

-- Location: IOIBUF_X89_Y25_N38
\B[3]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_B(3),
	o => \B[3]~input_o\);

-- Location: LABCELL_X83_Y16_N24
\U1|R3|D\ : cyclonev_lcell_comb
-- Equation(s):
-- \U1|R3|D~combout\ = ( \A[2]~input_o\ & ( \B[3]~input_o\ & ( !\A[3]~input_o\ $ (((\U1|R1|Bout~combout\ & \B[2]~input_o\))) ) ) ) # ( !\A[2]~input_o\ & ( \B[3]~input_o\ & ( !\A[3]~input_o\ $ (((\B[2]~input_o\) # (\U1|R1|Bout~combout\))) ) ) ) # ( 
-- \A[2]~input_o\ & ( !\B[3]~input_o\ & ( !\A[3]~input_o\ $ (((!\U1|R1|Bout~combout\) # (!\B[2]~input_o\))) ) ) ) # ( !\A[2]~input_o\ & ( !\B[3]~input_o\ & ( !\A[3]~input_o\ $ (((!\U1|R1|Bout~combout\ & !\B[2]~input_o\))) ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0011110011110000000011110011110011000011000011111111000011000011",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	datab => \U1|R1|ALT_INV_Bout~combout\,
	datac => \ALT_INV_A[3]~input_o\,
	datad => \ALT_INV_B[2]~input_o\,
	datae => \ALT_INV_A[2]~input_o\,
	dataf => \ALT_INV_B[3]~input_o\,
	combout => \U1|R3|D~combout\);

-- Location: LABCELL_X83_Y16_N0
\U2|Mux6~0\ : cyclonev_lcell_comb
-- Equation(s):
-- \U2|Mux6~0_combout\ = ( \U1|R3|D~combout\ & ( (\U1|R0|D~combout\ & (!\U1|R1|D~combout\ $ (!\U1|R2|D~combout\))) ) ) # ( !\U1|R3|D~combout\ & ( (!\U1|R1|D~combout\ & (!\U1|R0|D~combout\ $ (!\U1|R2|D~combout\))) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0010100000101000001010000010100000010010000100100001001000010010",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \U1|R1|ALT_INV_D~combout\,
	datab => \U1|R0|ALT_INV_D~combout\,
	datac => \U1|R2|ALT_INV_D~combout\,
	dataf => \U1|R3|ALT_INV_D~combout\,
	combout => \U2|Mux6~0_combout\);

-- Location: LABCELL_X83_Y16_N6
\U2|Mux5~0\ : cyclonev_lcell_comb
-- Equation(s):
-- \U2|Mux5~0_combout\ = ( \U1|R0|D~combout\ & ( (!\U1|R1|D~combout\ & (\U1|R2|D~combout\ & !\U1|R3|D~combout\)) # (\U1|R1|D~combout\ & ((\U1|R3|D~combout\))) ) ) # ( !\U1|R0|D~combout\ & ( (\U1|R2|D~combout\ & ((\U1|R3|D~combout\) # (\U1|R1|D~combout\))) ) 
-- )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0001010100010101000101010001010101000011010000110100001101000011",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \U1|R2|ALT_INV_D~combout\,
	datab => \U1|R1|ALT_INV_D~combout\,
	datac => \U1|R3|ALT_INV_D~combout\,
	dataf => \U1|R0|ALT_INV_D~combout\,
	combout => \U2|Mux5~0_combout\);

-- Location: LABCELL_X83_Y16_N3
\U2|Mux4~0\ : cyclonev_lcell_comb
-- Equation(s):
-- \U2|Mux4~0_combout\ = ( \U1|R3|D~combout\ & ( (\U1|R2|D~combout\ & ((!\U1|R0|D~combout\) # (\U1|R1|D~combout\))) ) ) # ( !\U1|R3|D~combout\ & ( (\U1|R1|D~combout\ & (!\U1|R0|D~combout\ & !\U1|R2|D~combout\)) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0101000000000000010100000000000000000000111101010000000011110101",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \U1|R1|ALT_INV_D~combout\,
	datac => \U1|R0|ALT_INV_D~combout\,
	datad => \U1|R2|ALT_INV_D~combout\,
	dataf => \U1|R3|ALT_INV_D~combout\,
	combout => \U2|Mux4~0_combout\);

-- Location: LABCELL_X83_Y16_N12
\U2|Mux3~0\ : cyclonev_lcell_comb
-- Equation(s):
-- \U2|Mux3~0_combout\ = ( \U1|R3|D~combout\ & ( (\U1|R1|D~combout\ & (!\U1|R0|D~combout\ $ (\U1|R2|D~combout\))) ) ) # ( !\U1|R3|D~combout\ & ( (!\U1|R1|D~combout\ & (!\U1|R0|D~combout\ $ (!\U1|R2|D~combout\))) # (\U1|R1|D~combout\ & (\U1|R0|D~combout\ & 
-- \U1|R2|D~combout\)) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0010100100101001001010010010100101000001010000010100000101000001",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \U1|R1|ALT_INV_D~combout\,
	datab => \U1|R0|ALT_INV_D~combout\,
	datac => \U1|R2|ALT_INV_D~combout\,
	dataf => \U1|R3|ALT_INV_D~combout\,
	combout => \U2|Mux3~0_combout\);

-- Location: LABCELL_X83_Y16_N15
\U2|Mux2~0\ : cyclonev_lcell_comb
-- Equation(s):
-- \U2|Mux2~0_combout\ = ( \U1|R3|D~combout\ & ( (!\U1|R1|D~combout\ & (\U1|R0|D~combout\ & !\U1|R2|D~combout\)) ) ) # ( !\U1|R3|D~combout\ & ( ((!\U1|R1|D~combout\ & \U1|R2|D~combout\)) # (\U1|R0|D~combout\) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000111110101111000011111010111100001010000000000000101000000000",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \U1|R1|ALT_INV_D~combout\,
	datac => \U1|R0|ALT_INV_D~combout\,
	datad => \U1|R2|ALT_INV_D~combout\,
	dataf => \U1|R3|ALT_INV_D~combout\,
	combout => \U2|Mux2~0_combout\);

-- Location: LABCELL_X83_Y16_N48
\U2|Mux1~0\ : cyclonev_lcell_comb
-- Equation(s):
-- \U2|Mux1~0_combout\ = ( \U1|R3|D~combout\ & ( (!\U1|R1|D~combout\ & (\U1|R0|D~combout\ & \U1|R2|D~combout\)) ) ) # ( !\U1|R3|D~combout\ & ( (!\U1|R1|D~combout\ & (\U1|R0|D~combout\ & !\U1|R2|D~combout\)) # (\U1|R1|D~combout\ & ((!\U1|R2|D~combout\) # 
-- (\U1|R0|D~combout\))) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0111000101110001011100010111000100000010000000100000001000000010",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \U1|R1|ALT_INV_D~combout\,
	datab => \U1|R0|ALT_INV_D~combout\,
	datac => \U1|R2|ALT_INV_D~combout\,
	dataf => \U1|R3|ALT_INV_D~combout\,
	combout => \U2|Mux1~0_combout\);

-- Location: LABCELL_X83_Y16_N51
\U2|Mux0~0\ : cyclonev_lcell_comb
-- Equation(s):
-- \U2|Mux0~0_combout\ = ( \U1|R3|D~combout\ & ( ((!\U1|R2|D~combout\) # (\U1|R0|D~combout\)) # (\U1|R1|D~combout\) ) ) # ( !\U1|R3|D~combout\ & ( (!\U1|R1|D~combout\ & ((\U1|R2|D~combout\))) # (\U1|R1|D~combout\ & ((!\U1|R0|D~combout\) # 
-- (!\U1|R2|D~combout\))) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0101010111101110010101011110111011111111011101111111111101110111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \U1|R1|ALT_INV_D~combout\,
	datab => \U1|R0|ALT_INV_D~combout\,
	datad => \U1|R2|ALT_INV_D~combout\,
	dataf => \U1|R3|ALT_INV_D~combout\,
	combout => \U2|Mux0~0_combout\);

-- Location: LABCELL_X83_Y16_N57
\U1|R3|Bout\ : cyclonev_lcell_comb
-- Equation(s):
-- \U1|R3|Bout~combout\ = ( \A[2]~input_o\ & ( \B[3]~input_o\ & ( (!\A[3]~input_o\) # ((\B[2]~input_o\ & \U1|R1|Bout~combout\)) ) ) ) # ( !\A[2]~input_o\ & ( \B[3]~input_o\ & ( (!\A[3]~input_o\) # ((\U1|R1|Bout~combout\) # (\B[2]~input_o\)) ) ) ) # ( 
-- \A[2]~input_o\ & ( !\B[3]~input_o\ & ( (!\A[3]~input_o\ & (\B[2]~input_o\ & \U1|R1|Bout~combout\)) ) ) ) # ( !\A[2]~input_o\ & ( !\B[3]~input_o\ & ( (!\A[3]~input_o\ & ((\U1|R1|Bout~combout\) # (\B[2]~input_o\))) ) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0010101000101010000000100000001010111111101111111010101110101011",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_A[3]~input_o\,
	datab => \ALT_INV_B[2]~input_o\,
	datac => \U1|R1|ALT_INV_Bout~combout\,
	datae => \ALT_INV_A[2]~input_o\,
	dataf => \ALT_INV_B[3]~input_o\,
	combout => \U1|R3|Bout~combout\);

-- Location: LABCELL_X40_Y67_N0
\~QUARTUS_CREATED_GND~I\ : cyclonev_lcell_comb
-- Equation(s):

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000000000000000000000000000000000000000000000000000000000",
	shared_arith => "off")
-- pragma translate_on
;
END structure;


