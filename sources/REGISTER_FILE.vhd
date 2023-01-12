--------------------------------------------------------------------------------
-- Engineer: 		PANOS VASILEIOU & JASON GEORGAKAS
-- 
-- Create Date:		13/05/2022
-- Design Name: 	structural
-- Module Name:		REGISTER_FILE
-- Project Name: 	Tomasulo_v1.00
-- Tool versions: 	ISE Project Navigator (P.20131013)
-- Description:
-- 
-- 
--
-- Dependencies: 	REG
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
--------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE work.common.all;
--------------------------------------------------------------------------------
ENTITY REGISTER_FILE IS
GENERIC(
	reg_size	: INTEGER := 16;
	reg_num		: INTEGER := 32;
	reg_width	: INTEGER := 5;
	rs_num		: INTEGER := 5+1;
	rs_width	: INTEGER := 3
);
PORT(
	CLK			: IN STD_LOGIC;
	RST			: IN STD_LOGIC;--reset the whole RF

	rf_wren		: IN STD_LOGIC;--to write a reg

	reg_ard1	: IN STD_LOGIC_VECTOR(reg_width-1 DOWNTO 0);--to read rs
	reg_ard2	: IN STD_LOGIC_VECTOR(reg_width-1 DOWNTO 0);--to read rt
	CDB_Q		: IN STD_LOGIC_VECTOR(rs_width-1 DOWNTO 0);--to compare with every status
	CDB_V		: IN STD_LOGIC_VECTOR(reg_size-1 DOWNTO 0);--to write the CDB value.

	data1		: OUT STD_LOGIC_VECTOR(reg_size-1 DOWNTO 0);--rs
	data2		: OUT STD_LOGIC_VECTOR(reg_size-1 DOWNTO 0);--rt

	reg_awr		: IN STD_LOGIC_VECTOR(reg_width-1 DOWNTO 0);--to write the value of a reg
	Immed		: IN STD_LOGIC_VECTOR(reg_size-1 DOWNTO 0);--to write the immediate value.
	issue_immed	: IN STD_LOGIC;--to write a reg immediate

	issue_in	: IN STD_LOGIC;--to write a reg status

	stat_ard1	: IN STD_LOGIC_VECTOR(reg_width-1 DOWNTO 0);--to read the status of rs
	stat_ard2	: IN STD_LOGIC_VECTOR(reg_width-1 DOWNTO 0);--to read the status of rt

	stat_awr	: IN STD_LOGIC_VECTOR(reg_width-1 DOWNTO 0);--to write the status of a reg
	stat_wrdata	: IN STD_LOGIC_VECTOR(rs_width-1 DOWNTO 0);--the status data to write

	stat_data1	: OUT STD_LOGIC_VECTOR(rs_width-1 DOWNTO 0);--the status of rs
	stat_data2	: OUT STD_LOGIC_VECTOR(rs_width-1 DOWNTO 0)--the status of rt
);
END REGISTER_FILE;
--------------------------------------------------------------------------------
ARCHITECTURE structural OF REGISTER_FILE IS

	COMPONENT REG
	GENERIC(n : INTEGER);
	PORT(
		CLK		: IN STD_LOGIC;
		RST		: IN STD_LOGIC;
		WrEn	: IN STD_LOGIC;
		D		: IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
		Q		: OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0)
	);
	END COMPONENT;

	COMPONENT COMPARATOR
	GENERIC(n : INTEGER);
	PORT(
		A		: IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
		B		: IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
		eq		: OUT STD_LOGIC
	);
	END COMPONENT;

	COMPONENT DEC_5_to_32
	PORT(
		dec_in	: IN STD_LOGIC_VECTOR(4 DOWNTO 0);
		dec_out	: OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
	);
	END COMPONENT;

	COMPONENT MUX_2xN
	GENERIC(n : INTEGER);
	PORT(
		sel		: IN STD_LOGIC;
		Din0	: IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
		Din1	: IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
		Dout	: OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0)
	);
	END COMPONENT;

	COMPONENT MUX_32xN
	GENERIC(n : INTEGER);
	PORT(
		sel		: IN STD_LOGIC_VECTOR(4 DOWNTO 0);
		Din0	: IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
		Din1	: IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
		Din2	: IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
		Din3	: IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
		Din4	: IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
		Din5	: IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
		Din6	: IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
		Din7	: IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
		Din8	: IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
		Din9	: IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
		Din10	: IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
		Din11	: IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
		Din12	: IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
		Din13	: IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
		Din14	: IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
		Din15	: IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
		Din16	: IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
		Din17	: IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
		Din18	: IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
		Din19	: IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
		Din20	: IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
		Din21	: IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
		Din22	: IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
		Din23	: IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
		Din24	: IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
		Din25	: IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
		Din26	: IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
		Din27	: IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
		Din28	: IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
		Din29	: IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
		Din30	: IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
		Din31	: IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
		Dout	: OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0)
	);
	END COMPONENT;

	SIGNAL R				: regBus;
	SIGNAL status			: statBus;
	SIGNAL stat_eq_cdbq		: STD_LOGIC_VECTOR(reg_num-1 DOWNTO 0);
	SIGNAL stat_eq_zero		: STD_LOGIC_VECTOR(reg_num-1 DOWNTO 0);
	SIGNAL reg_wren			: STD_LOGIC_VECTOR(reg_num-1 DOWNTO 0);
	SIGNAL sig_rf_wren		: STD_LOGIC_VECTOR(reg_num-1 DOWNTO 0);
	SIGNAL sig_issue_in		: STD_LOGIC_VECTOR(reg_num-1 DOWNTO 0);
	SIGNAL stat_wren		: STD_LOGIC_VECTOR(reg_num-1 DOWNTO 0);
	SIGNAL stat_data		: statBus;
	SIGNAL stat_awr_dec		: STD_LOGIC_VECTOR(reg_num-1 DOWNTO 0);
	SIGNAL stat_sel			: STD_LOGIC_VECTOR(reg_num-1 DOWNTO 0);
	
	-- Extended ISA (li - Load Immediate instruction)
	
	SIGNAL reg_wrData		: regBus;
	SIGNAL reg_awr_dec		: STD_LOGIC_VECTOR(reg_num-1 DOWNTO 0);
	SIGNAL sig_issue_immed	: STD_LOGIC_VECTOR(reg_num-1 DOWNTO 0);
	SIGNAL immed_wren		: STD_LOGIC_VECTOR(reg_num-1 DOWNTO 0);

