--------------------------------------------------------------------------------
-- Engineers:		PANOS VASILEIOU, JASON GEORGAKAS
-- 
-- Create Date:		13/04/2022
-- Design Name:		behv
-- Module Name:		REG_TB.vhd
-- Project Name:	Tomasulo_v1.00
-- Tool versions:	ISE Project Navigator & ISim (P.20131013)
-- Description:
-- 
-- VHDL Test Bench Created by the authors for module: REG
-- 
-- Dependencies:	REG, common
-- 
-- Revision:
-- Revision 0.02 - Conforms to standards
-- Additional Comments:
--------------------------------------------------------------------------------
USE WORK.common.ALL;
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
--------------------------------------------------------------------------------
ENTITY REG_TB IS
GENERIC(N	: INTEGER := 3);
END REG_TB;
--------------------------------------------------------------------------------
ARCHITECTURE behv OF REG_TB IS

	-- Component Declaration for the Unit Under Test (UUT)
	COMPONENT REG
	GENERIC(N	: INTEGER);
	PORT(
		CLK		: IN STD_LOGIC;
		RST		: IN STD_LOGIC;
		WrEN	: IN STD_LOGIC;
		D		: IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
		Q		: OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0)
	);
	END COMPONENT;

	-- Inputs
	SIGNAL CLK	: STD_LOGIC := '0';
	SIGNAL RST	: STD_LOGIC := '0';
	SIGNAL WrEN	: STD_LOGIC := '0';
	SIGNAL D	: STD_LOGIC_VECTOR(N-1 DOWNTO 0) := (others => '0');

	-- Outputs
	SIGNAL Q	: STD_LOGIC_VECTOR(N-1 DOWNTO 0);

BEGIN

	-- Instantiate the Unit Under Test (UUT)
	uut : REG
	GENERIC MAP(N => N)
	PORT MAP(
		CLK		=> CLK,
		RST		=> RST,
		WrEN	=> WrEn,
		D		=> D,
		Q		=> Q
	);

	-- Clock process definitions
	clock_process : PROCESS
	BEGIN
		CLK		<= '0';
		WAIT FOR CLK_period/2;
		CLK		<= '1';
		WAIT FOR CLK_period/2;
	END PROCESS;

	-- Stimulus process
	stim_proc : PROCESS
	BEGIN		
		-- hold reset state for 100 ns.
		RST		<= '0';
		WAIT FOR 100 ns;

		-- insert stimulus here
		RST		<= '1';
		WrEN	<= '1';
		D		<= "010";
		WAIT FOR CLK_period;

		RST		<= '1';
		WrEN	<= '1';
		D		<= "100";
		WAIT FOR CLK_period;

		RST		<= '1';
		WrEN	<= '0';
		D		<= "001";
		WAIT FOR CLK_period;

		RST		<= '1';
		WrEN	<= '0';
		D 		<= "111";
		WAIT FOR CLK_period;

		RST		<= '0';
		WrEN	<= '1';
		D		<= "011";
		WAIT FOR CLK_period;

		WrEN	<= '0';
		WAIT FOR CLK_period;

		WAIT;
	END PROCESS;

END;
--------------------------------------------------------------------------------