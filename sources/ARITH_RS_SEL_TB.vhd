--------------------------------------------------------------------------------
-- Engineer:		PANOS VASILEIOU, JASON GEORGAKAS
-- 
-- Create Date:		16/05/2022
-- Module Name:		ARITH_RS_SEL_TB.vhd - behv
-- Project Name:	Tomasulo_v1.00
-- Tool versions:	ISE Project Navigator & ISim (P.20131013)
-- Description:
-- 
-- VHDL Test Bench Created by the authors for module: ARITH_RS_SEL
-- 
-- Dependencies:	ARITH_RS_SEL
-- 
-- Revision:
-- Revision 0.01 - File Created
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
--------------------------------------------------------------------------------
ENTITY ARITH_RS_SEL_TB IS
END ARITH_RS_SEL_TB;
--------------------------------------------------------------------------------
ARCHITECTURE behavior OF ARITH_RS_SEL_TB IS 

	-- Component Declaration for the Unit Under Test (UUT)
	COMPONENT ARITH_RS_SEL
	PORT(
		Busy	: IN  std_logic_vector(2 downto 0);
		RS_wren	: OUT std_logic_vector(2 downto 0);
		Tag		: OUT std_logic_vector(2 downto 0)
	);
	END COMPONENT;

	-- Inputs
	signal Busy		: std_logic_vector(2 downto 0) := (others => '0');

	-- Outputs
	signal RS_wren	: std_logic_vector(2 downto 0);
	signal Tag		: std_logic_vector(2 downto 0);

BEGIN

	-- Instantiate the Unit Under Test (UUT)
	uut : ARITH_RS_SEL
	PORT MAP(
		Busy	=> Busy,
		RS_wren => RS_wren,
		Tag		=> Tag
	);

	-- Stimulus process
	stim_proc : process
	begin
	-- hold reset state for 100 ns.
	wait for 100 ns;
	-- insert stimulus here
	Busy <= "000";
	wait for 100 ns;

	Busy <= "001";
	wait for 100 ns;

	Busy <= "010";
	wait for 100 ns;

	Busy <= "011";
	wait for 100 ns;

	Busy <= "100";
	wait for 100 ns;

	Busy <= "101";
	wait for 100 ns;

	Busy <= "110";
	wait for 100 ns;

	Busy <= "111";
	wait for 100 ns;

	wait;
	end process;

END;
--------------------------------------------------------------------------------