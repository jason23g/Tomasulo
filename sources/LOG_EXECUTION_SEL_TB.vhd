--------------------------------------------------------------------------------
-- Engineer:		PANOS VASILEIOU, JASON GEORGAKAS
-- 
-- Create Date:		16/05/2022
-- Module Name:		EXECUTION_SEL_TB.vhd - behv
-- Project Name:	Tomasulo_v1.00
-- Tool versions:	ISE Project Navigator & ISim (P.20131013)
-- Description:
-- 
-- VHDL Test Bench Created by the authors for module: EXECUTION_SEL
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
--------------------------------------------------------------------------------
ENTITY LOG_EXECUTION_SEL_TB IS
END LOG_EXECUTION_SEL_TB;
--------------------------------------------------------------------------------
ARCHITECTURE behv OF LOG_EXECUTION_SEL_TB IS 

	-- Component Declaration for the Unit Under Test (UUT)
	COMPONENT LOG_EXECUTION_SEL
	PORT(
		ready		: IN  std_logic_vector(1 downto 0);
		rs_exec		: OUT  std_logic_vector(1 downto 0);
		tag			: OUT  std_logic_vector(2 downto 0)
	);
	END COMPONENT;

	-- Inputs
	signal ready	: std_logic_vector(1 downto 0) := (others => '0');

	-- Outputs
	signal rs_exec	: std_logic_vector(1 downto 0);
	signal tag		: std_logic_vector(2 downto 0);

BEGIN

	-- Instantiate the Unit Under Test (UUT)
	uut: EXECUTION_SEL
	PORT MAP (
		ready	=> ready,
		rs_exec	=> rs_exec,
		tag		=> tag
	);

	-- Stimulus process
	stim_proc : process
	begin
	-- hold reset state for 100 ns.
	wait for 100 ns;
	-- insert stimulus here
	ready <= "01";
	wait for 100 ns;

	ready <= "00";
	wait for 100 ns;

	ready <= "11";
	wait for 100 ns;

	ready <= "10";
	wait for 100 ns;

	ready <= "11";
	wait for 100 ns;

	wait;
	end process;

END;
--------------------------------------------------------------------------------