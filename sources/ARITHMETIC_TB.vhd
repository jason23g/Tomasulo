--------------------------------------------------------------------------------
USE WORK.common.ALL;
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
use work.common.all;
--------------------------------------------------------------------------------
ENTITY ARITHMETIC_TB IS
generic(
	reg_size	: INTEGER := 16;
	reg_num		: INTEGER := 32;
	reg_width	: INTEGER := 5;
	rs_num		: INTEGER := 5+1;
	rs_width	: INTEGER := 3;
	op_width	: INTEGER := 3
);
END ARITHMETIC_TB;
--------------------------------------------------------------------------------
ARCHITECTURE behavior OF ARITHMETIC_TB IS 

	-- Component Declaration for the Unit Under Test (UUT)
	COMPONENT ARITHMETIC
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

		-- to CDB
		ReqOut		: OUT STD_LOGIC;
		Avail_RS	: OUT STD_LOGIC;
		CDB_Q		: OUT STD_LOGIC_VECTOR(rs_width-1 DOWNTO 0);
		CDB_V		: OUT STD_LOGIC_VECTOR(reg_size-1 DOWNTO 0)
	);
	END COMPONENT;
	
	COMPONENT CDB
	GENERIC(
		N			: INTEGER := 16;
		Q			: INTEGER := 3
	);
	PORT(
		CLK			: IN STD_LOGIC;
		RST			: IN STD_LOGIC;
		DEV1_VAL_IN	: IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
		DEV2_VAL_IN	: IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
		DEV3_VAL_IN	: IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);

		DEV1_Q_IN	: IN STD_LOGIC_VECTOR(Q-1 DOWNTO 0);
		DEV2_Q_IN	: IN STD_LOGIC_VECTOR(Q-1 DOWNTO 0);
		DEV3_Q_IN	: IN STD_LOGIC_VECTOR(Q-1 DOWNTO 0);

		DEV_REQ		: IN STD_LOGIC_VECTOR(2 DOWNTO 0);
		DEV_GRANT	: OUT STD_LOGIC_VECTOR(2 DOWNTO 0);

		DEV_VAL_OUT	: OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0);
		DEV_Q_OUT	: OUT STD_LOGIC_VECTOR(Q-1 DOWNTO 0)
	);
	END COMPONENT;

	-- Inputs
	signal CLK			: STD_LOGIC := '0';
	signal RST			: STD_LOGIC := '0';
	-- from CDB
	signal CDB_Q_in		: STD_LOGIC_VECTOR(rs_width-1 DOWNTO 0) := (OTHERS => '0');
	signal CDB_V_in		: STD_LOGIC_VECTOR(reg_size-1 DOWNTO 0) := (OTHERS => '0');
	-- Qj, Qk, Vj, Vk, from RF
	signal stat_data1	: STD_LOGIC_VECTOR(rs_width-1 DOWNTO 0) := (OTHERS => '0');
	signal stat_data2	: STD_LOGIC_VECTOR(rs_width-1 DOWNTO 0) := (OTHERS => '0');
	signal data1		: STD_LOGIC_VECTOR(reg_size-1 DOWNTO 0) := (OTHERS => '0');
	signal data2		: STD_LOGIC_VECTOR(reg_size-1 DOWNTO 0) := (OTHERS => '0');

	signal Op			: STD_LOGIC_VECTOR(op_width-1 DOWNTO 0) := (OTHERS => '0');

	signal Accepted		: STD_LOGIC := '0';

	-- Outputs
	signal ReqOut		: STD_LOGIC;
	signal DEV_GRANT	: STD_LOGIC_VECTOR(2 DOWNTO 0);
	signal DEV_Q_OUT	: STD_LOGIC_VECTOR(rs_width-1 DOWNTO 0);
	signal DEV_VAL_OUT	: STD_LOGIC_VECTOR(reg_size-1 DOWNTO 0);


