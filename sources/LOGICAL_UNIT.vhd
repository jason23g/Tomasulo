--------------------------------------------------------------------------------
-- Engineer:		JASON GEORGAKAS
-- 
-- Create Date:		13/04/2022
-- Design Name:		behv
-- Module Name:		LOGICAL_UNIT
-- Project Name:	Tomasulo_v1.00
-- Tool versions:	ISE Project Navigator (P.20131013)
-- Description:
--
-- Dependencies:	Logical_FU, REG
--
-- Revision:
-- Revision 1.00 - Ready
--------------------------------------------------------------------------------
--USE WORK.common.ALL;
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
--------------------------------------------------------------------------------
ENTITY LOGICAL_UNIT IS
GENERIC(
	reg_size	: INTEGER := 16;
	rs_width	: INTEGER := 3;
	op_width	: INTEGER := 3
);
PORT( 	
	CLK		: IN STD_LOGIC;
	RST		: IN STD_LOGIC;
	WrEn	: IN STD_LOGIC;

	ReqIn 	: IN STD_LOGIC;
	Tag 	: IN STD_LOGIC_VECTOR(rs_width-1 downto 0);

	A 		: IN STD_LOGIC_VECTOR(reg_size-1 downto 0);
	B 		: IN STD_LOGIC_VECTOR(reg_size-1 downto 0);
	Op 		: IN STD_LOGIC_VECTOR(op_width-1 downto 0);

	Result	: OUT STD_LOGIC_VECTOR(reg_size-1 downto 0);
	TagOut 	: OUT STD_LOGIC_VECTOR(rs_width-1 downto 0);
	ReqOut 	: OUT STD_LOGIC
);
END LOGICAL_UNIT;
--------------------------------------------------------------------------------
ARCHITECTURE structural OF LOGICAL_UNIT IS

	COMPONENT LOGICAL_FU 
	GENERIC(
		reg_size : INTEGER := 16;
		op_width : INTEGER := 3
	);
	PORT(
		CLK		: IN STD_LOGIC;
		RST		: IN STD_LOGIC;
		WrEN	: IN STD_LOGIC;
		A		: IN STD_LOGIC_VECTOR(reg_size-1 downto 0);
		B		: IN STD_LOGIC_VECTOR(reg_size-1 downto 0);
		Op		: IN STD_LOGIC_VECTOR(op_width-1 downto 0);
		Result	: OUT STD_LOGIC_VECTOR(reg_size-1 downto 0)
	);
	END COMPONENT;

	COMPONENT REG
	GENERIC(N : INTEGER);
	PORT(
		CLK	: IN STD_LOGIC;
		RST	: IN STD_LOGIC;
		WrEn: IN STD_LOGIC;
		D	: IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
		Q	: OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0)
	);
	END COMPONENT;

	SIGNAL sig_res1 	: STD_LOGIC_VECTOR(reg_size-1 DOWNTO 0);
	SIGNAL sig_tag1		: STD_LOGIC_VECTOR(rs_width-1 DOWNTO 0);
	SIGNAL tag_in_1_eq	: STD_LOGIC;
	SIGNAL rq1_in		: STD_LOGIC;

BEGIN

	logical_fu_inst : LOGICAL_FU
	GENERIC MAP(
		reg_size => reg_size,
		op_width => op_width
	)
	PORT MAP(
		CLK		=> CLK,
		RST		=> RST,
		WrEn	=> WrEn,

		A 		=> A,
		B 		=> B,
		Op 		=> Op,

		Result	=> sig_res1
	);

	pipe1_res : REG
	GENERIC MAP(N => reg_size)
	PORT MAP(
		CLK		=> CLK,
		RST		=> RST,
		WrEn	=> WrEn,
		D		=> sig_res1,
		Q		=> Result
	);

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
		Q		=> TagOut
	);

	pipe1_rq : REG
	GENERIC MAP(N => 1)
	PORT MAP(
		CLK		=> CLK,
		RST		=> RST,
		WrEn	=> WrEn,
		D(0)	=> rq1_in,
		Q(0)	=> ReqOut
	);

	tag_in_1_eq <= '1' WHEN Tag = sig_tag1 AND Tag /= "000"
				ELSE '0';

	rq1_in <= '0' WHEN tag_in_1_eq = '1'
				ELSE ReqIn;

END structural;
--------------------------------------------------------------------------------