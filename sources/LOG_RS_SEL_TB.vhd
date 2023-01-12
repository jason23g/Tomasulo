--------------------------------------------------------------------------------
-- Engineer:		PANOS VASILEIOU
--
-- Create Date:		16/05/2022
-- Module Name:		LOG_RS_SEL_TB.vhd - behv
-- Project Name:	Tomasulo_v1.00
-- Tool versions:	ISE Project Navigator & ISim (P.20131013)
-- Description:
-- 
-- VHDL Test Bench Created by the author for module: LOG_RS_SEL
-- 
-- Dependencies:	LOG_RS_SEL
-- 
-- Revision:
-- Revision 1.00 - Ready
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
--------------------------------------------------------------------------------
ENTITY LOG_RS_SEL_TB IS
END LOG_RS_SEL_TB;
--------------------------------------------------------------------------------
ARCHITECTURE behavior OF LOG_RS_SEL_TB IS 

	-- Component Declaration for the Unit Under Test (UUT)
	COMPONENT LOG_RS_SEL
	PORT(
		Busy	: IN  std_logic_vector(1 downto 0);
		RS_wren	: OUT std_logic_vector(1 downto 0);
		Tag		: OUT std_logic_vector(2 downto 0)
	);
	END COMPONENT;


	-- Inputs
	signal Busy 	: std_logic_vector(1 downto 0) := (others => '0');

	-- Outputs
	signal RS_wren	: std_logic_vector(1 downto 0);
	signal Tag		: std_logic_vector(2 downto 0);

BEGIN

	-- Instantiate the Unit Under Test (UUT)
	uut : LOG_RS_SEL
	PORT MAP (
		Busy	=> Busy,
		RS_wren	=> RS_wren,
		Tag		=> Tag
	);

	-- Stimulus process
	stim_proc: process
	begin
	-- hold reset state for 100 ns.
	wait for 100 ns;
	-- insert stimulus here 
	Busy <= "00";
	wait for 100 ns;

	Busy <= "01";
	wait for 100 ns;

	Busy <= "10";
	wait for 100 ns;

	Busy <= "11";
	wait for 100 ns;

	wait;
	end process;

END;
--------------------------------------------------------------------------------