--------------------------------------------------------------------------------
-- Engineer:
-- 
-- Create Date:		16/05/2022 
-- Module Name:		LOGICAL - structural
-- Project Name:	Tomasulo_v1.00
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
entity LOGICAL is
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
	avail_rs	: OUT STD_LOGIC;

	-- to CDB
	hpr_req		: OUT STD_LOGIC;
	ReqOut		: OUT STD_LOGIC;
	CDB_Q		: OUT STD_LOGIC_VECTOR(rs_width-1 DOWNTO 0);
	CDB_V		: OUT STD_LOGIC_VECTOR(reg_size-1 DOWNTO 0);

	-- to Register File
	sel_RS			: OUT std_logic_vector(2 downto 0)
);
end LOGICAL;
--------------------------------------------------------------------------------
architecture structural of LOGICAL is

	component LOGICAL_DATA
	generic(
		reg_size	: INTEGER := 16;
		reg_num		: INTEGER := 32;
		reg_width	: INTEGER := 5;
		rs_num		: INTEGER := 5+1;
		rs_width	: INTEGER := 3;
		op_width	: INTEGER := 3
	);
	port(
		CLK				: IN STD_LOGIC;
		RST				: IN STD_LOGIC;

		-- from logical_ctl
		WrEn			: IN STD_LOGIC;

		-- from CDB
		CDB_Grant		: IN STD_LOGIC;
		CDB_Q_in		: IN STD_LOGIC_VECTOR(rs_width-1 DOWNTO 0);
		CDB_V_in		: IN STD_LOGIC_VECTOR(reg_size-1 DOWNTO 0);

		-- Qj, Qk, Vj, Vk, from Register File
		stat_data1		: IN STD_LOGIC_VECTOR(rs_width-1 DOWNTO 0);
		stat_data2		: IN STD_LOGIC_VECTOR(rs_width-1 DOWNTO 0);
		data1			: IN STD_LOGIC_VECTOR(reg_size-1 DOWNTO 0);
		data2			: IN STD_LOGIC_VECTOR(reg_size-1 DOWNTO 0);

		-- from Issue
		Op				: IN STD_LOGIC_VECTOR(op_width-1 DOWNTO 0);
		Accepted		: IN STD_LOGIC;

		-- from logical_ctl
		rs_op_wren		: IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		rs_qj_wren		: IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		rs_vj_wren		: IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		rs_qk_wren		: IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		rs_vk_wren		: IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		rs_busy_wren	: IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		rs_busy_wrdata	: IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		rs_exec			: IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		logical_tag		: IN STD_LOGIC_VECTOR(rs_width-1 DOWNTO 0);
		logical_req		: IN STD_LOGIC;

		-- to CDB
		ReqOut			: OUT STD_LOGIC;
		CDB_Q			: OUT STD_LOGIC_VECTOR(rs_width-1 DOWNTO 0);
		CDB_V			: OUT STD_LOGIC_VECTOR(reg_size-1 DOWNTO 0);

		-- to logical_ctl
		rs_busy			: OUT STD_LOGIC_VECTOR(1 downto 0);
		rs_ready		: OUT STD_LOGIC_VECTOR(1 downto 0);
		rq_delayed		: OUT STD_LOGIC;
		cdbq_comp_zero	: OUT STD_LOGIC;
		cdbq_comp_tag	: OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
		rs_qj_comp_cdbq	: OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
		rs_qk_comp_cdbq	: OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
		avail_rs		: OUT STD_LOGIC
	);
	end component;

	component LOGICAL_CTL
	generic(rs_width		: integer := 3);
	port(
		CLK				: IN STD_LOGIC;
		RST				: IN STD_LOGIC;

		-- from Issue
		Accepted		: IN STD_LOGIC;

		-- from CDB
		CDB_Grant		: IN STD_LOGIC;

		-- comparators in logical_data
		cdbq_comp_zero	: IN STD_LOGIC;
		cdbq_comp_tag	: IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		rs_qj_comp_cdbq	: IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		rs_qk_comp_cdbq	: IN STD_LOGIC_VECTOR(1 DOWNTO 0);

		-- from logical_data
		rs_ready		: IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		busy			: IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		rq_delayed		: IN STD_LOGIC;

		-- to logical_data
		rs_op_wren		: OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
		rs_qj_wren		: OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
		rs_vj_wren		: OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
		rs_qk_wren		: OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
		rs_vk_wren		: OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
		rs_busy_wren	: OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
		rs_busy_wrdata	: OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
		rs_exec			: OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
		logical_tag		: OUT STD_LOGIC_VECTOR(rs_width-1 DOWNTO 0);
		logical_wren	: OUT STD_LOGIC;
		logical_req		: OUT STD_LOGIC;

		-- to Register File
		sel_RS			: OUT std_logic_vector(2 downto 0)
	);
	end component;

	-- signal declarations
	signal sig_rs_op_wren		: std_logic_vector(1 downto 0);
	signal sig_rs_qj_wren		: std_logic_vector(1 downto 0);
	signal sig_rs_vj_wren		: std_logic_vector(1 downto 0);
	signal sig_rs_qk_wren		: std_logic_vector(1 downto 0);
	signal sig_rs_vk_wren		: std_logic_vector(1 downto 0);
	signal sig_rs_busy_wren		: std_logic_vector(1 downto 0);
	signal sig_rs_busy_wrdata	: std_logic_vector(1 downto 0);
	signal sig_rs_exec			: std_logic_vector(1 downto 0);
	signal sig_logical_wren		: std_logic;
	signal sig_logical_tag		: std_logic_vector(rs_width-1 downto 0);
	signal sig_logical_req		: std_logic;
	signal sig_cdbq_comp_zero	: std_logic;
	signal sig_cdbq_comp_tag	: std_logic_vector(1 downto 0);
	signal sig_rs_qj_comp_cdbq	: std_logic_vector(1 downto 0);
	signal sig_rs_qk_comp_cdbq	: std_logic_vector(1 downto 0);
	signal sig_rq_delayed		: std_logic;
	signal sig_rs_ready			: std_logic_vector(1 downto 0);
	signal sig_rs_busy			: std_logic_vector(1 downto 0);

