--------------------------------------------------------------------------------
-- Engineer: 
-- 
-- Create Date:    13:47:34 05/16/2022 
-- Module Name:    ARITHMETIC - structural 
-- Project Name: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.common.all;
--------------------------------------------------------------------------------
entity ARITHMETIC is
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

	-- from CDB
	CDB_Grant	: IN STD_LOGIC;
	CDB_Q_in	: IN STD_LOGIC_VECTOR(rs_width-1 DOWNTO 0);
	CDB_V_in	: IN STD_LOGIC_VECTOR(reg_size-1 DOWNTO 0);

	-- Qj, Qk, Vj, Vk, from RF
	stat_data1	: IN STD_LOGIC_VECTOR(rs_width-1 DOWNTO 0);
	stat_data2	: IN STD_LOGIC_VECTOR(rs_width-1 DOWNTO 0);
	data1		: IN STD_LOGIC_VECTOR(reg_size-1 DOWNTO 0);
	data2		: IN STD_LOGIC_VECTOR(reg_size-1 DOWNTO 0);

	-- from Issue
	Op			: IN STD_LOGIC_VECTOR(op_width-1 DOWNTO 0);
	Accepted	: IN STD_LOGIC;

	-- to Issue
	Avail_RS	: OUT STD_LOGIC;
	
	-- to CDB
	hpr_req		: OUT STD_LOGIC;
	ReqOut		: OUT STD_LOGIC;
	CDB_Q		: OUT STD_LOGIC_VECTOR(rs_width-1 DOWNTO 0);
	CDB_V		: OUT STD_LOGIC_VECTOR(reg_size-1 DOWNTO 0);

	-- to Register File
	sel_RS		: OUT STD_LOGIC_VECTOR(2 DOWNTO 0)

);
end ARITHMETIC;
--------------------------------------------------------------------------------
architecture structural of ARITHMETIC is

	COMPONENT ARITHMETIC_DATA 
	GENERIC(
		reg_size	: INTEGER := 16;
		reg_num		: INTEGER := 32;
		reg_width	: INTEGER := 5;
		rs_num		: INTEGER := 5+1;
		rs_width	: INTEGER := 3;
		op_width	: INTEGER := 3
	);
	PORT(
		CLK			: IN STD_LOGIC;
		RST			: IN STD_LOGIC;

		-- from arithmetic_ctl
		WrEn 		: IN STD_LOGIC;

		-- from CDB
		CDB_Grant	: IN STD_LOGIC;
		CDB_Q_in	: IN STD_LOGIC_VECTOR(rs_width-1 DOWNTO 0);
		CDB_V_in	: IN STD_LOGIC_VECTOR(reg_size-1 DOWNTO 0);

		-- Qj, Qk, Vj, Vk, from RF
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

		-- to arithmetic_ctl
		rs_ready		: OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
		rs_busy			: OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
		rq_delayed		: OUT STD_LOGIC;
		cdbq_comp_zero	: OUT STD_LOGIC;
		cdbq_comp_tag	: OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
		rs_qj_comp_cdbq	: OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
		rs_qk_comp_cdbq	: OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
		avail_rs		: OUT STD_LOGIC
	);
	END COMPONENT;

	COMPONENT ARITHMETIC_CTL
	GENERIC(rs_width : integer := 3);
	PORT(
		CLK				: IN STD_LOGIC;
		RST				: IN STD_LOGIC;

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
		sel_RS			: OUT STD_LOGIC_VECTOR(rs_width-1 DOWNTO 0);
		arith_wren		: OUT STD_LOGIC;
		arith_req		: OUT STD_LOGIC
	);
	END COMPONENT;

	-- signal declarations
	SIGNAL sig_rs_op_wren		: STD_LOGIC_VECTOR(2 DOWNTO 0);
	SIGNAL sig_rs_qj_wren		: STD_LOGIC_VECTOR(2 DOWNTO 0);
	SIGNAL sig_rs_vj_wren		: STD_LOGIC_VECTOR(2 DOWNTO 0);
	SIGNAL sig_rs_qk_wren		: STD_LOGIC_VECTOR(2 DOWNTO 0);
	SIGNAL sig_rs_vk_wren		: STD_LOGIC_VECTOR(2 DOWNTO 0);
	SIGNAL sig_rs_busy_wren		: STD_LOGIC_VECTOR(2 DOWNTO 0);
	SIGNAL sig_rs_busy_wrdata	: STD_LOGIC_VECTOR(2 DOWNTO 0);
	SIGNAL sig_rs_ready			: STD_LOGIC_VECTOR(2 DOWNTO 0);
	SIGNAL sig_rs_busy			: STD_LOGIC_VECTOR(2 DOWNTO 0);
	SIGNAL sig_rs_exec			: STD_LOGIC_VECTOR(2 downto 0);
	SIGNAL sig_arith_wren		: STD_LOGIC;
	SIGNAL sig_arith_tag		: STD_LOGIC_VECTOR(rs_width-1 downto 0);
	SIGNAL sig_arith_req		: STD_LOGIC;
	SIGNAL sig_rq_delayed		: STD_LOGIC;

	SIGNAL sig_cdbq_comp_zero	: STD_LOGIC;
	SIGNAL sig_cdbq_comp_tag	: STD_LOGIC_VECTOR(2 DOWNTO 0);
	SIGNAL sig_rs_qj_comp_cdbq	: STD_LOGIC_VECTOR(2 DOWNTO 0);
	SIGNAL sig_rs_qk_comp_cdbq	: STD_LOGIC_VECTOR(2 DOWNTO 0);

