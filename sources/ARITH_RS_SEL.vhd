--------------------------------------------------------------------------------
-- Engineer:		JASON GEORGAKAS, PANOS VASILEIOU
-- 
-- Create Date:		16/05/2022 
-- Module Name:		ARITH_RS_SEL - behv 
-- Project Name:	Tomasulo_v1.00
-- Tool versions:	ISE Project Navigator (P.20131013)
-- Description: 
-- 
-- This module selects the RS in which an arithmetic instrcution will be stored.
-- 
-- Revision:
-- Revision 0.01 - File Created
--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--------------------------------------------------------------------------------
entity ARITH_RS_SEL is
port(
	Busy	: IN  STD_LOGIC_VECTOR(2 downto 0);
	RS_wren	: OUT STD_LOGIC_VECTOR(2 downto 0);
	Tag		: OUT STD_LOGIC_VECTOR(2 downto 0)
);
end ARITH_RS_SEL;
--------------------------------------------------------------------------------
architecture behv of ARITH_RS_SEL is

begin

process(Busy)
begin
	if Busy = "000" then
		RS_wren	<= "001";
		Tag		<= "001";
	elsif Busy = "001" then
		RS_wren	<= "010";
		Tag		<= "010";
	elsif Busy = "010" then
		RS_wren	<= "100";
		Tag		<= "011";
	elsif Busy = "100" then
		RS_wren	<= "001";
		Tag		<= "001";
	elsif Busy = "011" then
		RS_wren	<= "100";
		Tag		<= "011";
	elsif Busy = "110" then
		RS_wren	<= "001";
		Tag		<= "001";
	elsif Busy = "101" then
		RS_wren	<= "010";
		Tag		<= "010";
	else
		RS_wren	<= "000";
		Tag		<= "000";
	end if;
end process;

end behv;
--------------------------------------------------------------------------------