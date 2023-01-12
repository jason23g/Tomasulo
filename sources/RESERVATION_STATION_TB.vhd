--------------------------------------------------------------------------------
-- Engineer: 		JASON GEROGAKAS, PANOS VASILEIOU
--
-- Create Date:		11/05/2022
-- Design Name:
-- Module Name:		RESERVATION_STATION_TB.vhd
-- Project Name:	Tomasulo_v1.00
-- Tool versions:	ISE Project Navigator & ISim (P.20131013)
-- Description:
-- 
-- VHDL Test Bench Created by the authors for module: RESERVATION_STATION
-- 
-- Dependencies:	RESERVATION_STATION, common
-- 
-- Revision:
-- Revision 1.00 - Ready for realease
-- Additional Comments:
-- 
--------------------------------------------------------------------------------
USE WORK.common.ALL;
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
--------------------------------------------------------------------------------
ENTITY RESERVATION_STATION_TB IS
GENERIC(
	reg_size	: INTEGER := 16;
	rs_width	: INTEGER := 3;
	op_width	: INTEGER := 3
);
END RESERVATION_STATION_TB;
--------------------------------------------------------------------------------
ARCHITECTURE behv OF RESERVATION_STATION_TB IS 

	-- Component Declaration for the Unit Under Test (UUT)
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


	-- Inputs
	SIGNAL CLK			: STD_LOGIC := '0';
	SIGNAL RST			: STD_LOGIC := '0';
	SIGNAL OpWrData		: STD_LOGIC_VECTOR(op_width-1 DOWNTO 0) := (OTHERS => '0');
	SIGNAL OpWrEn		: STD_LOGIC := '0';
	SIGNAL QjWrData		: STD_LOGIC_VECTOR(rs_width-1 DOWNTO 0) := (OTHERS => '0');
	SIGNAL QjWrEn		: STD_LOGIC := '0';
	SIGNAL QkWrData		: STD_LOGIC_VECTOR(rs_width-1 DOWNTO 0) := (OTHERS => '0');
	SIGNAL QkWrEn		: STD_LOGIC := '0';
	SIGNAL VjWrData		: STD_LOGIC_VECTOR(reg_size-1 DOWNTO 0) := (OTHERS => '0');
	SIGNAL VjWrEn		: STD_LOGIC := '0';
	SIGNAL VkWrData		: STD_LOGIC_VECTOR(reg_size-1 DOWNTO 0) := (OTHERS => '0');
	SIGNAL VkWrEn		: STD_LOGIC := '0';
	SIGNAL BusyWrData	: STD_LOGIC := '0';
	SIGNAL BusyWrEn		: STD_LOGIC := '0';

	-- Outputs
	SIGNAL Op			: STD_LOGIC_VECTOR(op_width-1 DOWNTO 0);
	SIGNAL Qj			: STD_LOGIC_VECTOR(rs_width-1 DOWNTO 0);
	SIGNAL Qk			: STD_LOGIC_VECTOR(rs_width-1 DOWNTO 0);
	SIGNAL Vj			: STD_LOGIC_VECTOR(reg_size-1 DOWNTO 0);
	SIGNAL Vk			: STD_LOGIC_VECTOR(reg_size-1 DOWNTO 0);
	SIGNAL Busy			: STD_LOGIC;
	SIGNAL Ready		: STD_LOGIC;


BEGIN

	-- Instantiate the Unit Under Test (UUT)
	uut : RESERVATION_STATION
	GENERIC MAP(
		reg_size => reg_size,
		rs_width => rs_width,
		op_width => op_width
	)
	PORT MAP(
		CLK			=> CLK,
		RST			=> RST,
		OpWrData	=> OpWrData,
		OpWrEn		=> OpWrEn,
		QjWrData	=> QjWrData,
		QjWrEn		=> QjWrEn,
		QkWrData	=> QkWrData,
		QkWrEn		=> QkWrEn,
		VjWrData	=> VjWrData,
		VjWrEn		=> VjWrEn,
		VkWrData	=> VkWrData,
		VkWrEn		=> VkWrEn,
		BusyWrData	=> BusyWrData,
		BusyWrEn	=> BusyWrEn,
		Op			=> Op,
		Qj			=> Qj,
		Qk			=> Qk,
		Vj			=> Vj,
		Vk			=> Vk,
		Busy		=> Busy,
		Ready		=> Ready
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
		-- hold reset state for 2cc.
		RST			<= '0';
		WAIT FOR CLK_period*2;

		-- stimulus
		RST			<= '1';
		OpWrData	<= "001";
		OpWrEn		<= '1';
		QjWrData	<= "010";
		QjWrEn		<= '1';
		QkWrData	<= "011";
		QkWrEn		<= '1';
		VjWrData	<= x"0001";
		VjWrEn		<= '1';
		VkWrData	<= x"E00E";
		VkWrEn		<= '1';
		BusyWrData	<= '0';
		BusyWrEn	<= '1';
		WAIT FOR CLK_period;

		--RST			<= '1';
		OpWrData	<= "001";
		OpWrEn		<= '1';
		QjWrData	<= "000";
		QjWrEn		<= '1';
		QkWrData	<= "000";
		QkWrEn		<= '1';
		VjWrData	<= x"0EE0";
		VjWrEn		<= '1';
		VkWrData	<= x"B10B";
		VkWrEn		<= '1';
		BusyWrData	<= '1';
		BusyWrEn	<= '1';
		WAIT FOR CLK_period;

		--RST			<= '1';
		OpWrData	<= "001";
		OpWrEn		<= '1';
		QjWrData	<= "001";
		QjWrEn		<= '1';
		QkWrData	<= "110";
		QkWrEn		<= '1';
		VjWrData	<= x"COOB";
		VjWrEn		<= '1';
		VkWrData	<= x"2222";
		VkWrEn		<= '1';
		BusyWrData	<= '1';
		BusyWrEn	<= '1';
		WAIT FOR CLK_period;

		--RST			<= '1';
		OpWrData	<= "001";
		OpWrEn		<= '0';
		QjWrData	<= "101";
		QjWrEn		<= '0';
		QkWrData	<= "001";
		QkWrEn		<= '0';
		VjWrData	<= x"FFFF";
		VjWrEn		<= '0';
		VkWrData	<= x"0100";
		VkWrEn		<= '0';
		BusyWrData	<= '0';
		BusyWrEn	<= '0';
		WAIT;

	END PROCESS;

END;
--------------------------------------------------------------------------------