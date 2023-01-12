--------------------------------------------------------------------------------
-- Engineers: 		JASON GEROGAKAS, PANOS VASILEIOU
-- 
-- Create Date: 	10/5/2022
-- Design Name: 	behv
-- Module Name: 	RESERVATION_STATION
-- Project Name: 	TOMASULO_2022
-- Tool versions: 	ISE Project Navigator (P.20131013)
-- Description: 	This module holds the minimum amount of information needed
-- 					to execute an instruction (arithmetic or logical).
-- 					
-- Dependencies: 	REG
--
-- Revision: 
-- Revision 1.00 - READY FOR REALEASE
-- Additional Comments:
-- To extend its use for immediate and branch instrs adding another register to
-- hold that information is necessary.
--------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
--------------------------------------------------------------------------------
ENTITY RESERVATION_STATION IS
GENERIC(
	reg_size	: INTEGER := 16;
	rs_width	: INTEGER := 3;
	op_width	: INTEGER := 3
);
PORT(
	CLK			: IN  STD_LOGIC;
	RST			: IN  STD_LOGIC;
	OpWrData	: IN  STD_LOGIC_VECTOR(op_width-1 DOWNTO 0);
	OpWrEn		: IN  STD_LOGIC;
	QjWrData	: IN  STD_LOGIC_VECTOR(rs_width-1 DOWNTO 0);
	QjWrEn		: IN  STD_LOGIC;
	QkWrData	: IN  STD_LOGIC_VECTOR(rs_width-1 DOWNTO 0);
	QkWrEn		: IN  STD_LOGIC;
	VjWrData	: IN  STD_LOGIC_VECTOR(reg_size-1 DOWNTO 0);
	VjWrEn		: IN  STD_LOGIC;
	VkWrData	: IN  STD_LOGIC_VECTOR(reg_size-1 DOWNTO 0);
	VkWrEn		: IN  STD_LOGIC;
	BusyWrData	: IN  STD_LOGIC;
	BusyWrEn	: IN  STD_LOGIC;
	Op			: OUT STD_LOGIC_VECTOR(op_width-1 DOWNTO 0);
	Qj			: OUT STD_LOGIC_VECTOR(rs_width-1 DOWNTO 0);
	Qk			: OUT STD_LOGIC_VECTOR(rs_width-1 DOWNTO 0);
	Vj			: OUT STD_LOGIC_VECTOR(reg_size-1 DOWNTO 0);
	Vk			: OUT STD_LOGIC_VECTOR(reg_size-1 DOWNTO 0);
	Busy		: OUT STD_LOGIC;
	Ready		: OUT STD_LOGIC
);
END RESERVATION_STATION;
--------------------------------------------------------------------------------
ARCHITECTURE behv of RESERVATION_STATION is

	COMPONENT REG
	GENERIC(N : INTEGER);
	PORT(
		CLK		: IN STD_LOGIC;
		RST		: IN STD_LOGIC;
		WrEN	: IN STD_LOGIC;
		D		: IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
		Q		: OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0)
	);
	END COMPONENT;

	SIGNAL sig_busy	: STD_LOGIC;
	SIGNAL sig_qj	: STD_LOGIC_VECTOR(rs_width-1 DOWNTO 0);
	SIGNAL sig_qk	: STD_LOGIC_VECTOR(rs_width-1 DOWNTO 0);

BEGIN

	op_reg : REG
	GENERIC MAP(N => op_width)
	PORT MAP(
		CLK		=> CLK,
		RST		=> RST,
		WrEn	=> OpWrEn,
		D		=> OpWrData,
		Q		=> Op
	);

	qj_reg : REG
	GENERIC MAP(N => rs_width)
	PORT MAP(
		CLK		=> CLK,
		RST		=> RST,
		WrEn	=> QjWrEn,
		D		=> QjWrData,
		Q		=> sig_qj
	);

	qk_reg : REG
	GENERIC MAP(N => rs_width)
	PORT MAP(
		CLK		=> CLK,
		RST		=> RST,
		WrEn	=> QkWrEn,
		D		=> QkWrData,
		Q		=> sig_qk
	);

	vj_reg : REG
	GENERIC MAP(N => reg_size)
	PORT MAP(
		CLK		=> CLK,
		RST		=> RST,
		WrEn	=> VjWrEn,
		D		=> VjWrData,
		Q		=> Vj
	);

	vk_reg : REG
	GENERIC MAP(N => reg_size)
	PORT MAP(
		CLK		=> CLK,
		RST		=> RST,
		WrEn	=> VkWrEn,
		D		=> VkWrData,
		Q		=> Vk
	);

	busy_reg : REG
	GENERIC MAP(N => 1)
	PORT MAP(
		CLK		=> CLK,
		RST		=> RST,
		WrEn	=> BusyWrEn,
		D(0)	=> BusyWrData,
		Q(0)	=> sig_busy
	);

	ready <= '1' WHEN (sig_qj = "000" AND sig_qk = "000" AND sig_busy = '1')
				ELSE '0';

	Qj		<= sig_qj;
	Qk		<= sig_qk;
	Busy	<= sig_busy;

END behv;
--------------------------------------------------------------------------------