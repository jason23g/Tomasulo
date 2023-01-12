--------------------------------------------------------------------------------
-- Engineer:
-- 
-- Create Date:   03/06/2022
-- Module Name:   ARITHMETIC_DATA_TB.vhd
-- Project Name:  Tomasulo_v1.00
-- Tool versions:
-- Description: 
-- 
-- VHDL Test Bench Created by ISE for module: ARITHMETIC_DATA
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
--------------------------------------------------------------------------------
ENTITY ARITHMETIC_DATA_TB IS
generic(
	reg_size	: INTEGER := 16;
	reg_num		: INTEGER := 32;
	reg_width	: INTEGER := 5;
	rs_num		: INTEGER := 5+1;
	rs_width	: INTEGER := 3;
	op_width	: INTEGER := 3
);
END ARITHMETIC_DATA_TB;
--------------------------------------------------------------------------------
ARCHITECTURE behavior OF ARITHMETIC_DATA_TB IS 

	-- Component Declaration for the Unit Under Test (UUT)
	COMPONENT ARITHMETIC_DATA
	generic(
		reg_size	: INTEGER := 16;
		reg_num		: INTEGER := 32;
		reg_width	: INTEGER := 5;
		rs_num		: INTEGER := 5+1;
		rs_width	: INTEGER := 3;
		op_width	: INTEGER := 3
	);
	port(
		CLK			: IN STD_LOGIC;
		RST			: IN STD_LOGIC;

		-- from arithmetic_ctl
		WrEn		: IN STD_LOGIC;

		-- from CDB
		CDB_Grant	: IN STD_LOGIC;
		CDB_Q_in	: IN STD_LOGIC_VECTOR(rs_width-1 DOWNTO 0);
		CDB_V_in	: IN STD_LOGIC_VECTOR(reg_size-1 DOWNTO 0);

		-- Qj, Qk, Vj, Vk, from Register File
		stat_data1	: IN STD_LOGIC_VECTOR(rs_width-1 DOWNTO 0);
		stat_data2	: IN STD_LOGIC_VECTOR(rs_width-1 DOWNTO 0);
		data1		: IN STD_LOGIC_VECTOR(reg_size-1 DOWNTO 0);
		data2		: IN STD_LOGIC_VECTOR(reg_size-1 DOWNTO 0);

		-- from Issue
		Op			: IN STD_LOGIC_VECTOR(op_width-1 DOWNTO 0);
		Accepted	: IN STD_LOGIC;

		-- from arithmetic_ctl
		rs_op_wren		: IN STD_LOGIC_VECTOR(2 DOWNTO 0);
		rs_qj_wren		: IN STD_LOGIC_VECTOR(2 DOWNTO 0);
		rs_vj_wren		: IN STD_LOGIC_VECTOR(2 DOWNTO 0);
		rs_qk_wren		: IN STD_LOGIC_VECTOR(2 DOWNTO 0);
		rs_vk_wren		: IN STD_LOGIC_VECTOR(2 DOWNTO 0);
		rs_busy_wren	: IN STD_LOGIC_VECTOR(2 DOWNTO 0);
		rs_busy_wrdata	: IN STD_LOGIC_VECTOR(2 DOWNTO 0);
		rs_exec			: IN STD_LOGIC_VECTOR(2 downto 0);
		arith_tag		: IN STD_LOGIC_VECTOR(rs_width-1 downto 0);
		arith_req		: IN STD_LOGIC;

		-- to CDB
		ReqOut			: OUT STD_LOGIC;
		CDB_Q			: OUT STD_LOGIC_VECTOR(rs_width-1 DOWNTO 0);
		CDB_V			: OUT STD_LOGIC_VECTOR(reg_size-1 DOWNTO 0);

		-- to Issue
		Avail_RS		: OUT STD_LOGIC;

		-- to arithmetic_ctl
		rq_delayed		: OUT STD_LOGIC;
		rs_ready		: OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
		rs_busy			: OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
		cdbq_comp_zero	: OUT STD_LOGIC;
		cdbq_comp_tag	: OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
		rs_qj_comp_cdbq	: OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
		rs_qk_comp_cdbq	: OUT STD_LOGIC_VECTOR(2 DOWNTO 0)
	);
	END COMPONENT;

	-- Inputs
	signal CLK				: STD_LOGIC := '0';
	signal RST				: STD_LOGIC := '0';
	signal WrEn				: STD_LOGIC := '0';
	signal CDB_Grant		: STD_LOGIC := '0';
	signal CDB_Q_in			: STD_LOGIC_VECTOR(rs_width-1 DOWNTO 0) := (OTHERS => '0');
	signal CDB_V_in			: STD_LOGIC_VECTOR(reg_size-1 DOWNTO 0) := (OTHERS => '0');
	signal stat_data1		: STD_LOGIC_VECTOR(rs_width-1 DOWNTO 0) := (OTHERS => '0');
	signal stat_data2		: STD_LOGIC_VECTOR(rs_width-1 DOWNTO 0) := (OTHERS => '0');
	signal data1			: STD_LOGIC_VECTOR(reg_size-1 DOWNTO 0) := (OTHERS => '0');
	signal data2			: STD_LOGIC_VECTOR(reg_size-1 DOWNTO 0) := (OTHERS => '0');
	signal Op				: STD_LOGIC_VECTOR(op_width-1 DOWNTO 0) := (OTHERS => '0');
	signal Accepted			: STD_LOGIC := '0';
	signal rs_op_wren		: STD_LOGIC_VECTOR(2 DOWNTO 0) := (OTHERS => '0');
	signal rs_qj_wren		: STD_LOGIC_VECTOR(2 DOWNTO 0) := (OTHERS => '0');
	signal rs_vj_wren		: STD_LOGIC_VECTOR(2 DOWNTO 0) := (OTHERS => '0');
	signal rs_qk_wren		: STD_LOGIC_VECTOR(2 DOWNTO 0) := (OTHERS => '0');
	signal rs_vk_wren		: STD_LOGIC_VECTOR(2 DOWNTO 0) := (OTHERS => '0');
	signal rs_busy_wren		: STD_LOGIC_VECTOR(2 DOWNTO 0) := (OTHERS => '0');
	signal rs_busy_wrdata	: STD_LOGIC_VECTOR(2 DOWNTO 0) := (OTHERS => '0');
	signal rs_exec			: STD_LOGIC_VECTOR(2 DOWNTO 0) := (OTHERS => '0');
	signal arith_tag		: STD_LOGIC_VECTOR(rs_width-1 DOWNTO 0) := (OTHERS => '0');
	signal arith_req		: STD_LOGIC := '0';

	-- Outputs
	signal ReqOut			: STD_LOGIC;
	signal CDB_Q			: STD_LOGIC_VECTOR(rs_width-1 DOWNTO 0);
	signal CDB_V			: STD_LOGIC_VECTOR(reg_size-1 DOWNTO 0);
	signal Avail_RS			: STD_LOGIC;
	signal rq_delayed		: STD_LOGIC;
	signal rs_ready			: STD_LOGIC_VECTOR(2 DOWNTO 0);
	signal rs_busy			: STD_LOGIC_VECTOR(2 DOWNTO 0);
	signal cdbq_comp_zero	: STD_LOGIC;
	signal cdbq_comp_tag	: STD_LOGIC_VECTOR(2 DOWNTO 0);
	signal rs_qj_comp_cdbq	: STD_LOGIC_VECTOR(2 DOWNTO 0);
	signal rs_qk_comp_cdbq	: STD_LOGIC_VECTOR(2 DOWNTO 0);

