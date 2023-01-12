--------------------------------------------------------------------------------
-- Engineer:		PANOS VASILEIOU
-- 
-- Create Date:		13/04/2022 
-- Design Name:		behv
-- Module Name:		ARITHMETIC_UNIT 
-- Project Name:	tOMASULO_V1.00
-- Tool versions:	ISE Project Navigator (P.20131013)
-- Description:
-- 
-- The top-level of the Arithmetic Unit. It consists of a dummy 3-stage
-- pipelined adder, 3 registers to feed the tag along with the result and
-- 2 registers to announce to the CDB that it will be ready in the next cycle
-- and it will need access to the CDB.
-- 
-- Dependencies:	ARITHMETIC_FU_PIPED, REG
-- 
-- Revision:
-- Revision 0.01 - File Created
--------------------------------------------------------------------------------
--USE WORK.common.ALL;
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
--------------------------------------------------------------------------------
ENTITY ARITHMETIC_UNIT IS
GENERIC(
	reg_size	: INTEGER := 16;
	rs_width	: INTEGER := 3;
	op_width	: INTEGER := 3
);
PORT(
	CLK		: IN  STD_LOGIC;
	RST		: IN  STD_LOGIC;
	WrEn	: IN  STD_LOGIC;

	ReqIn	: IN  STD_LOGIC;
	Tag		: IN  STD_LOGIC_VECTOR(rs_width-1 DOWNTO 0);

	A		: IN  STD_LOGIC_VECTOR(reg_size-1 DOWNTO 0);
	B		: IN  STD_LOGIC_VECTOR(reg_size-1 DOWNTO 0);
	Op		: IN  STD_LOGIC_VECTOR(op_width-1 DOWNTO 0);

	Result	: OUT STD_LOGIC_VECTOR(reg_size-1 DOWNTO 0);
	TagOut	: OUT STD_LOGIC_VECTOR(rs_width-1 DOWNTO 0);
	ReqOut	: OUT STD_LOGIC;

	Cout	: OUT STD_LOGIC;
	Ovf		: OUT STD_LOGIC;
	Zero	: OUT STD_LOGIC
);
END ARITHMETIC_UNIT;
--------------------------------------------------------------------------------
ARCHITECTURE behv OF ARITHMETIC_UNIT IS

	COMPONENT ARITHMETIC_FU_PIPED
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

		Cout	: OUT STD_LOGIC;
		Result	: OUT STD_LOGIC_VECTOR(reg_size-1 DOWNTO 0);

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

	-- signal declarations
	SIGNAL sig_tag1	: STD_LOGIC_VECTOR(rs_width-1 DOWNTO 0);
	SIGNAL sig_tag2	: STD_LOGIC_VECTOR(rs_width-1 DOWNTO 0);
	SIGNAL sig_rq1	: STD_LOGIC;
	signal tag_1_2_eq : std_logic;
	signal rq2_in	: std_logic;

BEGIN

	arith_fu_piped_inst : ARITHMETIC_FU_PIPED
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
		Result	=> Result,
		Cout	=> Cout,
		Ovf		=> Ovf,
		Zero	=> Zero
	);

	-- pipe registers for the rqst
	pipe1_rq : REG
	GENERIC MAP(N => 1)
	PORT MAP(
		CLK		=> CLK,
		RST		=> RST,
		WrEn	=> WrEn,
		D(0)	=> ReqIn,
		Q(0)	=> sig_rq1
	);

	pipe2_rq : REG
	GENERIC MAP(N => 1)
	PORT MAP(
		CLK		=> CLK,
		RST		=> RST,
		WrEn	=> WrEn,
		D(0)	=> rq2_in,
		Q(0)	=> ReqOut
	);

	-- pipe registers for the tag (RS address)
	pipe1_tag : REG
	GENERIC MAP(N => rs_width)
	PORT MAP(
		CLK		=> CLK,
		RST		=> RST,
		WrEn	=> WrEn,
		D		=> Tag,
		Q		=> sig_tag1
	);

	pipe2_tag : REG
	GENERIC MAP(N => rs_width)
	PORT MAP(
		CLK		=> CLK,
		RST		=> RST,
		WrEn	=> WrEn,
		D		=> sig_tag1,
		Q		=> sig_tag2
	);

	pipe3_tag : REG
	GENERIC MAP(N => rs_width)
	PORT MAP(
		CLK		=> CLK,
		RST		=> RST,
		WrEn	=> WrEn,
		D		=> sig_tag2,
		Q		=> TagOut
	);

	tag_1_2_eq <= '1' WHEN sig_tag1 = sig_tag2 AND sig_tag1 /= "000"
					ELSE '0';

	rq2_in <= '0' WHEN tag_1_2_eq = '1'
				ELSE sig_rq1;

END behv;
--------------------------------------------------------------------------------