--------------------------------------------------------------------------------
-- Engineer:
-- 
-- Create Date:		04/06/2022
-- Module Name:		LOGICAL_CTL - behv
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
--------------------------------------------------------------------------------
entity LOGICAL_CTL is
generic(
	rs_width		: integer := 3
);
port(
	CLK				: IN STD_LOGIC;
	RST				: IN STD_LOGIC;

	-- from Issue
	Accepted		: IN STD_LOGIC;

	-- from CDB
	CDB_Grant		: IN STD_LOGIC;

	-- comparators in logical_data
	cdbq_comp_zero	: IN STD_LOGIC;
	cdbq_comp_tag	: IN STD_LOGIC_VECTOR(1 DOWNTO 0);-- to zero an RS when an instruction is finished
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
end LOGICAL_CTL;
--------------------------------------------------------------------------------
architecture behv of LOGICAL_CTL is

	COMPONENT LOG_RS_SEL
	PORT(
		Busy		: IN  STD_LOGIC_VECTOR(1 downto 0);
		RS_wren		: OUT STD_LOGIC_VECTOR(1 downto 0);
		Tag			: OUT std_logic_vector(2 downto 0)
	);
	END COMPONENT;

	COMPONENT LOG_EXECUTION_SEL
	PORT(
		ready		: IN  std_logic_vector(1 downto 0);
		rs_exec		: OUT std_logic_vector(1 downto 0);
		tag			: OUT std_logic_vector(rs_width-1 downto 0)
	);
	END COMPONENT;

	COMPONENT REG
	GENERIC(N : INTEGER := 1);
	PORT(
		CLK		: IN  std_logic;
		RST		: IN  std_logic;
		WrEn	: IN  std_logic;
		D		: IN  std_logic_vector(N-1 downto 0);
		Q		: OUT std_logic_vector(N-1 downto 0)
	);
	END COMPONENT;

	signal sig_rs_op_wren	: std_logic_vector(1 downto 0);
	signal sig_rs_wren		: std_logic_vector(1 downto 0);
	signal logical_issue_del : std_logic;

begin

	rs_sel : LOG_RS_SEL
	PORT MAP(
		busy	=> busy,
		rs_wren	=> sig_rs_wren,
		Tag		=> sel_RS
	);

	exec_sel : LOG_EXECUTION_SEL 
	PORT MAP(
		ready	=> rs_ready,
		rs_exec	=> rs_exec,
		tag		=> logical_tag
	);

	issue_delay : REG
	PORT MAP(
		CLK		=> CLK,
		RST		=> RST,
		WrEn	=> '1',
		D(0)	=> Accepted,
		Q(0)	=> logical_issue_del
	);

	sig_rs_op_wren(0) <= Accepted AND sig_rs_wren(0);
	sig_rs_op_wren(1) <= Accepted AND sig_rs_wren(1);

	-- outputs
	rs_op_wren <= sig_rs_op_wren;

	-- for RS1
	rs_qj_wren(0) <= sig_rs_op_wren(0) OR (rs_qj_comp_cdbq(0) AND (NOT cdbq_comp_zero));
	rs_qk_wren(0) <= sig_rs_op_wren(0) OR (rs_qk_comp_cdbq(0) AND (NOT cdbq_comp_zero));
	rs_vj_wren(0) <= sig_rs_op_wren(0) OR (rs_qj_comp_cdbq(0) AND (NOT cdbq_comp_zero));
	rs_vk_wren(0) <= sig_rs_op_wren(0) OR (rs_qk_comp_cdbq(0) AND (NOT cdbq_comp_zero));

	-- for RS2
	rs_qj_wren(1) <= sig_rs_op_wren(1) OR (rs_qj_comp_cdbq(1) AND (NOT cdbq_comp_zero));
	rs_qk_wren(1) <= sig_rs_op_wren(1) OR (rs_qk_comp_cdbq(1) AND (NOT cdbq_comp_zero));
	rs_vj_wren(1) <= sig_rs_op_wren(1) OR (rs_qj_comp_cdbq(1) AND (NOT cdbq_comp_zero));
	rs_vk_wren(1) <= sig_rs_op_wren(1) OR (rs_qk_comp_cdbq(1) AND (NOT cdbq_comp_zero));

	rs_busy_wren(0) <= '1' WHEN sig_rs_op_wren(0) = '1' OR cdbq_comp_tag(0) = '1'
					ELSE '0';

	rs_busy_wren(1) <= '1' WHEN sig_rs_op_wren(1) = '1' OR cdbq_comp_tag(1) = '1'
					ELSE '0';

	rs_busy_wrdata(0) <= '1' WHEN sig_rs_op_wren(0) = '1'
					ELSE '0';

	rs_busy_wrdata(1) <= '1' WHEN sig_rs_op_wren(1) = '1'
					ELSE '0';

	logical_wren <= '0' WHEN CDB_Grant = '0' AND rq_delayed = '1'
				ELSE '1';

	logical_req <= rs_ready(0) OR rs_ready(1); 


end behv;
--------------------------------------------------------------------------------