----------------------------------------------------------------------------------
-- Engineer: 
-- 
-- Create Date:		04/06/2022 
-- Module Name:		PROCESSOR - behv
-- Project Name:	Tomasulo_v1.00
-- Tool versions:
-- Description:
-- 
-- Dependencies: 
-- 
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
--------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.ALL;
--------------------------------------------------------------------------------
entity PROCESSOR is
generic(
	reg_size	: INTEGER := 16;
	reg_num		: INTEGER := 32;
	reg_width	: INTEGER := 5;
	rs_num		: INTEGER := 5+1;
	rs_width	: INTEGER := 3;
	op_width	: INTEGER := 3
);
port(
	CLK 		: IN std_logic;
    RST 		: IN std_logic;
	Issue		: IN std_logic;
	FU_Type		: IN std_logic_vector(1 downto 0);
	Fop_IF		: IN std_logic_vector(2 downto 0);
	Ri_IF		: IN std_logic_vector(4 downto 0);
	Rj_IF		: IN std_logic_vector(4 downto 0);
	Rk_IF		: IN std_logic_vector(4 downto 0);
	Immed_IF	: IN std_logic_vector(reg_size-1 downto 0)
);
end PROCESSOR;
--------------------------------------------------------------------------------
architecture behv of PROCESSOR is

	COMPONENT ISSUE_UNIT
	PORT(
		CLK				: IN std_logic;
		RST				: IN std_logic;

		Issue			: IN  std_logic;

		FU_Type			: IN  std_logic_vector(1 downto 0);
		Fop_IF			: IN  std_logic_vector(2 downto 0);
		Ri_IF			: IN  std_logic_vector(4 downto 0);
		Rj_IF			: IN  std_logic_vector(4 downto 0);
		Rk_IF			: IN  std_logic_vector(4 downto 0);
		Immed_IF		: IN  std_logic_vector(15 downto 0);

		-- from arithmetic and logical
		Avail_RS		: IN  std_logic_vector(1 downto 0);

		-- to arithmetic, logical
		Fop				: OUT std_logic_vector(2 downto 0);
		-- to arithmetic, logical and Register File
		Ri				: OUT std_logic_vector(4 downto 0);
		Rj				: OUT std_logic_vector(4 downto 0);
		Rk				: OUT std_logic_vector(4 downto 0);

		-- to Register File
		Immed			: OUT std_logic_vector(15 downto 0); 

		-- to Register File
		Accepted		: OUT std_logic;
		-- to arithmetic, logical and Register File
		Arith_Issue		: OUT std_logic;
		Logical_Issue	: OUT std_logic;
		Issue_Immed		: OUT std_logic
	);
	END COMPONENT;

	COMPONENT REGISTER_FILE
	GENERIC(
		reg_size	: INTEGER := 16;
		reg_num		: INTEGER := 32;
		reg_width	: INTEGER := 5;
		rs_num		: INTEGER := 5+1;
		rs_width	: INTEGER := 3
	);
	PORT(
		CLK			: IN STD_LOGIC;
		RST			: IN STD_LOGIC;

		rf_wren		: IN STD_LOGIC;

		reg_ard1	: IN STD_LOGIC_VECTOR(reg_width-1 DOWNTO 0);
		reg_ard2	: IN STD_LOGIC_VECTOR(reg_width-1 DOWNTO 0);
		CDB_Q		: IN STD_LOGIC_VECTOR(rs_width-1 DOWNTO 0);
		CDB_V		: IN STD_LOGIC_VECTOR(reg_size-1 DOWNTO 0);

		data1		: OUT STD_LOGIC_VECTOR(reg_size-1 DOWNTO 0);
		data2		: OUT STD_LOGIC_VECTOR(reg_size-1 DOWNTO 0);

		reg_awr		: IN STD_LOGIC_VECTOR(reg_width-1 DOWNTO 0);
		Immed		: IN STD_LOGIC_VECTOR(reg_size-1 DOWNTO 0);
		issue_immed	: IN STD_LOGIC;

		issue_in	: IN STD_LOGIC;

		stat_ard1	: IN STD_LOGIC_VECTOR(reg_width-1 DOWNTO 0);
		stat_ard2	: IN STD_LOGIC_VECTOR(reg_width-1 DOWNTO 0);

		stat_awr	: IN STD_LOGIC_VECTOR(reg_width-1 DOWNTO 0);
		stat_wrdata	: IN STD_LOGIC_VECTOR(rs_width-1 DOWNTO 0);

		stat_data1	: OUT STD_LOGIC_VECTOR(rs_width-1 DOWNTO 0);
		stat_data2	: OUT STD_LOGIC_VECTOR(rs_width-1 DOWNTO 0)
	);
	END COMPONENT;

	COMPONENT ARITHMETIC
	GENERIC(
		reg_size	: INTEGER := 16;
		reg_num		: INTEGER := 32;
		reg_width	: INTEGER := 5;
		rs_num		: INTEGER := 5+1;
		rs_width	: INTEGER := 3;
		op_width	: INTEGER := 3
	);
	PORT(
		CLK			: IN std_logic;
		RST			: IN std_logic;

		-- from CDB
		CDB_grant	: IN std_logic;
		CDB_Q_in	: IN std_logic_vector(rs_width-1 downto 0);
		CDB_V_in	: IN std_logic_vector(reg_size-1 downto 0);

		-- Qj, Qk, Vj, Vk, from RF
		stat_data1	: IN std_logic_vector(rs_width-1 downto 0);
		stat_data2	: IN std_logic_vector(rs_width-1 downto 0);
		data1		: IN std_logic_vector(reg_size-1 downto 0);
		data2		: IN std_logic_vector(reg_size-1 downto 0);

		-- from Issue
		Op			: IN std_logic_vector(op_width-1 downto 0);
		Accepted	: IN std_logic;

		-- to Issue
		Avail_RS	: OUT std_logic;
		
		-- to CDB
		hpr_req		: OUT std_logic;
		ReqOut		: OUT std_logic;
		CDB_Q		: OUT std_logic_vector(rs_width-1 downto 0);
		CDB_V		: OUT std_logic_vector(reg_size-1 downto 0);

		-- to Register File
		sel_RS		: OUT STD_LOGIC_VECTOR(2 DOWNTO 0)
	);
	END COMPONENT;

	COMPONENT LOGICAL
	GENERIC(
		reg_size	: INTEGER := 16;
		reg_num		: INTEGER := 32;
		reg_width	: INTEGER := 5;
		rs_num		: INTEGER := 5+1;
		rs_width	: INTEGER := 3;
		op_width	: INTEGER := 3
	);
	PORT(
		CLK			: IN std_logic;
		RST			: IN std_logic;

		-- from CDB
		CDB_grant	: IN std_logic;
		CDB_Q_in	: IN std_logic_vector(rs_width-1 downto 0);
		CDB_V_in	: IN std_logic_vector(reg_size-1 downto 0);

		-- Qj, Qk, Vj, Vk, from RF
		stat_data1	: IN std_logic_vector(rs_width-1 downto 0);
		stat_data2	: IN std_logic_vector(rs_width-1 downto 0);
		data1		: IN std_logic_vector(reg_size-1 downto 0);
		data2		: IN std_logic_vector(reg_size-1 downto 0);

		-- from Issue
		Op			: IN std_logic_vector(op_width-1 downto 0);
		Accepted	: IN std_logic;

		-- to Issue
		Avail_RS	: OUT std_logic;

		-- to CDB
		hpr_req		: OUT std_logic;
		ReqOut		: OUT std_logic;
		CDB_Q		: OUT std_logic_vector(rs_width-1 downto 0);
		CDB_V		: OUT std_logic_vector(reg_size-1 downto 0);

		-- to Register File
		sel_RS		: OUT std_logic_vector(2 downto 0)
	);
	END COMPONENT;


	COMPONENT CDB
	GENERIC(
		N			: INTEGER := 16;
		Q			: INTEGER := 3
	);
	PORT(
		CLK			: IN std_logic;
		RST			: IN std_logic;
		dev1_val	: IN std_logic_vector(N-1 downto 0);
		dev2_val	: IN std_logic_vector(N-1 downto 0);
		dev3_val	: IN std_logic_vector(N-1 downto 0);
		dev_val_hpr	: IN std_logic_vector(N-1 downto 0);

		dev1_Q		: IN std_logic_vector(Q-1 downto 0);
		dev2_Q		: IN std_logic_vector(Q-1 downto 0);
		dev3_Q		: IN std_logic_vector(Q-1 downto 0);
		dev_q_hpr	: IN std_logic_vector(Q-1 downto 0);

		dev_REQ		: IN std_logic_vector(3 downto 0);
		dev_grant	: OUT std_logic_vector(3 downto 0);

		dev_val_out	: OUT std_logic_vector(N-1 downto 0);
		dev_Q_OUT	: OUT std_logic_vector(Q-1 downto 0)
	);
	END COMPONENT;
	
	COMPONENT MUX_2xN
	GENERIC(n: INTEGER);
	PORT(
		sel		: IN STD_LOGIC;
		Din0	: IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
		Din1	: IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
		Dout	: OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0)
	);
	END COMPONENT;

	signal sig_avail_rs			: std_logic_vector(1 downto 0);

	signal sig_Fop				: std_logic_vector(2 downto 0);
	signal sig_Ri				: std_logic_vector(4 downto 0);
	signal sig_Rj				: std_logic_vector(4 downto 0);
	signal sig_Rk				: std_logic_vector(4 downto 0);
	signal sig_Immed			: std_logic_vector(reg_size-1 downto 0);

	signal sig_Accepted			: std_logic;
	signal sig_Issue_Immed		: std_logic;
	signal sig_Arith_Issue		: std_logic;
	signal sig_Logical_Issue	: std_logic;

	signal sig_CDB_V			: std_logic_vector(reg_size-1 downto 0);
	signal sig_CDB_Q			: std_logic_vector(rs_width-1 downto 0);
	signal sig_dev_grant		: std_logic_vector(3 downto 0);
	signal sig_dev1_val			: std_logic_vector(reg_size-1 downto 0);
	signal sig_dev1_Q			: std_logic_vector(rs_width-1 downto 0);
	signal sig_dev2_val			: std_logic_vector(reg_size-1 downto 0);
	signal sig_dev2_Q			: std_logic_vector(rs_width-1 downto 0);
	signal sig_dev_req			: std_logic_vector(3 downto 0);
	signal sig_data1			: std_logic_vector(reg_size-1 downto 0);
	signal sig_data2			: std_logic_vector(reg_size-1 downto 0);
	signal sig_stat_data1		: std_logic_vector(rs_width-1 downto 0);
	signal sig_stat_data2		: std_logic_vector(rs_width-1 downto 0);

	signal sig_sel_RS			: std_logic_vector(rs_width-1 downto 0);
	signal sig_arith_sel_RS		: std_logic_vector(rs_width-1 downto 0);
	signal sig_log_sel_RS		: std_logic_vector(rs_width-1 downto 0);

	signal sig_dev_val_hpr	: std_logic_vector(reg_size-1 downto 0);
	signal sig_dev_q_hpr	: std_logic_vector(rs_width-1 downto 0);
	signal sig_arith_hpr	: std_logic;
	signal sig_logical_hpr	: std_logic;
	signal mux_sel_hpr		: std_logic;

