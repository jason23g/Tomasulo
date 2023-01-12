--------------------------------------------------------------------------------
USE WORK.common.ALL;
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use work.common.all;
--------------------------------------------------------------------------------
ENTITY LOGICAL_TB IS
generic(
	reg_size	: INTEGER := 16;
	reg_num		: INTEGER := 32;
	reg_width	: INTEGER := 5;
	rs_num		: INTEGER := 5+1;
	rs_width	: INTEGER := 3;
	op_width	: INTEGER := 3
);
END LOGICAL_TB;
--------------------------------------------------------------------------------
ARCHITECTURE behavior OF LOGICAL_TB IS 

	-- Component Declaration for the Unit Under Test (UUT)
	COMPONENT LOGICAL
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

		Op			: IN STD_LOGIC_VECTOR(op_width-1 DOWNTO 0);

		Accepted	: IN STD_LOGIC;

		-- to CDB
		ReqOut		: OUT STD_LOGIC;
		CDB_Q		: OUT STD_LOGIC_VECTOR(rs_width-1 DOWNTO 0);
		CDB_V		: OUT STD_LOGIC_VECTOR(reg_size-1 DOWNTO 0)
	);
	END COMPONENT;

	-- Inputs
	signal CLK			: STD_LOGIC := '0';
	signal RST			: STD_LOGIC := '0';
	-- from CDB
	signal CDB_Grant	: STD_LOGIC := '0';
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
	--signal CDB_Q		: STD_LOGIC_VECTOR(rs_width-1 DOWNTO 0);
	--signal CDB_V		: STD_LOGIC_VECTOR(reg_size-1 DOWNTO 0);

BEGIN

	-- Instantiate the Unit Under Test (UUT)
	uut : LOGICAL
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
		CDB_Grant	=> CDB_Grant,
		CDB_Q_in	=> CDB_Q_in,
		CDB_V_in	=> CDB_V_in,

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

		-- OR 8, 5
		CDB_Grant	<= '0';
		stat_data1	<= "000";
		stat_data2	<= "000";
		data1		<= x"0008";
		data2		<= x"0005";
		Op			<= "001";
		Accepted	<= '1';
		wait for CLK_period;

		-- AND #inst1, 4
		stat_data1	<= "000";
		stat_data2	<= "000";
		data1		<= x"00FF";
		data2		<= x"00B4";
		Op			<= "010";
		Accepted	<= '1';
		wait for CLK_period;

		Accepted	<= '0';
		wait for CLK_period;

		CDB_Grant	<= '1';
		wait for CLK_period;

--		CDB_Grant	<= '0';
--		wait for CLK_period*1;

		CDB_Grant	<= '1';
		wait for CLK_period;

		CDB_Grant	<= '0';
		wait for CLK_period;


		-- #inst1 OR 327, 300 (RS1)
		data1		<= x"0327";
		data2		<= x"0300";
		Op			<= "001";
		Accepted	<= '1';
		wait for CLK_period;

		-- #inst2 AND #inst1,25 (RS2)
		stat_data2	<= "001";
		data1		<= x"0025";
		Op			<= "010";
		Accepted	<= '1';
		wait for CLK_period;

		Accepted	<= '0';
		wait for CLK_period*3;

		-- #inst3 NOT #inst2 (RS1)
		stat_data1	<= "010";
		stat_data2	<= "000";
		Op			<= "011";
		Accepted	<= '1';
		wait for CLK_period;

		-- #inst4 OR #inst1, #inst2 (RS1)
		stat_data1	<= "010";
		stat_data2	<= "011";
		Op			<= "001";
		Accepted	<= '1';
		wait for CLK_period;
		
		Accepted	<= '0';
		wait for CLK_period;

		-- #inst5 NOT #inst3 (RS2)
		stat_data1	<= "011";
		stat_data2	<= "000";
		Op			<= "011";
		Accepted	<= '1';
		wait for CLK_period;

		Accepted	<= '0';
		CDB_Grant	<= '1';
		wait for CLK_period;

		CDB_Grant	<= '0';
		wait for CLK_period*3;
		
		CDB_Grant	<= '1';
		wait for CLK_period;

		CDB_Grant	<= '0';
		wait for CLK_period*3;
		
		CDB_Grant	<= '1';
		wait for CLK_period;

		CDB_Grant	<= '0';
		wait for CLK_period*3;
		
		CDB_Grant	<= '1';
		wait for CLK_period;

		CDB_Grant	<= '0';
		wait for CLK_period*3;
		
		CDB_Grant	<= '1';
		wait for CLK_period;

		CDB_Grant	<= '0';
		wait for CLK_period*3;
		
		wait; -- will wait forever
	END PROCESS;

END;
--------------------------------------------------------------------------------