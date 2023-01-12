--------------------------------------------------------------------------------
-- Engineer:		JASON GEORGAKAS
-- 
-- Create Date:		13/05/2022
-- Module Name:		Issue_TB.vhd - behv
-- Project Name:	Tomasulo_v1.00
-- Tool versions:	ISE Project Navigator & ISim (P.20131013)
-- Description:
-- 
-- VHDL Test Bench Created by the author for module: Issue
-- 
-- Dependencies:	ISSUE_UNIT
-- 
-- Revision:
-- Revision 1.00 - Ready
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use work.common.all;
--------------------------------------------------------------------------------
ENTITY ISSUE_UNIT_TB IS
END ISSUE_UNIT_TB;
--------------------------------------------------------------------------------
ARCHITECTURE behv OF ISSUE_UNIT_TB IS 

	-- Component Declaration for the Unit Under Test (UUT)
	COMPONENT ISSUE_UNIT
	PORT(
		CLK				: IN std_logic;
		RST				: IN std_logic;

		Issue			: IN  std_logic;

		FU_Type			: IN  std_logic_vector(1 DOWNTO 0);
		Fop_IF			: IN  std_logic_vector(2 DOWNTO 0);
		Ri_IF			: IN  std_logic_vector(4 DOWNTO 0);
		Rj_IF			: IN  std_logic_vector(4 DOWNTO 0);
		Rk_IF			: IN  std_logic_vector(4 DOWNTO 0);
		Immed_IF		: IN  std_logic_vector(15 DOWNTO 0);

		-- from arithmetic and logical
		Avail_RS		: IN  std_logic_vector(1 DOWNTO 0);

		-- to arithmetic, logical
		Fop				: OUT std_logic_vector(2 DOWNTO 0);
		-- to arithmetic, logical and Register File
		Ri				: OUT std_logic_vector(4 DOWNTO 0);
		Rj				: OUT std_logic_vector(4 DOWNTO 0);
		Rk				: OUT std_logic_vector(4 DOWNTO 0);

		-- to Register File
		Immed			: OUT std_logic_vector(15 DOWNTO 0); 

		-- to Register File
		Accepted		: OUT std_logic;
		-- to arithmetic, logical and Register File
		Arith_Issue		: OUT std_logic;
		Logical_Issue	: OUT std_logic;
		Issue_Immed		: OUT std_logic
	);
	END COMPONENT;

	-- Inputs
	signal CLK		: std_logic := '0';
	signal RST		: std_logic := '0';
	signal Issue	: std_logic := '0';
	signal FU_Type	: std_logic_vector(1 downto 0) := (others => '0');
	signal Fop_IF	: std_logic_vector(2 downto 0) := (others => '0');
	signal Ri_IF	: std_logic_vector(4 downto 0) := (others => '0');
	signal Rj_IF	: std_logic_vector(4 downto 0) := (others => '0');
	signal Rk_IF	: std_logic_vector(4 downto 0) := (others => '0');
	signal Immed_IF	: std_logic_vector(15 DOWNTO 0) := (others => '0');
	signal Avail_RS	: std_logic_vector(1 downto 0) := (others => '0');

	-- Outputs
	signal Accepted 		: std_logic;
	signal Fop				: std_logic_vector(2 downto 0);
	signal Ri				: std_logic_vector(4 downto 0);
	signal Rj				: std_logic_vector(4 downto 0);
	signal Rk				: std_logic_vector(4 downto 0);
	signal Immed			: std_logic_vector(15 DOWNTO 0);
	signal Arith_Issue		: std_logic;
	signal Logical_Issue	: std_logic;
	signal Issue_Immed		: std_logic;

BEGIN

	-- Instantiate the Unit Under Test (UUT)
	uut : ISSUE_UNIT
	PORT MAP(
		CLK				=> CLK,
		RST				=> RST,
		Issue			=> Issue,
		FU_Type			=> FU_Type,
		Fop_IF			=> Fop_IF,
		Ri_IF			=> Ri_IF,
		Rj_IF			=> Rj_IF,
		Rk_IF			=> Rk_IF,
		Immed_IF		=> Immed_IF,
		Avail_RS		=> Avail_RS,

		Accepted 		=> Accepted,
		Fop				=> Fop,
		Ri				=> Ri,
		Rj				=> Rj,
		Rk				=> Rk,
		Immed			=> Immed,
		Arith_Issue		=> Arith_Issue,
		Logical_Issue	=> Logical_Issue,
		Issue_Immed		=> Issue_Immed
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
	stim_proc : process
	begin		
		-- hold reset state for 100 ns.
		RST			<= '0';
		wait for cc;

		RST			<= '1';

		-- ADD R1, R2, R5
		Issue		<= '1';
		FU_Type		<= "01";
		Fop_IF		<= "100";
		Ri_IF		<= "00001";
		Rj_IF		<= "00010";
		Rk_IF		<= "00101";
		Immed_IF	<= x"B1B0";
		Avail_RS	<= "01";
		wait for cc;

		-- SUB R6, R7, R10
		Issue 		<= '1';
		FU_Type		<= "01";
		Fop_IF		<= "101";
		Ri_IF		<= "00110";
		Rj_IF		<= "00111";
		Rk_IF		<= "01010";
		Immed_IF	<= x"F1F0";
		Avail_RS	<= "10";
		wait for cc;

		-- OR R1, R2, R5
		Issue		<= '1';
		FU_Type		<= "10";
		Fop_IF		<= "001";
		Ri_IF		<= "00001";
		Rj_IF		<= "00010";
		Rk_IF		<= "00101";
		Immed_IF	<= x"F3F3";
		Avail_RS	<= "10";
		wait for cc;

		-- AND R4, R9, R11
		Issue		<= '1';
		FU_Type		<= "10";
		Fop_IF		<= "010";
		Ri_IF		<= "00100";
		Rj_IF		<= "01001";
		Rk_IF		<= "01011";
		Immed_IF	<= x"AAAA";
		Avail_RS	<= "01";
		wait for cc;

		-- NOT R4, R9, R11
		Issue		<= '1';
		FU_Type		<= "00";
		Fop_IF		<= "010";
		Ri_IF		<= "00100";
		Rj_IF		<= "01001";
		Rk_IF		<= "01011";
		Immed_IF	<= x"CCCC";
		Avail_RS	<= "01";
		wait for cc;

		-- LI R4, 0xBOOB
		Issue		<= '1';
		FU_Type		<= "00";
		Fop_IF		<= "111";
		Ri_IF		<= "00100";
		Rj_IF		<= "01001";
		Rk_IF		<= "01011";
		Immed_IF	<= x"B00B";
		Avail_RS	<= "01";
		wait for cc;

		Issue		<= '0';
		wait;
	end process;

END;
--------------------------------------------------------------------------------