BEGIN

	-- ctl
	sig_rf_wren <= stat_eq_cdbq AND (NOT stat_eq_zero) WHEN rf_wren = '1'
				ELSE (OTHERS =>'0');

	immed_wren(0) <= '0';
	
	immed_sel_gen : FOR i IN 1 TO reg_num-1
	GENERATE
		immed_wren(i) <= '1' WHEN reg_awr_dec(i) = '1' AND issue_immed = '1'
					ELSE '0';
	END GENERATE;

	sig_issue_in 	<= (OTHERS => issue_in);
	sig_issue_immed <= (OTHERS => issue_immed);  	

	stat_wren <= sig_rf_wren OR (stat_awr_dec  AND sig_issue_in);

	stat_sel(0) <= '1';
	stat_sel_gen : FOR i IN 1 TO reg_num-1
	GENERATE
		stat_sel(i) <= '0' WHEN (stat_awr_dec(i) = '1' AND sig_issue_in(i) = '1') 
						ELSE '1';
	END GENERATE;


	reg_wren <= sig_rf_wren OR immed_wren;

	-- dataflow

	-- R0 is always 0
	R(0) <= (OTHERS => '0');
	-- the registers, 32 16-bit registers
	register_gen : FOR i IN 1 TO reg_num-1
	GENERATE
		R_i : REG
		GENERIC MAP(n => reg_size)
		PORT MAP(
			CLK		=> CLK,
			RST		=> RST,
			WrEn	=> reg_wren(i),
			D		=> reg_wrData(i),
			Q		=> R(i)
		);
	END GENERATE;


	status(0) <= (OTHERS => '0');
	-- the status registers, 32 3-bit registers
	status_gen : FOR i IN 1 TO reg_num-1
	GENERATE
		status_i : REG
		GENERIC MAP(n => rs_width)
		PORT MAP(
			CLK		=> CLK,
			RST		=> RST,
			WrEn	=> stat_wren(i),
			D		=> stat_data(i),
			Q		=> status(i)
		);
	END GENERATE;


	status_dec : DEC_5_to_32
	PORT MAP(
		dec_in	=> stat_awr,
		dec_out	=> stat_awr_dec
	);
	
	reg_dec : DEC_5_to_32
	PORT MAP(
		dec_in	=> reg_awr,
		dec_out	=> reg_awr_dec
	);
	
	reg_wrData(0) <= (others => '0');
	
	mux_reg_wr_gen : FOR i IN 1 TO reg_num-1
	GENERATE
		mux_reg_wr_i : MUX_2xN
		GENERIC MAP(n => reg_size)
		PORT MAP(
			sel		=> sig_issue_immed(i),
			Din0	=> CDB_V,
			Din1	=> immed,
			Dout	=> reg_wrData(i)
		);
	END GENERATE;

	-- status comparators with cdb_q
	stat_eq_cdbq_gen : FOR i IN 0 TO REG_NUM-1
	GENERATE
		status_eq_cdbq_i : COMPARATOR
		GENERIC MAP(n => rs_width)
		PORT MAP(
			A	=> status(i),
			B	=> CDB_Q,
			eq	=> stat_eq_cdbq(i)
		);
	END GENERATE;


	-- status comparators with zero
	status_eq_zero_gen : FOR i IN 0 TO REG_NUM-1
	GENERATE
		stat_eq_zero_i : COMPARATOR
		GENERIC MAP(n => rs_width)
		PORT MAP(
			A	=> status(i),
			B	=> (OTHERS => '0'),
			eq	=> stat_eq_zero(i)
		);
	END GENERATE;

	stat_data(0) <= (others => '0');
	
	mux_status_wr_gen : FOR i IN 1 TO reg_num-1
	GENERATE
		mux_status_wr_i : MUX_2xN
		GENERIC MAP(n => rs_width)
		PORT MAP(
			sel		=> stat_sel(i),
			Din0	=> stat_wrdata,
			Din1	=> (OTHERS => '0'),
			Dout	=> stat_data(i)
		);
	END GENERATE;


	mux_reg_rd1 : MUX_32xN
	GENERIC MAP(n => reg_size)
	PORT MAP(
		sel		=> reg_ard1,
		Din0	=> R(0),
		Din1	=> R(1),
		Din2	=> R(2),
		Din3	=> R(3),
		Din4	=> R(4),
		Din5	=> R(5),
		Din6	=> R(6),
		Din7	=> R(7),
		Din8	=> R(8),
		Din9	=> R(9),
		Din10	=> R(10),
		Din11	=> R(11),
		Din12	=> R(12),
		Din13	=> R(13),
		Din14	=> R(14),
		Din15	=> R(15),
		Din16	=> R(16),
		Din17	=> R(17),
		Din18	=> R(18),
		Din19	=> R(19),
		Din20	=> R(20),
		Din21	=> R(21),
		Din22	=> R(22),
		Din23	=> R(23),
		Din24	=> R(24),
		Din25	=> R(25),
		Din26	=> R(26),
		Din27	=> R(27),
		Din28	=> R(28),
		Din29	=> R(29),
		Din30	=> R(30),
		Din31	=> R(31),
		Dout	=> Data1
	);


	mux_reg_rd2 : MUX_32xN
	GENERIC MAP(n => reg_size)
	PORT MAP(
		sel		=> reg_ard2,
		Din0	=> R(0),
		Din1	=> R(1),
		Din2	=> R(2),
		Din3	=> R(3),
		Din4	=> R(4),
		Din5	=> R(5),
		Din6	=> R(6),
		Din7	=> R(7),
		Din8	=> R(8),
		Din9	=> R(9),
		Din10	=> R(10),
		Din11	=> R(11),
		Din12	=> R(12),
		Din13	=> R(13),
		Din14	=> R(14),
		Din15	=> R(15),
		Din16	=> R(16),
		Din17	=> R(17),
		Din18	=> R(18),
		Din19	=> R(19),
		Din20	=> R(20),
		Din21	=> R(21),
		Din22	=> R(22),
		Din23	=> R(23),
		Din24	=> R(24),
		Din25	=> R(25),
		Din26	=> R(26),
		Din27	=> R(27),
		Din28	=> R(28),
		Din29	=> R(29),
		Din30	=> R(30),
		Din31	=> R(31),
		Dout	=> Data2
	);


	mux_stat_rd1 : MUX_32xN
	GENERIC MAP(n => rs_width)
	PORT MAP(
		sel		=> stat_ard1,
		Din0	=> status(0),
		Din1	=> status(1),
		Din2	=> status(2),
		Din3	=> status(3),
		Din4	=> status(4),
		Din5	=> status(5),
		Din6	=> status(6),
		Din7	=> status(7),
		Din8	=> status(8),
		Din9	=> status(9),
		Din10	=> status(10),
		Din11	=> status(11),
		Din12	=> status(12),
		Din13	=> status(13),
		Din14	=> status(14),
		Din15	=> status(15),
		Din16	=> status(16),
		Din17	=> status(17),
		Din18	=> status(18),
		Din19	=> status(19),
		Din20	=> status(20),
		Din21	=> status(21),
		Din22	=> status(22),
		Din23	=> status(23),
		Din24	=> status(24),
		Din25	=> status(25),
		Din26	=> status(26),
		Din27	=> status(27),
		Din28	=> status(28),
		Din29	=> status(29),
		Din30	=> status(30),
		Din31	=> status(31),
		Dout	=> stat_data1
	);


	mux_stat_rd2 : MUX_32xN
	GENERIC MAP(n => rs_width)
	PORT MAP(
		sel		=> stat_ard2,
		Din0	=> status(0),
		Din1	=> status(1),
		Din2	=> status(2),
		Din3	=> status(3),
		Din4	=> status(4),
		Din5	=> status(5),
		Din6	=> status(6),
		Din7	=> status(7),
		Din8	=> status(8),
		Din9	=> status(9),
		Din10	=> status(10),
		Din11	=> status(11),
		Din12	=> status(12),
		Din13	=> status(13),
		Din14	=> status(14),
		Din15	=> status(15),
		Din16	=> status(16),
		Din17	=> status(17),
		Din18	=> status(18),
		Din19	=> status(19),
		Din20	=> status(20),
		Din21	=> status(21),
		Din22	=> status(22),
		Din23	=> status(23),
		Din24	=> status(24),
		Din25	=> status(25),
		Din26	=> status(26),
		Din27	=> status(27),
		Din28	=> status(28),
		Din29	=> status(29),
		Din30	=> status(30),
		Din31	=> status(31),
		Dout	=> stat_data2
	);


END structural;
--------------------------------------------------------------------------------