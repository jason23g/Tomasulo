--------------------------------------------------------------------------------
-- Engineer:
-- 
-- Create Date:		04/06/2022
-- Module Name:		LOGICAL_DATA - behv
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
entity LOGICAL_DATA is
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

	-- to Issue
	Avail_RS		: OUT STD_LOGIC;

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
	rs_qk_comp_cdbq	: OUT STD_LOGIC_VECTOR(1 DOWNTO 0)
);
end LOGICAL_DATA;
--------------------------------------------------------------------------------
architecture behv of LOGICAL_DATA is

	COMPONENT RESERVATION_STATION
	GENERIC(
		reg_size	: INTEGER := 16;
		rs_width	: INTEGER := 3;
		op_width	: INTEGER := 3
	);
	PORT(
		CLK			: IN  STD_LOGIC;
		RST			: IN  STD_LOGIC;

		OpWrData	: IN  STD_LOGIC_VECTOR(op_width-1 DOWNTO 0);
		OpWrEn		: IN  STD_LOGIC;

		QjWrData	: IN  STD_LOGIC_VECTOR(rs_width-1 DOWNTO 0);
		QjWrEn		: IN  STD_LOGIC;
		QkWrData	: IN  STD_LOGIC_VECTOR(rs_width-1 DOWNTO 0);
		QkWrEn		: IN  STD_LOGIC;
		VjWrData	: IN  STD_LOGIC_VECTOR(reg_size-1 DOWNTO 0);
		VjWrEn		: IN  STD_LOGIC;
		VkWrData	: IN  STD_LOGIC_VECTOR(reg_size-1 DOWNTO 0);
		VkWrEn		: IN  STD_LOGIC;

		BusyWrData	: IN  STD_LOGIC;
		BusyWrEn	: IN  STD_LOGIC;

		Op			: OUT STD_LOGIC_VECTOR(op_width-1 DOWNTO 0);

		Qj			: OUT STD_LOGIC_VECTOR(rs_width-1 DOWNTO 0);
		Qk			: OUT STD_LOGIC_VECTOR(rs_width-1 DOWNTO 0);
		Vj			: OUT STD_LOGIC_VECTOR(reg_size-1 DOWNTO 0);
		Vk			: OUT STD_LOGIC_VECTOR(reg_size-1 DOWNTO 0);

		Busy		: OUT STD_LOGIC;
		Ready		: OUT STD_LOGIC
	);
	END COMPONENT;


	COMPONENT LOGICAL_UNIT
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
	end component;


	COMPONENT MUX_2xN
	GENERIC(N : INTEGER);
	PORT(
		sel		: IN STD_LOGIC;
		Din0	: IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
		Din1	: IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
		Dout	: OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0)
	);
	END COMPONENT;


	COMPONENT COMPARATOR
	GENERIC(N : INTEGER);
	PORT(
		A		: IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
		B		: IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
		eq		: OUT STD_LOGIC
	);
	END COMPONENT;

	COMPONENT REG
	GENERIC(N : INTEGER);
	PORT(
		CLK		: IN STD_LOGIC;
		RST		: IN STD_LOGIC;
		WrEn	: IN STD_LOGIC;
		D		: IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
		Q		: OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0)
	);
	END COMPONENT;


	-- signal declarations

	-- RS1
	signal rs1_qj_wrdata	: std_logic_vector(rs_width-1 downto 0);
	signal rs1_qk_wrdata	: std_logic_vector(rs_width-1 downto 0);
	signal rs1_vj_wrdata	: std_logic_vector(reg_size-1 downto 0);
	signal rs1_vk_wrdata	: std_logic_vector(reg_size-1 downto 0);

	signal rs1_op			: std_logic_vector(op_width-1 downto 0);
	signal rs1_qj			: std_logic_vector(rs_width-1 downto 0);
	signal rs1_qk			: std_logic_vector(rs_width-1 downto 0);
	signal rs1_vj			: std_logic_vector(reg_size-1 downto 0);
	signal rs1_vk			: std_logic_vector(reg_size-1 downto 0);
	signal rs1_busy			: std_logic;

	signal rs1_qj_comp_cdbq : std_logic;
	signal rs1_qk_comp_cdbq : std_logic;

	-- RS2
	signal rs2_qj_wrdata	: std_logic_vector(rs_width-1 downto 0);
	signal rs2_qk_wrdata	: std_logic_vector(rs_width-1 downto 0);
	signal rs2_vj_wrdata	: std_logic_vector(reg_size-1 downto 0);
	signal rs2_vk_wrdata	: std_logic_vector(reg_size-1 downto 0);

	signal rs2_op			: std_logic_vector(op_width-1 downto 0);
	signal rs2_qj			: std_logic_vector(rs_width-1 downto 0);
	signal rs2_qk			: std_logic_vector(rs_width-1 downto 0);
	signal rs2_vj			: std_logic_vector(reg_size-1 downto 0);
	signal rs2_vk			: std_logic_vector(reg_size-1 downto 0);
	signal rs2_busy			: std_logic;

	signal rs2_qj_comp_cdbq : std_logic;
	signal rs2_qk_comp_cdbq : std_logic;

	signal sig_cdbq_comp_zero : std_logic;

	-- MUX
	signal sel_qj_rs1 : std_logic;
	signal sel_qk_rs1 : std_logic;
	signal sel_vj_rs1 : std_logic;
	signal sel_vk_rs1 : std_logic;

	signal sel_qj_rs2 : std_logic;
	signal sel_qk_rs2 : std_logic;
	signal sel_vj_rs2 : std_logic;
	signal sel_vk_rs2 : std_logic;

	-- logical_unit
	signal logical_reqOut	: std_logic;
	signal logical_A		: std_logic_vector(reg_size-1 downto 0);
	signal logical_B		: std_logic_vector(reg_size-1 downto 0);
	signal logical_Op		: std_logic_vector(op_width-1 downto 0);
	signal sig_rq_delayed	: std_logic;