BEGIN

	-- Instantiate the Unit Under Test (UUT)
	uut : ARITHMETIC
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
		CDB_Grant	=> DEV_GRANT(2),
		CDB_Q_in	=> DEV_Q_OUT,
		CDB_V_in	=> DEV_VAL_OUT,

		-- Qj, Qk, Vj, Vk, from RF
		stat_data1	=> stat_data1,
		stat_data2	=> stat_data2,
		data1		=> data1,
		data2		=> data2,

		Op			=> Op,

		Accepted	=> Accepted,

		-- to CDB
		ReqOut		=> ReqOut,
		CDB_Q		=> CDB_Q_in,
		CDB_V		=> CDB_V_in
	);
	
	
	cdb_inst : CDB
	GENERIC MAP(
		N			=> reg_size,
		Q			=> rs_width
	)
	PORT MAP(
		CLK			=> CLK,
		RST			=> RST,
		DEV1_VAL_IN	=> (others => '0'),
		DEV2_VAL_IN	=> (others => '0'),
		DEV3_VAL_IN	=> CDB_V_in,
		DEV1_Q_IN	=> (others => '0'),
		DEV2_Q_IN	=> (others => '0'),
		DEV3_Q_IN	=> CDB_Q_in,
		DEV_REQ(0)	=> '0',
		DEV_REQ(1)	=> '0',
		DEV_REQ(2)	=> ReqOut,
		DEV_GRANT	=> DEV_GRANT,
		DEV_Q_OUT	=> DEV_Q_OUT,
		DEV_VAL_OUT	=> DEV_VAL_OUT
	);


	-- Clock process definitions
	CLK_process : PROCESS
	BEGIN
		CLK <= '0';
		WAIT FOR CLK_period/2;
		CLK <= '1';
		WAIT FOR CLK_period/2;
	END PROCESS;

	-- Stimulus process
	stim_proc : PROCESS
	BEGIN
		-- wait until global set/reset completes
		RST			<= '0';
		wait for CLK_period;
		RST			<= '1';
--
--		-- ADD 8+5
--		CDB_Grant	<= '0';
--		stat_data1	<= "000";
--		stat_data2	<= "000";
--		data1		<= x"0008";
--		data2		<= x"0005";
--		Op			<= "100";
--		Accepted	<= '1';
--		wait for CLK_period;
--
--		-- ADD 13-4
--		stat_data1	<= "001";
--		stat_data2	<= "000";
--		data1		<= x"0000";
--		data2		<= x"0004";
--		Op			<= "100";
--		Accepted	<= '1';
--		wait for CLK_period;
--
--		stat_data1	<= "000";
--		stat_data2	<= "000";
--		data1		<= x"0000";
--		data2		<= x"0000";
--		Accepted	<= '0';
--		wait for CLK_period;
--
--		CDB_Grant	<= '0';
--		wait for CLK_period;
--
--		CDB_Grant	<= '1';
--		wait for CLK_period;
--
--		CDB_Grant	<= '0';
--		wait for CLK_period*3;
--
--		CDB_Grant	<= '1';
--		wait for CLK_period;
--
--		CDB_Grant	<= '0';
--		wait for CLK_period;


		-- #inst1 SUB 327-300 (RS1)
		stat_data1	<= "000";
		stat_data2	<= "000";
		data1		<= x"0327";
		data2		<= x"0300";
		Op			<= "101";
		Accepted	<= '1';
		wait for CLK_period;

		-- #inst2 ADD #inst1 + 25 (RS2)
		stat_data1	<= "001";
		stat_data2	<= "000";
		data1		<= x"0000";
		data2		<= x"0025";
		Op			<= "100";
		Accepted	<= '1';
		wait for CLK_period;

		-- #inst3 SLL #inst2, 5 (RS3)
		stat_data1	<= "010";
		stat_data2	<= "000";
		data1		<= x"0000";
		data2		<= x"0005";
		Op			<= "110";
		Accepted	<= '1';
		wait for CLK_period;
		
		stat_data1	<= "000";
		stat_data2	<= "000";
		data1		<= x"0000";
		data2		<= x"0000";
		Accepted	<= '0';
		wait for CLK_period*2;
		
		wait for CLK_period*2;

		-- #inst4 ADD #inst1, #inst2 (RS1)
		stat_data1	<= "001";
		stat_data2	<= "010";
		data1		<= x"0000";
		data2		<= x"0000";
		Op			<= "001";
		Accepted	<= '1';
		wait for CLK_period;
		
		Accepted	<= '0';
		wait for CLK_period;

	

		-- #inst5 SLL #inst3, 3 (RS2)
		stat_data1	<= "011";
		stat_data2	<= "000";
		data1		<= x"0000";
		data2		<= x"0003";
		Op			<= "111";
		Accepted	<= '1';
		wait for CLK_period;

		Accepted	<= '0';

		wait for CLK_period*10;

		wait; -- will wait forever
	END PROCESS;

END;
--------------------------------------------------------------------------------