--------------------------------------------------------------------------------
-- Engineer:		PANOS VASILEIOU
-- 
-- Create Date:		12/04/2022
-- Module Name:		ARITHMETIC_UNIT.vhd - behv
-- Project Name:	Tomasulo_v1.00
-- Tool versions:	ISE Project Navigator & ISim (P.20131013)
-- Description:
-- 
-- VHDL Test Bench Created by the author for module: ARITHMETIC_UNIT
-- 
-- Dependencies:	ARITHMETIC_UNIT, common
-- 
-- Revision:
-- Revision 0.01 - File Created
--------------------------------------------------------------------------------
USE WORK.common.ALL;
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
--------------------------------------------------------------------------------
ENTITY ARITHMETIC_UNIT_TB IS
GENERIC(
	reg_size	: INTEGER := 16;
	rs_width	: INTEGER := 3;
	op_width	: INTEGER := 3
);
END ARITHMETIC_UNIT_TB;
--------------------------------------------------------------------------------
ARCHITECTURE behv OF ARITHMETIC_UNIT_TB IS

	-- Component Declaration for the Unit Under Test (UUT)
	COMPONENT ARITHMETIC_UNIT
	GENERIC(
		reg_size	: INTEGER := 16;
		rs_width	: INTEGER := 3;
		op_width	: INTEGER := 3
	);
	PORT(
		CLK		: IN STD_LOGIC;
		RST		: IN STD_LOGIC;
		WrEn	: IN STD_LOGIC;

		ReqIn	: IN STD_LOGIC;
		Tag		: IN STD_LOGIC_VECTOR(rs_width-1 DOWNTO 0);

		A		: IN STD_LOGIC_VECTOR(reg_size-1 DOWNTO 0);
		B		: IN STD_LOGIC_VECTOR(reg_size-1 DOWNTO 0);
		Op		: IN STD_LOGIC_VECTOR(op_width-1 DOWNTO 0);

		Result	: OUT STD_LOGIC_VECTOR(reg_size-1 DOWNTO 0);
		TagOut	: OUT STD_LOGIC_VECTOR(rs_width-1 DOWNTO 0);
		ReqOut	: OUT STD_LOGIC;

		Cout	: OUT STD_LOGIC;
		Ovf		: OUT STD_LOGIC;
		Zero	: OUT STD_LOGIC
	);
	END COMPONENT;

	-- Inputs
	SIGNAL CLK		: STD_LOGIC := '0';
	SIGNAL RST		: STD_LOGIC := '0';
	SIGNAL WrEn		: STD_LOGIC := '0';

	SIGNAL ReqIn	: STD_LOGIC := '0';
	SIGNAL Tag		: STD_LOGIC_VECTOR(rs_width-1 DOWNTO 0) := (OTHERS => '0');

	SIGNAL A		: STD_LOGIC_VECTOR(reg_size-1 DOWNTO 0) := (OTHERS => '0');
	SIGNAL B		: STD_LOGIC_VECTOR(reg_size-1 DOWNTO 0) := (OTHERS => '0');
	SIGNAL Op		: STD_LOGIC_VECTOR(op_width-1 DOWNTO 0) := (OTHERS => '0');

	-- Outputs
	SIGNAL Result	: STD_LOGIC_VECTOR(reg_size-1 DOWNTO 0);
	SIGNAL TagOut	: STD_LOGIC_VECTOR(rs_width-1 DOWNTO 0);
	SIGNAL ReqOut	: STD_LOGIC;
	SIGNAL Cout		: STD_LOGIC;
	SIGNAL Ovf		: STD_LOGIC;
	SIGNAL Zero		: STD_LOGIC;

BEGIN

	-- Instantiate the Unit Under Test (UUT)
	uut : ARITHMETIC_UNIT
	GENERIC MAP(
		reg_size => reg_size,
		rs_width => rs_width,
		op_width => op_width
	)
	PORT MAP(
		CLK		=> CLK,
		RST		=> RST,
		WrEn	=> WrEn,
		ReqIn	=> ReqIn,
		Tag		=> Tag,
		A		=> A,
		B		=> B,
		Op		=> Op,
		Result	=> Result,
		TagOut	=> TagOut,
		ReqOut	=> ReqOut,
		Cout	=> Cout,
		Ovf		=> Ovf,
		Zero	=> Zero
	);

	-- Clock process definitions
	CLK_process : PROCESS
	BEGIN
		CLK <= '0';
		WAIT FOR CLK_period/2;
		CLK <= '1';
		WAIT FOR CLK_period/2;
	END PROCESS;

	-- Stimulus process
	stim_proc : PROCESS
	BEGIN
		-- hold reset state for 100 ns.
		RST <= '0';
		WAIT FOR CLK_period;

		-- insert stimulus here
		RST <= '1';

		-- sub
		WrEn	<= '1';
		ReqIn	<= '1';
		Op		<= "101";
		A		<= "1111111111111111";
		B		<= "0000000000000011";
		Tag		<= "001";
		WAIT FOR CLK_period;

		-- add
		WrEn	<= '1';
		ReqIn	<= '1';
		Op		<= "100";
		A		<= "1000000000000001";
		B		<= "0010110000000011";
		Tag		<= "001";
		WAIT FOR CLK_period;

		-- add
		WrEn	<= '1';
		ReqIn	<= '1';
		Tag		<= "101";
		Op		<= "100";
		A		<= "1000000000000001";
		B		<= "0000000000000011";
		WAIT FOR CLK_period;

		-- sub
		WrEn	<= '1';
		ReqIn	<= '1';
		Op		<= "101";
		A		<= "0000111100011000";
		B		<= "0000000000000000";
		Tag		<= "101";
		WAIT FOR CLK_period;

		-- add
		WrEn	<= '1';
		ReqIn	<= '1';
		Op		<= "100";
		A		<= "0000000000000001";
		B		<= "0000000000100011";
		Tag		<= "100";
		WAIT FOR CLK_period;

		WrEn	<= '1';
		ReqIn	<= '0';
		Tag		<= "000";
		WAIT FOR CLK_period*2;

		WrEn	<= '0';

		WAIT; -- will wait forever
	END PROCESS; -- stim_proc

END;
--------------------------------------------------------------------------------