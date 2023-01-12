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
entity LOG_EXECUTION_SEL is
port( 
	ready		: IN  STD_LOGIC_VECTOR(1 downto 0);
	rs_exec		: OUT STD_LOGIC_VECTOR(1 downto 0);
	tag			: OUT STD_LOGIC_VECTOR(2 downto 0)
);
end LOG_EXECUTION_SEL;
--------------------------------------------------------------------------------
architecture behv of LOG_EXECUTION_SEL is

begin

	process(ready)
	begin
		if ready = "00" then
			rs_exec	<= "00";
			Tag		<= "000";
		elsif ready = "01" then
			rs_exec	<= "01";
			Tag		<= "100";
		elsif ready = "10" then
			rs_exec	<= "10";
			Tag		<= "101";
		elsif ready = "11" then
			rs_exec	<= "01";
			Tag		<= "100";
		else
			rs_exec	<= "00";
			Tag		<= "000";
		end if;
	end process;

end behv;
--------------------------------------------------------------------------------