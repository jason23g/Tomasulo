--------------------------------------------------------------------------------
-- Engineer:		PANOS VASILEIOU
-- 
-- Create Date:		13/04/2022
-- Design Name:		behv
-- Module Name:		ARITHMETIC_FU_PIPED
-- Project Name:	Tomasulo_v1.00
-- Tool versions:	ISE Project Navigator (P.20131013)
-- Description:
-- 
-- The adder module with 3 registers to its output. This is done to simulate
-- a 3-stage pipelined adder module. The Cout, Ovf and Zero signals also go
-- through the pipeline.
-- 
-- Dependencies:	ARITHMETIC_FU, REG
--
-- Revision: 
-- Revision 0.01 - File Created
--------------------------------------------------------------------------------
--USE WORK.common.ALL;
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
--------------------------------------------------------------------------------
ENTITY ARITHMETIC_FU_PIPED IS
GENERIC(
	reg_size : INTEGER := 16;
	op_width : INTEGER := 3
);
PORT(
	CLK		: IN STD_LOGIC;
	RST		: IN STD_LOGIC;
	WrEn	: IN STD_LOGIC;

	A		: IN STD_LOGIC_VECTOR(reg_size-1 DOWNTO 0);
	B		: IN STD_LOGIC_VECTOR(reg_size-1 DOWNTO 0);
	Op		: IN STD_LOGIC_VECTOR(op_width-1 DOWNTO 0);

	Result	: OUT STD_LOGIC_VECTOR(reg_size-1 DOWNTO 0);

	Cout	: OUT STD_LOGIC;
	Ovf		: OUT STD_LOGIC;
	Zero	: OUT STD_LOGIC
);
END ARITHMETIC_FU_PIPED;
--------------------------------------------------------------------------------
ARCHITECTURE behv OF ARITHMETIC_FU_PIPED IS

	COMPONENT ARITHMETIC_FU
	GENERIC(
		N		: INTEGER := 16;
		op_width : INTEGER := 3
	);
	PORT(
		CLK		: IN STD_LOGIC;
		RST		: IN STD_LOGIC;
		WrEn	: IN STD_LOGIC;
		A		: IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
		B		: IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
		Op		: IN STD_LOGIC_VECTOR(op_width-1 DOWNTO 0);

		Result	: OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0);

		Cout	: OUT STD_LOGIC;
		Ovf		: OUT STD_LOGIC;
		Zero	: OUT STD_LOGIC
	);
	END COMPONENT;

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

	-- signals
	SIGNAL sig_res1		: STD_LOGIC_VECTOR(reg_size-1 DOWNTO 0);
	SIGNAL sig_res2		: STD_LOGIC_VECTOR(reg_size-1 DOWNTO 0);
	SIGNAL sig_flags1	: STD_LOGIC_VECTOR(2 DOWNTO 0);
	SIGNAL sig_flags2	: STD_LOGIC_VECTOR(2 DOWNTO 0);

BEGIN

	arith_fu_inst : ARITHMETIC_FU
	GENERIC MAP(
		N		=> reg_size,
		op_width => op_width
	)
	PORT MAP(
		CLK		=> CLK,
		RST		=> RST,
		WrEn	=> WrEn,
		A		=> A,
		B		=> B,
		Op		=> Op,
		Result	=> sig_res1,
		Cout	=> sig_flags1(2),
		Ovf		=> sig_flags1(1),
		Zero	=> sig_flags1(0)
	);

	pipe1_res : REG
	GENERIC MAP(N => reg_size)
	PORT MAP(
		CLK		=> CLK,
		RST		=> RST,
		WrEN	=> WrEn,
		D		=> sig_res1,
		Q		=> sig_res2
	);

	pipe2_res : REG
	GENERIC MAP(N => reg_size)
	PORT MAP(
		CLK		=> CLK,
		RST		=> RST,
		WrEn	=> WrEn,
		D		=> sig_res2,
		Q		=> Result
	);

	pipe1_flags : REG
	GENERIC MAP(N => 3)
	PORT MAP(
		CLK		=> CLK,
		RST		=> RST,
		WrEN	=> WrEn,
		D		=> sig_flags1,
		Q		=> sig_flags2
	);


	pipe2_flags : REG
	GENERIC MAP(N => 3)
	PORT MAP(
		CLK		=> CLK,
		RST		=> RST,
		WrEn	=> WrEn,
		D		=> sig_flags2,
		Q(2)	=> Cout,
		Q(1)	=> Ovf,
		Q(0)	=> Zero
	);

END behv;
--------------------------------------------------------------------------------