begin


	RS1 : RESERVATION_STATION
	GENERIC MAP(
		reg_size => reg_size,
		rs_width => rs_width,
		op_width => op_width
	)
	PORT MAP(
		CLK			=> CLK,
		RST			=> RST,

		OpWrData	=> Op,
		OpWrEn		=> rs_op_wren(0),

		QjWrData	=> rs1_qj_wrdata,
		QjWrEn		=> rs_qj_wren(0),
		QkWrData	=> rs1_qk_wrdata,
		QkWrEn		=> rs_qk_wren(0),
		VjWrData	=> rs1_vj_wrdata,
		VjWrEn		=> rs_vj_wren(0),
		VkWrData	=> rs1_vk_wrdata,
		VkWrEn		=> rs_vk_wren(0),

		BusyWrData	=> rs_busy_wrdata(0),
		BusyWrEn	=> rs_busy_wren(0),

		Op			=> rs1_op,
		Qj			=> rs1_qj,
		Qk			=> rs1_qk,
		Vj			=> rs1_vj,
		Vk			=> rs1_vk,

		Busy		=> rs1_busy,
		Ready		=> rs_ready(0)
	);

	rs1_qj_comp_cdbq_inst : COMPARATOR
	GENERIC MAP(N => rs_width)
	PORT MAP(
		A	=> rs1_qj,
		B	=> CDB_Q_in,
		eq	=> rs1_qj_comp_cdbq
	);

	rs1_qk_comp_cdbq_inst : COMPARATOR
	GENERIC MAP(N => rs_width)
	PORT MAP(
		A	=> rs1_qk,
		B	=> CDB_Q_in,
		eq	=> rs1_qk_comp_cdbq
	);

	cdbq_comp_tag1_inst : COMPARATOR
	GENERIC MAP(N => rs_width)
	PORT MAP(
		A	=> CDB_Q_in,
		B	=> "100",
		eq	=> cdbq_comp_tag(0)
	);

	RS2 : RESERVATION_STATION
	GENERIC MAP(
		reg_size => reg_size,
		rs_width => rs_width,
		op_width => op_width
	)
	PORT MAP(
		CLK			=> CLK,
		RST			=> RST,

		OpWrData	=> Op,
		OpWrEn		=> rs_op_wren(1),

		QjWrData	=> rs2_qj_wrdata,
		QjWrEn		=> rs_qj_wren(1),
		QkWrData	=> rs2_qk_wrdata,
		QkWrEn		=> rs_qk_wren(1),
		VjWrData	=> rs2_vj_wrdata,
		VjWrEn		=> rs_vj_wren(1),
		VkWrData	=> rs2_vk_wrdata,
		VkWrEn		=> rs_vk_wren(1),

		BusyWrData	=> rs_busy_wrdata(1),
		BusyWrEn	=> rs_busy_wren(1),

		Op			=> rs2_op,
		Qj			=> rs2_qj,
		Qk			=> rs2_qk,
		Vj			=> rs2_vj,
		Vk			=> rs2_vk,

		Busy		=> rs2_busy,
		Ready		=> rs_ready(1)
	);


	rs2_qj_comp_cdbq_inst : COMPARATOR
	GENERIC MAP(N => rs_width)
	PORT MAP(
		A	=> rs2_qj,
		B	=> CDB_Q_in,
		eq	=> rs2_qj_comp_cdbq
	);

	rs2_qk_comp_cdbq_inst : COMPARATOR
	GENERIC MAP(N => rs_width)
	PORT MAP(
		A	=> rs2_qk,
		B	=> CDB_Q_in,
		eq	=> rs2_qk_comp_cdbq
	);

	cdbq_comp_tag2_inst : COMPARATOR
	GENERIC MAP(N => rs_width)
	PORT MAP(
		A	=> CDB_Q_in,
		B	=> "101",
		eq	=> cdbq_comp_tag(1)
	);

	cdbq_comp_zero_inst : COMPARATOR
	GENERIC MAP(N => rs_width)
	PORT MAP(
		A	=> CDB_Q_in,
		B	=> (OTHERS => '0'),
		eq	=> sig_cdbq_comp_zero
	);


	logical_u : LOGICAL_UNIT
	GENERIC MAP(
		reg_size => reg_size,
		rs_width => rs_width,
		op_width => op_width
	)
	PORT MAP(
		CLK		=> CLK,
		RST		=> RST,

		WrEn	=> WrEn,
		ReqIn	=> logical_req,
		Tag		=> logical_tag,
		A		=> logical_A,
		B		=> logical_B,
		Op		=> logical_Op,
		Result	=> CDB_V,
		TagOut	=> CDB_Q,
		ReqOut	=> logical_reqOut
	);

	pipe_rq : REG
	GENERIC MAP(N => 1)
	PORT MAP(
		CLK		=> CLK,
		RST		=> RST,
		WrEn	=> '1',
		D(0)	=> logical_reqOut,
		Q(0)	=> rq_delayed
	);


	logical_A <=	rs1_vj WHEN rs_exec = "01" 
			ELSE	rs2_vj WHEN	rs_exec = "10"
			ELSE	(OTHERS => '0');

	logical_B <=	rs1_vk WHEN rs_exec = "01" 
			ELSE	rs2_vk WHEN	rs_exec = "10"
			ELSE	(OTHERS => '0');

	logical_Op <=	rs1_op WHEN rs_exec = "01" 
			ELSE	rs2_op WHEN	rs_exec = "10"
			ELSE	(OTHERS => '0');


	sel_qj_rs1 <= NOT (rs1_qj_comp_cdbq AND (NOT sig_cdbq_comp_zero));
	sel_qk_rs1 <= NOT (rs1_qk_comp_cdbq AND (NOT sig_cdbq_comp_zero));
	sel_vj_rs1 <= rs1_qj_comp_cdbq AND (NOT sig_cdbq_comp_zero);
	sel_vk_rs1 <= rs1_qk_comp_cdbq AND (NOT sig_cdbq_comp_zero);

	sel_qj_rs2 <= NOT (rs2_qj_comp_cdbq AND (NOT sig_cdbq_comp_zero));
	sel_qk_rs2 <= NOT (rs2_qk_comp_cdbq AND (NOT sig_cdbq_comp_zero));
	sel_vj_rs2 <= rs2_qj_comp_cdbq AND (NOT sig_cdbq_comp_zero);
	sel_vk_rs2 <= rs2_qk_comp_cdbq AND (NOT sig_cdbq_comp_zero);


	mux_qj_rs1 : MUX_2xN
	GENERIC MAP(N => rs_width)
	PORT MAP(
		sel =>  sel_qj_rs1,
		Din0 => (others => '0'),
		Din1 => stat_data1,
		Dout => rs1_qj_wrdata
	);

	mux_qk_rs1 : MUX_2xN
	GENERIC MAP(N => rs_width)
	PORT MAP(
		sel =>  sel_qk_rs1,
		Din0 => (others => '0'),
		Din1 => stat_data2,
		Dout => rs1_qk_wrdata
	);

	mux_qj_rs2 : MUX_2xN
	GENERIC MAP(N => rs_width)
	PORT MAP(
		sel =>  sel_qj_rs2,
		Din0 => (others => '0'),
		Din1 => stat_data1,
		Dout => rs2_qj_wrdata
	);

	mux_qk_rs2 : MUX_2xN
	GENERIC MAP(N => rs_width)
	PORT MAP(
		sel =>  sel_qk_rs2,
		Din0 => (others => '0'),
		Din1 => stat_data2,
		Dout => rs2_qk_wrdata
	);
	
	mux_vj_rs1 : MUX_2xN
	GENERIC MAP(N => reg_size)
	PORT MAP(
		sel => sel_vj_rs1,
		Din0 => data1,
		Din1 => CDB_V_in,
		Dout => rs1_vj_wrdata
	);

	mux_vk_rs1 : MUX_2xN
	GENERIC MAP(N => reg_size)
	PORT MAP(
		sel => sel_vk_rs1,
		Din0 => data2,
		Din1 => CDB_V_in,
		Dout => rs1_vk_wrdata
	);

	mux_vj_rs2 : MUX_2xN
	GENERIC MAP(N => reg_size)
	PORT MAP(
		sel => sel_vj_rs2,
		Din0 => data1,
		Din1 => CDB_V_in,
		Dout => rs2_vj_wrdata
	);

	mux_vk_rs2 : MUX_2xN
	GENERIC MAP(N => reg_size)
	PORT MAP(
		sel => sel_vk_rs2,
		Din0 => data2,
		Din1 => CDB_V_in,
		Dout => rs2_vk_wrdata
	);

	-- connect internal signals to outputs
	ReqOut				<= logical_reqOut;
	cdbq_comp_zero		<= sig_cdbq_comp_zero;
	rs_qj_comp_cdbq(0)	<= rs1_qj_comp_cdbq;
	rs_qj_comp_cdbq(1)	<= rs2_qj_comp_cdbq;
	rs_qk_comp_cdbq(0)	<= rs1_qk_comp_cdbq;
	rs_qk_comp_cdbq(1)	<= rs2_qk_comp_cdbq;
	rs_busy(0)			<= rs1_busy;
	rs_busy(1)			<= rs2_busy;
	Avail_RS			<= (NOT rs1_busy) OR (NOT rs2_busy);

end behv;
--------------------------------------------------------------------------------