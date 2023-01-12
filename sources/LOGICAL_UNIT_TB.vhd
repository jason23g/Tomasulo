--------------------------------------------------------------------------------
-- Engineer:		PANOS VASILEIOU
--
-- Create Date:		12/04/2022
-- Design Name:		behv
-- Module Name:		LOGICAL_UNIT_TB.vhd
-- Project Name:	Tomasulo_v1.00
-- Tool versions:	ISE Project Navigator & ISim (P.20131013)
-- Description:
-- 
-- VHDL Test Bench Created by the author for module: LOGICAL_UNIT
-- 
-- Dependencies:	LOGICAL_UNIT, common
-- 
-- Revision:
-- Revision 1.00 - Ready
--------------------------------------------------------------------------------
USE WORK.common.ALL;
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
--------------------------------------------------------------------------------
ENTITY LOGICAL_UNIT_TB IS
GENERIC(
	reg_size	: INTEGER := 16;
	rs_width	: INTEGER := 3;
	op_width	: INTEGER := 3
);
END LOGICAL_UNIT_TB;
--------------------------------------------------------------------------------
ARCHITECTURE behv OF LOGICAL_UNIT_TB IS

	-- Component Declaration
	COMPONENT LOGICAL_UNIT
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
		ReqOut	: OUT STD_LOGIC
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

BEGIN

	-- Component Instantiation
	uut : LOGICAL_UNIT
	GENERIC MAP(
		reg_size => reg_size,
		op_width => op_width,
		rs_width => rs_width
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
		ReqOut	=> ReqOut,
		TagOut	=> TagOut
	);

	-- Clock process definitions
	CLK_process : PROCESS
	BEGIN
		CLK <= '0';
		WAIT FOR cc/2;
		CLK <= '1';
		WAIT FOR cc/2;
	END PROCESS;

	-- Stimulus process
	stim_proc : PROCESS
	BEGIN
		-- hold reset state for cc.
		RST <= '0';
		WAIT FOR cc;

		-- OR OPERATION
		RST		<= '1';
		WrEn	<= '1';
		ReqIn	<= '1';
		Tag		<= "001";
		Op		<= "001";
		A 		<= "0000000000000001";
		B 		<= "0000000000000011";
		WAIT FOR cc;

		-- AND OPERATION
		WrEn	<= '1';
		ReqIn	<= '1';
		Tag		<= "001";
		Op		<= "010";
		A 		<= "0000000000000001";
		B 		<= "0000000000000011";
		WAIT FOR cc;

		-- NOT OPERATION
		WrEn	<= '1';
		ReqIn	<= '1';
		Tag		<= "001";
		Op		<= "011";
		A 		<= "0000000000000001";
		B 		<= "0000000000000011";
		WAIT FOR cc;

		-- NOT OPERATION
		WrEn	<= '1';
		ReqIn	<= '0';
		Tag		<= "001";
		Op		<= "011";
		A 		<= "0000000000000000";
		B 		<= "0000000000000000";
		WAIT FOR cc;

		-- AND OPERATION
		WrEn	<= '0';
		ReqIn	<= '0';
		Tag		<= "010";
		Op		<= "010";
		A 		<= "0000000000000001";
		B 		<= "0000000000100011";
		WAIT FOR cc;

		WAIT; -- will wait forever
	END PROCESS; -- stim_proc

END;
--------------------------------------------------------------------------------