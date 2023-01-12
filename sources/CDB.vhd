--------------------------------------------------------------------------------
-- Engineer:		JASON GEORGAKAS, PANOS VASILEIOU
-- 
-- Create Date:		12/04/2022
-- Module Name:		CDB - behv
-- Project Name:	Tomasulo_v1.00
-- Tool versions:	ISE Project Navigator (P.20131013)
-- Description:
-- 
-- The Common Data Bus (CDB). It simply connects the CDB_Dtl and CDB_Data
-- modules.
-- 
-- Dependencies: CDB_Ctl, CDB_Data
-- 
-- Revision:
-- Revision 1.00 - Ready
--------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
--------------------------------------------------------------------------------
ENTITY CDB IS
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
END CDB;
--------------------------------------------------------------------------------
ARCHITECTURE behv of CDB is

	COMPONENT CDB_Data
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
	END COMPONENT;

	COMPONENT CDB_Ctl 
	PORT(
		CLK			: IN STD_LOGIC;
		RST			: IN STD_LOGIC;

		DEV_REQ		: IN STD_LOGIC_VECTOR(3 DOWNTO 0);

		DEV_GRANT	: OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
	);
	END COMPONENT;

	SIGNAL sig_dev_grant : STD_LOGIC_VECTOR(3 DOWNTO 0);

BEGIN

	cdb_data_inst : CDB_Data
	GENERIC MAP(
		N => N,
		Q => Q
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

		DEV_GRANT	=> sig_dev_grant,
		DEV_Q_OUT	=> DEV_Q_OUT,
		DEV_VAL_OUT	=> DEV_VAL_OUT
	);

	cdb_ctl_inst : CDB_Ctl
	PORT MAP(
		CLK			=> CLK,
		RST			=> RST,

		DEV_REQ		=> DEV_REQ,

		DEV_GRANT	=> sig_dev_grant
	);

	DEV_GRANT <= sig_dev_grant;

end behv;
--------------------------------------------------------------------------------