begin

	logical_data_inst : LOGICAL_DATA
	generic map(
		reg_size	=> reg_size,
		reg_num		=> reg_num,
		reg_width	=> reg_width,
		rs_num		=> rs_num,
		rs_width	=> rs_width,
		op_width	=> op_width
	)
	port map(
		CLK				=> CLK,
		RST				=> RST,

		-- from logical_ctl
		WrEn			=> sig_logical_wren,

		-- from CDB
		CDB_Grant		=> CDB_Grant,
		CDB_Q_in		=> CDB_Q_in,
		CDB_V_in		=> CDB_V_in,

		-- Qj, Qk, Vj, Vk, from RF
		stat_data1		=> stat_data1,
		stat_data2		=> stat_data2,
		data1			=> data1,
		data2			=> data2,

		-- from Issue
		Op				=> Op,
		Accepted		=> Accepted,

		-- from logical_ctl
		rs_op_wren		=> sig_rs_op_wren,
		rs_qj_wren		=> sig_rs_qj_wren,
		rs_vj_wren		=> sig_rs_vj_wren,
		rs_qk_wren		=> sig_rs_qk_wren,
		rs_vk_wren		=> sig_rs_vk_wren,
		rs_busy_wren	=> sig_rs_busy_wren,
		rs_busy_wrdata	=> sig_rs_busy_wrdata,
		rs_exec			=> sig_rs_exec,
		logical_tag		=> sig_logical_tag,
		logical_req		=> sig_logical_req,

		-- to logical_ctl
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

	logical_ctl_inst : LOGICAL_CTL
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
		logical_tag		=> sig_logical_tag,
		logical_wren	=> sig_logical_wren,
		logical_req		=> sig_logical_req,

		-- to Register File
		sel_RS			=> sel_RS
	);

	hpr_req <= NOT sig_logical_wren;

end structural;
--------------------------------------------------------------------------------