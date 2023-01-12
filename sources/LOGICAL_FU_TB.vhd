--------------------------------------------------------------------------------
-- Engineer:		JASON GEORGAKAS
--
-- Create Date:		11/04/2022
-- Design Name:		behv
-- Module Name:		LOGICAL_FU_TB.vhd
-- Project Name:	Tomasulo_v1.00
-- Tool versions:	ISE Project Navigator & ISim (P.20131013)
-- Description:
-- 
-- VHDL Test Bench Created by the author for module: LOGICAL_FU
-- 
-- Dependencies:	LOGICAL_FU
-- 
-- Revision:
-- Revision 1.00 - TB is ready
--------------------------------------------------------------------------------
USE WORK.common.ALL;
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
--------------------------------------------------------------------------------
ENTITY LOGICAL_FU_TB IS
GENERIC(
	reg_size : INTEGER := 16;
	op_width : INTEGER := 3
);
END LOGICAL_FU_TB;
--------------------------------------------------------------------------------
ARCHITECTURE behv OF LOGICAL_FU_TB IS

	-- Component Declaration for the Unit Under Test (UUT)
	COMPONENT LOGICAL_FU
	GENERIC(
		reg_size	: INTEGER := 16;
		op_width	: INTEGER := 3
	);
	PORT(
		CLK		: IN STD_LOGIC;
		RST		: IN STD_LOGIC;
		WrEn	: IN STD_LOGIC;

		A		: IN STD_LOGIC_VECTOR(reg_size-1 DOWNTO 0);
		B		: IN STD_LOGIC_VECTOR(reg_size-1 DOWNTO 0);
		Op		: IN STD_LOGIC_VECTOR(op_width-1 DOWNTO 0);

		Result	: OUT STD_LOGIC_VECTOR(reg_size-1 DOWNTO 0)
	);
	END COMPONENT;

	-- Inputs
	SIGNAL CLK		: STD_LOGIC;
	SIGNAL RST		: STD_LOGIC := '0';
	SIGNAL WrEn		: STD_LOGIC := '0';
	SIGNAL A		: STD_LOGIC_VECTOR(reg_size-1 DOWNTO 0) := (OTHERS => '0');
	SIGNAL B		: STD_LOGIC_VECTOR(reg_size-1 DOWNTO 0) := (OTHERS => '0');
	SIGNAL Op		: STD_LOGIC_VECTOR(op_width-1 DOWNTO 0) := (OTHERS => '0');

	-- Outputs
	SIGNAL Result	: STD_LOGIC_VECTOR(reg_size-1 DOWNTO 0);

BEGIN

	-- Instantiate the Unit Under Test (UUT)
	uut : LOGICAL_FU
	GENERIC MAP(
		reg_size => reg_size,
		op_width => op_width
	)
	PORT MAP(
		CLK		=> CLK,
		RST		=> RST,
		WrEn	=> WrEn,

		A		=> A,
		B		=> B,
		Op		=> Op,

		Result	=> Result
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
		-- hold reset state for 100 ns.
		RST <= '0';
		WAIT FOR cc;

		RST <= '1';
		WAIT FOR cc;

		-- OR OPERATION
		Op <= "001";
		A <= "0000000000000001";
		B <= "0000000000000011";
		WAIT FOR cc;

		WrEn <= '1';
		WAIT FOR cc;

		-- AND OPERATION
		Op <= "010";
		A <= "0000000000000001";
		B <= "0000000000000011";
		WAIT FOR cc;

		-- NOT OPERATION
		Op <= "011";
		A <= "0000000000000001";
		B <= "0000000000000011";
		WAIT FOR cc;

		-- NOT OPERATION
		Op <= "011";
		A <= "0000000000000000";
		B <= "0000000000000000";
		WAIT FOR cc;

		-- AND OPERATION
		Op <= "010";
		A <= "0000000000000001";
		B <= "0000000000100011";
		WAIT FOR cc;

		WAIT;
	END PROCESS;

END;
--------------------------------------------------------------------------------