begin

	arith_data : ARITHMETIC_DATA
	generic map(
		reg_size	=> reg_size,
		reg_num		=> reg_num,
		reg_width	=> reg_width,
		rs_num		=> rs_num,
		rs_width	=> rs_width,
		op_width	=> op_width
	)
	port map(
		CLK			=> CLK,
		RST			=> RST,

		-- from arithmetic_ctl
		WrEn 		=> sig_arith_wren,

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
		rs_op_wren		=> sig_rs_op_wren,
		rs_qj_wren		=> sig_rs_qj_wren,
		rs_vj_wren		=> sig_rs_vj_wren,
		rs_qk_wren		=> sig_rs_qk_wren,
		rs_vk_wren		=> sig_rs_vk_wren,
		rs_busy_wren	=> sig_rs_busy_wren,
		rs_busy_wrdata	=> sig_rs_busy_wrdata,
		rs_exec			=> sig_rs_exec,
		arith_tag		=> sig_arith_tag,
		arith_req		=> sig_arith_req,

		-- to arithmetic_ctl
		rq_delayed		=> sig_rq_delayed,
		rs_ready		=> sig_rs_ready,
		rs_busy			=> sig_rs_busy,
		cdbq_comp_zero	=> sig_cdbq_comp_zero,
		cdbq_comp_tag	=> sig_cdbq_comp_tag,
		rs_qj_comp_cdbq	=> sig_rs_qj_comp_cdbq,
		rs_qk_comp_cdbq	=> sig_rs_qk_comp_cdbq,
		avail_rs		=> avail_rs,

		-- to CDB
		ReqOut			=> ReqOut,
		CDB_Q			=> CDB_Q,
		CDB_V			=> CDB_V
	);

	artith_ctl : ARITHMETIC_CTL
	generic map(rs_width => rs_width)
	port map(
		CLK				=> CLK,
		RST				=> RST,

		-- from Issue
		Accepted		=> Accepted,

		-- from CDB
		CDB_Grant		=> CDB_Grant,

		-- comparators in logical_data
		cdbq_comp_zero	=> sig_cdbq_comp_zero,
		cdbq_comp_tag	=> sig_cdbq_comp_tag,
		rs_qj_comp_cdbq	=> sig_rs_qj_comp_cdbq,
		rs_qk_comp_cdbq	=> sig_rs_qk_comp_cdbq,

		-- from logical_data
		rq_delayed		=> sig_rq_delayed,
		rs_ready		=> sig_rs_ready,
		busy			=> sig_rs_busy,

		-- to logical_data
		rs_op_wren		=> sig_rs_op_wren,
		rs_qj_wren		=> sig_rs_qj_wren,
		rs_vj_wren		=> sig_rs_vj_wren,
		rs_qk_wren		=> sig_rs_qk_wren,
		rs_vk_wren		=> sig_rs_vk_wren,
		rs_busy_wren	=> sig_rs_busy_wren,
		rs_busy_wrdata	=> sig_rs_busy_wrdata,
		rs_exec			=> sig_rs_exec,
		sel_RS			=> sel_RS,
		arith_tag		=> sig_arith_tag,
		arith_wren		=> sig_arith_wren,
		arith_req		=> sig_arith_req
	);

	hpr_req <= NOT sig_arith_wren;

end structural;
--------------------------------------------------------------------------------