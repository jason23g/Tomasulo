--------------------------------------------------------------------------------
-- Engineer:		JASON GEORGAKAS, PANOS VASILEIOU
-- 
-- Create Date:		15/05/2022
-- Design Name:		
-- Module Name:		REGISTER_FILE_TB.vhd
-- Project Name:	Tomasulo_v1.00
-- Target Device:	
-- Tool versions:	ISE Project Navigator & ISim (P.20131013)
-- Description:
-- 
-- VHDL Test Bench Created by the authors for module: REGISTER_FILE
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use work.common.all;
--------------------------------------------------------------------------------
ENTITY REGISTER_FILE_TB IS
--generic(

--);
END REGISTER_FILE_TB;
--------------------------------------------------------------------------------
ARCHITECTURE behavior OF REGISTER_FILE_TB IS 

	-- Component Declaration for the Unit Under Test (UUT)
	COMPONENT REGISTER_FILE
	PORT(
		CLK : IN  std_logic;
		RST : IN  std_logic;
		rf_wren : IN  std_logic;
		reg_ard1 : IN  std_logic_vector(4 downto 0);
		reg_ard2 : IN  std_logic_vector(4 downto 0);
		CDB_Q : IN  std_logic_vector(2 downto 0);
		CDB_V : IN  std_logic_vector(15 downto 0);
		data1 : OUT  std_logic_vector(15 downto 0);
		data2 : OUT  std_logic_vector(15 downto 0);
		issue_in : IN  std_logic;
		stat_ard1 : IN  std_logic_vector(4 downto 0);
		stat_ard2 : IN  std_logic_vector(4 downto 0);
		stat_awr : IN  std_logic_vector(4 downto 0);
		stat_wrdata : IN  std_logic_vector(2 downto 0);
		stat_data1 : OUT  std_logic_vector(2 downto 0);
		stat_data2 : OUT  std_logic_vector(2 downto 0)
	);
	END COMPONENT;

	-- Inputs
	signal CLK : std_logic := '0';
	signal RST : std_logic := '0';
	signal rf_wren : std_logic := '0';
	signal reg_ard1 : std_logic_vector(4 downto 0) := (others => '0');
	signal reg_ard2 : std_logic_vector(4 downto 0) := (others => '0');
	signal CDB_Q : std_logic_vector(2 downto 0) := (others => '0');
	signal CDB_V : std_logic_vector(15 downto 0) := (others => '0');
	signal issue_in : std_logic := '0';
	signal stat_ard1 : std_logic_vector(4 downto 0) := (others => '0');
	signal stat_ard2 : std_logic_vector(4 downto 0) := (others => '0');
	signal stat_awr : std_logic_vector(4 downto 0) := (others => '0');
	signal stat_wrdata : std_logic_vector(2 downto 0) := (others => '0');

	-- Outputs
	signal data1 : std_logic_vector(15 downto 0);
	signal data2 : std_logic_vector(15 downto 0);
	signal stat_data1 : std_logic_vector(2 downto 0);
	signal stat_data2 : std_logic_vector(2 downto 0);

BEGIN

	-- Instantiate the Unit Under Test (UUT)
	uut : REGISTER_FILE
	PORT MAP(
		CLK => CLK,
		RST => RST,
		rf_wren => rf_wren,
		reg_ard1 => reg_ard1,
		reg_ard2 => reg_ard2,
		CDB_Q => CDB_Q,
		CDB_V => CDB_V,
		data1 => data1,
		data2 => data2,
		issue_in => issue_in,
		stat_ard1 => stat_ard1,
		stat_ard2 => stat_ard2,
		stat_awr => stat_awr,
		stat_wrdata => stat_wrdata,
		stat_data1 => stat_data1,
		stat_data2 => stat_data2
	);

	-- Clock process definitions
	CLK_process : process
	begin
		CLK <= '0';
		wait for CLK_period/2;
		CLK <= '1';
		wait for CLK_period/2;
	end process;


-- 001 Arithmetic RS1
-- 010 Arithmetic RS2
-- 011 Arithmetic RS3
-- 100 Logical RS1
-- 101 Logical RS2

	-- Stimulus process
	stim_proc : process
	begin		
		-- hold reset state for 2cc.
		RST <= '0';
		wait for CLK_period*2;

		-- insert stimulus here

		-- R5 = R1 + R2;
		RST			<= '1';
		rf_wren		<= '1';
		CDB_Q		<= "000";
		CDB_V		<= x"FFFF";
		issue_in	<= '1';
		reg_ard1	<= "00001";
		reg_ard2	<= "00010";
		stat_ard1	<= "00001";
		stat_ard2	<= "00010";
		stat_awr	<= "00101";
		stat_wrdata	<= "001";
		wait for CLK_period;

		issue_in	<= '0';
		wait for CLK_period*3;

		CDB_Q		<= "001";
		CDB_V		<= x"8080";
		issue_in	<= '0';
		wait for CLK_period;

		-- R3 = R1 | R2;
		CDB_Q		<= "000";
		issue_in	<= '1';
		reg_ard1	<= "00001";
		reg_ard2	<= "00010";
		stat_ard1	<= "00001";
		stat_ard2	<= "00010";
		stat_awr	<= "00011";
		stat_wrdata	<= "100";
		wait for CLK_period;

		issue_in	<= '0';
		wait for CLK_period*2;

		-- R3 = R16 ^ R31;
		CDB_Q		<= "100";
		CDB_V		<= x"FFFF";
		issue_in	<= '1';
		reg_ard1	<= "10000";
		reg_ard2	<= "11111";
		stat_ard1	<= "10000";
		stat_ard2	<= "11111";
		stat_awr	<= "00011";
		stat_wrdata	<= "101";
		wait for CLK_period;

		issue_in	<= '0';
		wait for CLK_period*2;

		-- R3 = R16 ^ R31;
		CDB_Q		<= "101";
		CDB_V		<= x"00FF";
		issue_in	<= '1';
		wait for CLK_period;

		issue_in	<= '0';
		wait for CLK_period;
		wait;
	end process;

END;
--------------------------------------------------------------------------------