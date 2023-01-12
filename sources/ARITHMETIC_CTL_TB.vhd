--------------------------------------------------------------------------------
-- Engineer:
-- 
-- Create Date:		03/06/2022
-- Module Name:		ARITHMETIC_CTL_TB.vhd
-- Project Name:	Tomasulo_v1.00
-- Tool versions:
-- Description: 
-- 
-- VHDL Test Bench Created by ISE for module: ARITHMETIC_CTL
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
--------------------------------------------------------------------------------
ENTITY ARITHMETIC_CTL_TB IS
GENERIC(
	rs_width	: INTEGER := 3
);
END ARITHMETIC_CTL_TB;
--------------------------------------------------------------------------------
ARCHITECTURE behavior OF ARITHMETIC_CTL_TB IS 

	-- Component Declaration for the Unit Under Test (UUT)
	COMPONENT ARITHMETIC_CTL
	PORT(
		-- from Issue
		Accepted		: IN STD_LOGIC;

		-- from CDB
		CDB_Grant		: IN STD_LOGIC;

		-- comparators in arithmetic_data
		cdbq_comp_zero	: IN STD_LOGIC;
		cdbq_comp_tag	: IN STD_LOGIC_VECTOR(2 DOWNTO 0);
		rs_qj_comp_cdbq	: IN STD_LOGIC_VECTOR(2 DOWNTO 0);
		rs_qk_comp_cdbq	: IN STD_LOGIC_VECTOR(2 DOWNTO 0);

		-- from arithmetic_data
		rs_ready		: IN STD_LOGIC_VECTOR(2 DOWNTO 0);
		busy			: IN STD_LOGIC_VECTOR(2 DOWNTO 0);
		rq_delayed		: IN STD_LOGIC;

		-- to arithmetic_data
		rs_op_wren		: OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
		rs_qj_wren		: OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
		rs_vj_wren		: OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
		rs_qk_wren		: OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
		rs_vk_wren		: OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
		rs_busy_wren	: OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
		rs_busy_wrdata	: OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
		rs_exec			: OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
		arith_tag		: OUT STD_LOGIC_VECTOR(rs_width-1 DOWNTO 0);
		arith_wren		: OUT STD_LOGIC;
		arith_req		: OUT STD_LOGIC
	);
	END COMPONENT;

	-- Inputs
	signal Accepted			: STD_LOGIC := '0';
	signal CDB_Grant		: STD_LOGIC := '0';
	signal rq_delayed		: STD_LOGIC := '0';
	signal cdbq_comp_zero	: STD_LOGIC := '0';
	signal cdbq_comp_tag	: STD_LOGIC_VECTOR(2 DOWNTO 0) := (OTHERS => '0');
	signal rs_qj_comp_cdbq	: STD_LOGIC_VECTOR(2 DOWNTO 0) := (OTHERS => '0');
	signal rs_qk_comp_cdbq	: STD_LOGIC_VECTOR(2 DOWNTO 0) := (OTHERS => '0');
	signal rs_ready			: STD_LOGIC_VECTOR(2 DOWNTO 0) := (OTHERS => '0');
	signal busy				: STD_LOGIC_VECTOR(2 DOWNTO 0) := (OTHERS => '0');

	-- Outputs
	signal rs_op_wren		: STD_LOGIC_VECTOR(2 DOWNTO 0);
	signal rs_qj_wren		: STD_LOGIC_VECTOR(2 DOWNTO 0);
	signal rs_vj_wren		: STD_LOGIC_VECTOR(2 DOWNTO 0);
	signal rs_qk_wren		: STD_LOGIC_VECTOR(2 DOWNTO 0);
	signal rs_vk_wren		: STD_LOGIC_VECTOR(2 DOWNTO 0);
	signal rs_busy_wren		: STD_LOGIC_VECTOR(2 DOWNTO 0);
	signal rs_busy_wrdata	: STD_LOGIC_VECTOR(2 DOWNTO 0);
	signal rs_exec			: STD_LOGIC_VECTOR(2 DOWNTO 0);
	signal arith_tag		: STD_LOGIC_VECTOR(2 DOWNTO 0);
	signal arith_wren		: STD_LOGIC;
	signal arith_req		: STD_LOGIC;

BEGIN

	-- Instantiate the Unit Under Test (UUT)
	uut : ARITHMETIC_CTL
	PORT MAP (
		-- from Issue
		Accepted		=> Accepted,

		-- from CDB
		CDB_Grant		=> CDB_Grant,

		-- comparators in arithmetic_data
		cdbq_comp_zero	=> cdbq_comp_zero,
		cdbq_comp_tag	=> cdbq_comp_tag,
		rs_qj_comp_cdbq	=> rs_qj_comp_cdbq,
		rs_qk_comp_cdbq	=> rs_qk_comp_cdbq,

		-- from arithmetic_data
		rs_ready		=> rs_ready,
		busy			=> busy,
		rq_delayed		=> rq_delayed,

		-- to arithmetic_data
		rs_op_wren		=> rs_op_wren,
		rs_qj_wren		=> rs_qj_wren,
		rs_vj_wren		=> rs_vj_wren,
		rs_qk_wren		=> rs_qk_wren,
		rs_vk_wren		=> rs_vk_wren,
		rs_busy_wren	=> rs_busy_wren,
		rs_busy_wrdata	=> rs_busy_wrdata,
		rs_exec			=> rs_exec,
		arith_tag		=> arith_tag,
		arith_wren		=> arith_wren,
		arith_req		=> arith_req
	);


	-- Stimulus process
	stim_proc : process
	begin		
		-- hold reset state for 100 ns.
		wait for 100 ns;

		-- insert stimulus here

		wait;
	end process;

END;
--------------------------------------------------------------------------------