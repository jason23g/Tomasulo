--------------------------------------------------------------------------------
-- Engineer:		PANOS VASILEIOU, JASON GEORGAKAS
-- 
-- Create Date:		16/05/2022 
-- Module Name:		LOG_RS_SEL - behv
-- Project Name:	Tomasulo_v1.00
-- Tool versions:	ISE Project Navigator (P.20131013)
-- Description:
-- 
-- This module selects the RS in which a logical instrcution will be stored.
-- 
-- Revision:
-- Revision 0.01 - File Created
--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--------------------------------------------------------------------------------
entity LOG_RS_SEL is
port(
	Busy		: IN  STD_LOGIC_VECTOR(1 downto 0);
	RS_wren		: OUT STD_LOGIC_VECTOR(1 downto 0);
	Tag 		: OUT STD_LOGIC_VECTOR(2 downto 0)
);
end LOG_RS_SEL;
--------------------------------------------------------------------------------
architecture behv of LOG_RS_SEL is

begin

process(Busy)
begin
	if Busy = "00" then
		RS_wren	<= "01";
		Tag		<= "100";
	elsif Busy = "01" then
		RS_wren	<= "10";
		Tag		<= "101";
	elsif Busy = "10" then
		RS_wren	<= "01";
		Tag		<= "100";
	else
		RS_wren	<= "00";
		Tag		<= "000";
	end if;
end process;

end behv;
--------------------------------------------------------------------------------