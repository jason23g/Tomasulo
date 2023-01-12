--------------------------------------------------------------------------------
-- Engineer:		JASON GEORGAKAS, PANOS VASILEIOU
-- 
-- Create Date:		14/04/2022
-- Module Name:		CDB_Data_TB.vhd - behv
-- Project Name:	Tomasulo_v1.00
-- Tool versions:	ISE Project Navigator & ISim (P.20131013)
-- Description:
-- 
-- VHDL Test Bench Created by the authors for module: CDB_Data
-- 
-- Dependencies:	CDB_Data
-- 
-- Revision:
-- Revision 1.00 - Ready
--------------------------------------------------------------------------------
USE WORK.common.ALL;
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
--------------------------------------------------------------------------------
ENTITY CDB_Data_TB IS
GENERIC(
	N			: INTEGER := 16;
	Q			: INTEGER := 3
);
END CDB_Data_TB;
--------------------------------------------------------------------------------
ARCHITECTURE behv OF CDB_Data_TB IS

	-- Component Declaration for the Unit Under Test (UUT)
	COMPONENT CDB_Data
	GENERIC(
		N			: INTEGER := 16;
		Q			: INTEGER := 3
	);
	PORT(
		DEV1_VAL_IN	: IN  STD_LOGIC_VECTOR(N-1 DOWNTO 0);
		DEV2_VAL_IN	: IN  STD_LOGIC_VECTOR(N-1 DOWNTO 0);
		DEV3_VAL_IN	: IN  STD_LOGIC_VECTOR(N-1 DOWNTO 0);

		DEV1_Q_IN	: IN  STD_LOGIC_VECTOR(Q-1 DOWNTO 0);
		DEV2_Q_IN	: IN  STD_LOGIC_VECTOR(Q-1 DOWNTO 0);
		DEV3_Q_IN	: IN  STD_LOGIC_VECTOR(Q-1 DOWNTO 0);

		DEV_GRANT	: IN  STD_LOGIC_VECTOR(2 DOWNTO 0);

		DEV_VAL_OUT	: OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0);
		DEV_Q_OUT	: OUT STD_LOGIC_VECTOR(Q-1 DOWNTO 0)
	);
	END COMPONENT;

	-- Inputs
	SIGNAL DEV1_VAL_IN	: STD_LOGIC_VECTOR(N-1 DOWNTO 0) := (OTHERS => '0');
	SIGNAL DEV2_VAL_IN	: STD_LOGIC_VECTOR(N-1 DOWNTO 0) := (OTHERS => '0');
	SIGNAL DEV3_VAL_IN	: STD_LOGIC_VECTOR(N-1 DOWNTO 0) := (OTHERS => '0');
	SIGNAL DEV1_Q_IN	: STD_LOGIC_VECTOR(Q-1 DOWNTO 0) := (OTHERS => '0');
	SIGNAL DEV2_Q_IN	: STD_LOGIC_VECTOR(Q-1 DOWNTO 0) := (OTHERS => '0');
	SIGNAL DEV3_Q_IN	: STD_LOGIC_VECTOR(Q-1 DOWNTO 0) := (OTHERS => '0');
	SIGNAL DEV_GRANT	: STD_LOGIC_VECTOR(2 DOWNTO 0) := (OTHERS => '0');

	-- Outputs
	SIGNAL DEV_VAL_OUT	: STD_LOGIC_VECTOR(N-1 DOWNTO 0);
	SIGNAL DEV_Q_OUT	: STD_LOGIC_VECTOR(2 DOWNTO 0);

BEGIN

	-- Instantiate the Unit Under Test (UUT)
	uut : CDB_Data
	GENERIC MAP(
		N			=> N,
		Q			=> Q
	)
	PORT MAP(
		DEV1_VAL_IN	=> DEV1_VAL_IN,
		DEV2_VAL_IN	=> DEV2_VAL_IN,
		DEV3_VAL_IN	=> DEV3_VAL_IN,
		DEV1_Q_IN	=> DEV1_Q_IN,
		DEV2_Q_IN	=> DEV2_Q_IN,
		DEV3_Q_IN	=> DEV3_Q_IN,
		DEV_GRANT	=> DEV_GRANT,
		DEV_VAL_OUT	=> DEV_VAL_OUT,
		DEV_Q_OUT	=> DEV_Q_OUT
	);

	-- Stimulus process
	stim_proc : PROCESS
	BEGIN
		-- hold reset state for 100 ns.
		WAIT FOR 100 ns;

		-- insert stimulus here 
		DEV1_VAL_IN	<= x"B00B";
		DEV2_VAL_IN	<= x"0420";
		DEV3_VAL_IN	<= x"6969";
		DEV1_Q_IN	<= "001";
		DEV2_Q_IN	<= "010";
		DEV3_Q_IN	<= "100";

		-- zero
		DEV_GRANT	<= "000";
		WAIT FOR 100 ns;

		-- dev.1 gets access
		DEV_GRANT	<= "001";
		WAIT FOR 100 ns;

		-- dev.2 gets access
		DEV_GRANT	<= "010";
		WAIT FOR 100 ns;

		-- dev.3 gets access
		DEV_GRANT	<= "100";
		WAIT FOR 100 ns;

		-- zero
		DEV_GRANT	<= "110";
		WAIT FOR 100 ns;

		WAIT;
	END PROCESS;

END;
--------------------------------------------------------------------------------