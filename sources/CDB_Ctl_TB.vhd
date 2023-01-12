--------------------------------------------------------------------------------
-- Engineer:		PANOS VASILEIOU
-- 
-- Create Date:		14/04/2022
-- Module Name:		CDB_Ctl_TB.vhd - behv
-- Project Name:	Tomasulo_v1.00
-- Tool versions:	ISE Project Navigator & ISim (P.20131013)
-- Description:
-- 
-- VHDL Test Bench Created by the author for module: CDB_Ctl
-- 
-- Dependencies:	CDB_Ctl
-- 
-- Revision:
-- Revision 1.00 - Tested
--------------------------------------------------------------------------------
USE WORK.common.ALL;
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
--------------------------------------------------------------------------------
ENTITY CDB_Ctl_TB IS
END CDB_Ctl_TB;
--------------------------------------------------------------------------------
ARCHITECTURE behv OF CDB_Ctl_TB IS 

	-- Component Declaration for the Unit Under Test (UUT)
	COMPONENT CDB_Ctl
	PORT(
		CLK 		: IN STD_LOGIC;
		RST			: IN STD_LOGIC;
		DEV_REQ		: IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		DEV_GRANT	: OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
	);
	END COMPONENT;

	-- Inputs
	SIGNAL CLK			: STD_LOGIC := '0';
	SIGNAL RST			: STD_LOGIC := '0';
	SIGNAL DEV_REQ		: STD_LOGIC_VECTOR(3 DOWNTO 0) := (OTHERS => '0');

	-- Outputs
	SIGNAL DEV_GRANT	: STD_LOGIC_VECTOR(3 DOWNTO 0);

BEGIN

	-- Instantiate the Unit Under Test (UUT)
	uut : CDB_Ctl
	PORT MAP(
		CLK			=> CLK,
		RST			=> RST,
		DEV_REQ		=> DEV_REQ,
		DEV_GRANT	=> DEV_GRANT
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
	DEV_REQ <= "0000";
	WAIT FOR CLK_period;

	DEV_REQ <= "1110";
	WAIT FOR CLK_period;

	DEV_REQ <= "0001";
	WAIT FOR CLK_period;

	DEV_REQ <= "0011";
	WAIT FOR CLK_period;

	DEV_REQ <= "0111";
	WAIT FOR CLK_period;

	DEV_REQ <= "0010";
	WAIT FOR CLK_period;

	DEV_REQ <= "0011";
	WAIT FOR CLK_period;

	DEV_REQ <= "0010";
	WAIT FOR CLK_period;

	DEV_REQ <= "0111";
	WAIT FOR CLK_period;

	DEV_REQ <= "0110";
	WAIT FOR CLK_period;

	RST <= '0';
	WAIT FOR CLK_period;

	RST <= '1';
	DEV_REQ <= "0000";
	WAIT FOR CLK_period;

	DEV_REQ <= "0111";
	WAIT FOR CLK_period*6;

	RST <= '0';
	WAIT FOR CLK_period;

	WAIT;
	END PROCESS;

END;
--------------------------------------------------------------------------------