--------------------------------------------------------------------------------
-- Engineer:		PANOS VASILEIOU, JASON GEORGAKAS
-- 
-- Create Date:		16/05/2022
-- Module Name:		EXECUTION_SEL - behv
-- Project Name:	Tomasulo_v1.00
-- Tool versions:	ISE Project Navigator (P.20131013)
-- Description:
-- 
-- This module is used to select which RS is going to start the execution of
-- an instruction in the ALU.
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.02 - File Created
--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--------------------------------------------------------------------------------
entity EXECUTION_SEL is
port( 
	ready		: IN  STD_LOGIC_VECTOR(2 downto 0);
	rs_exec		: OUT STD_LOGIC_VECTOR(2 downto 0);
	tag			: OUT STD_LOGIC_VECTOR(2 downto 0)
);
end EXECUTION_SEL;
--------------------------------------------------------------------------------
architecture behv of EXECUTION_SEL is

begin

	process(ready)
	begin
		if ready = "000" then
			rs_exec	<= "000";
			Tag		<= "000";
		elsif ready = "001" then
			rs_exec	<= "001";
			Tag		<= "001";
		elsif ready = "010" then
			rs_exec	<= "010";
			Tag		<= "010";
		elsif ready = "100" then
			rs_exec	<= "100";
			Tag		<= "011";
		elsif ready = "011" then
			rs_exec	<= "001";
			Tag		<= "001";
		elsif ready = "110" then
			rs_exec	<= "010";
			Tag		<= "010";
		elsif ready = "101" then
			rs_exec	<= "100";
			Tag		<= "011";
		elsif ready = "111" then
			rs_exec	<= "001";
			Tag		<= "001";
		else
			rs_exec	<= "000";
			Tag		<= "000";
		end if;
	end process;

end behv;
--------------------------------------------------------------------------------