BEGIN

	-- Instantiate the Unit Under Test (UUT)
	uut : ARITHMETIC_DATA
	generic map(
		reg_size	=> reg_size,
		reg_num		=> reg_num,
		reg_width	=> reg_width,
		rs_num		=> rs_num,
		rs_width	=> rs_width,
		op_width	=> op_width
	)
	PORT MAP (
		CLK			=> CLK,
		RST			=> RST,

		-- from arithmetic_ctl
		WrEn 		=> WrEn,

		-- from CDB
		CDB_Grant	=> CDB_Grant,
		CDB_Q_in	=> CDB_Q_in,
		CDB_V_in	=> CDB_V_in,

		-- Qj, Qk, Vj, Vk, from RF
		stat_data1	=> stat_data1,
		stat_data2	=> stat_data2,
		data1		=> data1,
		data2		=> data2,

		-- from Issue
		Op			=> Op,
		Accepted	=> Accepted,

		-- from arithmetic_ctl
		rs_op_wren		=> rs_op_wren,
		rs_qj_wren		=> rs_qj_wren,
		rs_vj_wren		=> rs_vj_wren,
		rs_qk_wren		=> rs_qk_wren,
		rs_vk_wren		=> rs_vk_wren,
		rs_busy_wren	=> rs_busy_wren,
		rs_busy_wrdata	=> rs_busy_wrdata,
		rs_exec			=> rs_exec,
		arith_tag		=> arith_tag,
		arith_req		=> arith_req,

		-- to arithmetic_ctl
		rq_delayed		=> rq_delayed,
		rs_ready		=> rs_ready,
		rs_busy			=> rs_busy,
		cdbq_comp_zero	=> cdbq_comp_zero,
		cdbq_comp_tag	=> cdbq_comp_tag,
		rs_qj_comp_cdbq	=> rs_qj_comp_cdbq,
		rs_qk_comp_cdbq	=> rs_qk_comp_cdbq,
		avail_rs		=> avail_rs,

		-- to CDB
		ReqOut			=> ReqOut,
		CDB_Q			=> CDB_Q,
		CDB_V			=> CDB_V
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