BEGIN

	issue_unit_inst : ISSUE_UNIT
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

		Avail_RS		=> sig_Avail_RS,

		Fop				=> sig_Fop,
		Ri				=> sig_Ri,
		Rj				=> sig_Rj,
		Rk				=> sig_Rk,
		Immed			=> sig_Immed,

		Accepted		=> sig_Accepted,
		Arith_Issue		=> sig_Arith_Issue,
		Logical_Issue	=> sig_Logical_Issue,
		Issue_Immed		=> sig_Issue_Immed
	);

	register_file_inst : REGISTER_FILE
	PORT MAP(
		CLK			=> CLK,
		RST			=> RST,
		rf_wren		=> '1',

		reg_ard1	=> sig_Rj,
		reg_ard2	=> sig_Rk,

		CDB_Q		=> sig_CDB_Q,
		CDB_V		=> sig_CDB_V,

		data1		=> sig_data1,
		data2		=> sig_data2,
		reg_awr		=> sig_Ri,

		Immed		=> sig_Immed,
		Issue_Immed	=> sig_Issue_Immed,
		issue_in	=> sig_Accepted,

		stat_ard1	=> sig_Rj,
		stat_ard2	=> sig_Rk,
		stat_awr	=> sig_Ri,
		stat_wrdata	=> sig_sel_RS,
		stat_data1	=> sig_stat_data1,
		stat_data2	=> sig_stat_data2
	);


	arithmetic_inst : ARITHMETIC
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

		-- from CDB
		CDB_grant	=> sig_dev_grant(0),
		CDB_Q_in	=> sig_CDB_Q,
		CDB_V_in	=> sig_CDB_V,

		-- Qj, Qk, Vj, Vk, from RF
		stat_data1	=> sig_stat_data1,
		stat_data2	=> sig_stat_data2,
		data1		=> sig_data1,
		data2		=> sig_data2,

		-- from Issue
		Op			=> sig_Fop,
		Accepted	=> sig_Arith_Issue,

		-- to Issue
		Avail_RS	=> sig_Avail_RS(0),

		-- to CDB
		hpr_req		=> sig_arith_hpr,
		ReqOut		=> sig_dev_req(0),
		CDB_Q		=> sig_dev1_Q,
		CDB_V		=> sig_dev1_val,

		-- to Register File
		sel_RS		=>  sig_arith_sel_RS
	);

	logical_inst : LOGICAL
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

		-- from CDB
		CDB_grant	=> sig_dev_grant(1),
		CDB_Q_in	=> sig_CDB_Q,
		CDB_V_in	=> sig_CDB_V,

		-- Qj, Qk, Vj, Vk, from RF
		stat_data1	=> sig_stat_data1,
		stat_data2	=> sig_stat_data2,
		data1		=> sig_data1,
		data2		=> sig_data2,

		-- from Issue
		Op			=> sig_Fop,
		Accepted	=> sig_Logical_Issue,

		-- to Issue
		Avail_RS	=> sig_Avail_RS(1),

		-- to CDB
		hpr_req		=> sig_logical_hpr,
		ReqOut		=> sig_dev_req(1),
		CDB_Q		=> sig_dev2_Q,
		CDB_V		=> sig_dev2_val,

		-- to Register File
		sel_RS		=> sig_log_sel_RS
	);

	sig_dev_req(2) <= '0';

	cdb_inst : CDB
	GENERIC MAP(
		N			=> reg_size,
		Q			=> rs_width
	)
	PORT MAP(
		CLK			=> CLK,
		RST			=> RST,
		dev1_val	=> sig_dev1_val,
		dev2_val	=> sig_dev2_val,
		dev3_val	=> (others => '0'),
		dev_val_hpr	=> sig_dev_val_hpr,

		dev1_Q		=> sig_dev1_Q,
		dev2_Q		=> sig_dev2_Q,
		dev3_Q		=> (others => '0'),
		dev_q_hpr	=> sig_dev_q_hpr,

		dev_REQ		=> sig_dev_req,

		dev_grant	=> sig_dev_grant,
		dev_Q_OUT	=> sig_CDB_Q,
		dev_val_out	=> sig_CDB_V
	);
	
	mux_val_hpr : MUX_2xN
	GENERIC MAP(N => reg_size)
	PORT MAP(
		sel  => mux_sel_hpr,
		Din0 => sig_dev1_val,
		Din1 => sig_dev2_val,
		Dout => sig_dev_val_hpr
	);
	
	mux_q_hpr : MUX_2xN
	GENERIC MAP(N => rs_width)
	PORT MAP(
		sel  => mux_sel_hpr,
		Din0 => sig_dev1_Q,
		Din1 => sig_dev2_Q,
		Dout => sig_dev_q_hpr
	);

	mux_sel_hpr <= '1' WHEN sig_logical_hpr = '1'
					ELSE '0';-- WHEN sig_arith_hpr = '1';

	sig_dev_req(3) <= sig_logical_hpr or sig_arith_hpr;

	sig_sel_RS <= sig_arith_sel_RS 		 WHEN sig_Arith_Issue = '1'
				  ELSE  sig_log_sel_RS   WHEN sig_Logical_Issue = '1' 
				  ELSE (others => '0');

END behv;
--------------------------------------------------------------------------------