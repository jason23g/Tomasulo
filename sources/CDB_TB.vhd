--------------------------------------------------------------------------------
-- Engineer:		JASON GEORGAKAS, PANOS VASILEIOU
--
-- Create Date:	11/04/2022
-- Design Name:	behv
-- Module Name:	CDB_TB.vhd
-- Project Name:	Tomasulo_v1.00
-- Tool versions:	ISE Project Navigator & ISim (P.20131013)
-- Description:
-- 
-- VHDL Test Bench Created by the authors for module: CDB
-- 
-- Dependencies:	CDB, common
-- 
-- Revision:
-- Revision 1.00 - Tested
--------------------------------------------------------------------------------
USE WORK.common.ALL;
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
--------------------------------------------------------------------------------
ENTITY CDB_TB IS
GENERIC(
	N			: INTEGER := 16;
	Q			: INTEGER := 3
);
END CDB_TB;
--------------------------------------------------------------------------------
ARCHITECTURE behavior OF CDB_TB IS 

	-- Component Declaration for the Unit Under Test (UUT)
	COMPONENT CDB
	GENERIC(
		N			: INTEGER := 16;
		Q			: INTEGER := 3
	);
	PORT(
		CLK			: IN STD_LOGIC;
		RST			: IN STD_LOGIC;

		DEV1_VAL	: IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
		DEV2_VAL	: IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
		DEV3_VAL	: IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
		dev_val_hpr	: IN std_logic_vector(N-1 downto 0);

		DEV1_Q		: IN STD_LOGIC_VECTOR(Q-1 DOWNTO 0);
		DEV2_Q		: IN STD_LOGIC_VECTOR(Q-1 DOWNTO 0);
		DEV3_Q		: IN STD_LOGIC_VECTOR(Q-1 DOWNTO 0);
		dev_q_hpr	: IN std_logic_vector(Q-1 downto 0);

		DEV_REQ		: IN STD_LOGIC_VECTOR(3 DOWNTO 0);

		DEV_GRANT	: OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
		DEV_VAL_OUT	: OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0);
		DEV_Q_OUT	: OUT STD_LOGIC_VECTOR(Q-1 DOWNTO 0)
	);
	END COMPONENT;

	-- Inputs
	SIGNAL CLK			: STD_LOGIC := '0';
	SIGNAL RST			: STD_LOGIC := '0';
	SIGNAL DEV1_VAL		: STD_LOGIC_VECTOR(N-1 DOWNTO 0) := (OTHERS => '0');
	SIGNAL DEV2_VAL		: STD_LOGIC_VECTOR(N-1 DOWNTO 0) := (OTHERS => '0');
	SIGNAL DEV3_VAL		: STD_LOGIC_VECTOR(N-1 DOWNTO 0) := (OTHERS => '0');
	SIGNAL dev_val_hpr	: STD_LOGIC_VECTOR(N-1 DOWNTO 0) := (OTHERS => '0');
	SIGNAL DEV1_Q		: STD_LOGIC_VECTOR(Q-1 DOWNTO 0) := (OTHERS => '0');
	SIGNAL DEV2_Q		: STD_LOGIC_VECTOR(Q-1 DOWNTO 0) := (OTHERS => '0');
	SIGNAL DEV3_Q		: STD_LOGIC_VECTOR(Q-1 DOWNTO 0) := (OTHERS => '0');
	SIGNAL dev_q_hpr	: STD_LOGIC_VECTOR(Q-1 DOWNTO 0) := (OTHERS => '0');
	SIGNAL DEV_REQ		: STD_LOGIC_VECTOR(3 DOWNTO 0) := (OTHERS => '0');

	-- Outputs
	SIGNAL DEV_GRANT	: STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL DEV_VAL_OUT	: STD_LOGIC_VECTOR(N-1 DOWNTO 0);
	SIGNAL DEV_Q_OUT	: STD_LOGIC_VECTOR(Q-1 DOWNTO 0);

BEGIN

	-- Instantiate the Unit Under Test (UUT)
	uut : CDB
	GENERIC MAP(
		N			=> N,
		Q			=> Q
	)
	PORT MAP(
		CLK			=> CLK,
		RST			=> RST,

		DEV1_VAL	=> DEV1_VAL,
		DEV2_VAL	=> DEV2_VAL,
		DEV3_VAL	=> DEV3_VAL,
		dev_val_hpr	=> dev_val_hpr,

		DEV1_Q		=> DEV1_Q,
		DEV2_Q		=> DEV2_Q,
		DEV3_Q		=> DEV3_Q,
		dev_q_hpr	=> dev_q_hpr,

		DEV_REQ		=> DEV_REQ,
		DEV_GRANT	=> DEV_GRANT,

		DEV_Q_OUT	=> DEV_Q_OUT,
		DEV_VAL_OUT	=> DEV_VAL_OUT
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
		RST <= '0';
		-- insert stimulus here
		WAIT FOR CLK_period;

		RST <= '1';

		dev_val_hpr	<= x"B00B";
		dev_q_hpr	<= "011";

		DEV_REQ <= "1001";
		WAIT FOR CLK_period;

		DEV1_VAL	<= x"BABA";
		DEV1_Q	<= "001";

		dev_val_hpr	<= x"0000";
		dev_q_hpr	<= "000";
		DEV_REQ <= "0000";
		WAIT FOR CLK_period;

		RST <= '1';
		DEV1_VAL	<= x"BABA";
		DEV2_VAL	<= x"CAFE";
		DEV3_VAL	<= x"DEAD";

		DEV1_Q	<= "001";
		DEV2_Q	<= "010";
		DEV3_Q	<= "100";

		DEV_REQ <= "0000";
		WAIT FOR CLK_period;

		DEV_REQ <= "0110";
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
		--DEV1_VAL	<= x"BABA";
		--DEV2_VAL	<= x"CAFE";
		--DEV3_VAL	<= x"DEAD";
		--DEV1_Q	<= "001";
		--DEV2_Q	<= "010";
		--DEV3_Q	<= "100";
	
		WAIT;
	END PROCESS;

END;
--------------------------------------------------------------------------------