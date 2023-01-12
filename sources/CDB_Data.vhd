----------------------------------------------------------------------------------
-- Engineer:		PANOS VASILEIOU, JASON GEORGAKAS
-- 
-- Create Date:		11/04/2022
-- Module Name:		CDB_Data - behv
-- Project Name:	Tomasulo_v1.00
-- Tool Versions:	ISE Project Navigator (P.20131013)
-- Description:
-- 
-- The datapath of the Common Data Bus. A glorified 3-input multpiplexer.
-- 
-- Dependencies:	common
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- Added after comments about bad design.
--------------------------------------------------------------------------------
--USE WORK.common.ALL;
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
--------------------------------------------------------------------------------
ENTITY CDB_Data IS
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

	DEV_GRANT	: IN STD_LOGIC_VECTOR(3 DOWNTO 0);

	DEV_VAL_OUT	: OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0);
	DEV_Q_OUT	: OUT STD_LOGIC_VECTOR(Q-1 DOWNTO 0)
);
END CDB_Data;
--------------------------------------------------------------------------------
ARCHITECTURE behv OF CDB_Data IS

	COMPONENT REG
	GENERIC(N : INTEGER);
	PORT(
		CLK		: IN STD_LOGIC;
		RST		: IN STD_LOGIC;
		WrEn	: IN STD_LOGIC;
		D		: IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
		Q		: OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0)
	);
	END COMPONENT;

	signal sig_val_hpr	: std_logic_vector(N-1 downto 0);
	signal sig_q_hpr	: std_logic_vector(Q-1 downto 0);

BEGIN


	hpr_val : REG
	GENERIC MAP(N => N)
	PORT MAP(
		CLK		=> CLK,
		RST		=> RST,
		WrEn	=> '1',
		D		=> dev_val_hpr,
		Q		=> sig_val_hpr
	);

	hpr_q : REG
	GENERIC MAP(N => Q)
	PORT MAP(
		CLK		=> CLK,
		RST		=> RST,
		WrEn	=> '1',
		D		=> dev_q_hpr,
		Q		=> sig_q_hpr
	);

DEV_VAL_OUT <=	sig_val_hpr WHEN DEV_GRANT = "1000"
				ELSE DEV1_VAL WHEN DEV_GRANT = "0001"
				ELSE DEV2_VAL WHEN DEV_GRANT = "0010"
				ELSE DEV3_VAL WHEN DEV_GRANT = "0100"
				ELSE (OTHERS => '0');
					
DEV_Q_OUT <=	sig_q_hpr WHEN DEV_GRANT = "1000"
				ELSE DEV1_Q WHEN DEV_GRANT = "0001"
				ELSE DEV2_Q WHEN DEV_GRANT = "0010"
				ELSE DEV3_Q WHEN DEV_GRANT = "0100"
				ELSE (OTHERS => '0');

END behv;
--------------------------------------------------------------------------------