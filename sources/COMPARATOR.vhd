--------------------------------------------------------------------------------
-- Engineer:		PANOS VASILEIOU & JASON GEORGAKAS
-- 
-- Create Date:		13/05/2022
-- Design Name:		behv
-- Module Name:		COMPARATOR
-- Project Name:	Tomasulo_v1.00
-- Tool versions:	
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 1.00 - ready for release
--------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
--------------------------------------------------------------------------------
ENTITY COMPARATOR IS
GENERIC(n : INTEGER := 3);
PORT(
	A	: IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
	B	: IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
	eq	: OUT STD_LOGIC
);
END COMPARATOR;
--------------------------------------------------------------------------------
ARCHITECTURE behv OF COMPARATOR IS
BEGIN

PROCESS(A, B)
BEGIN
	IF A = B THEN
		eq <= '1';
	ELSE
		eq <= '0';
	END IF;
END PROCESS;

END behv;
--------------------------------------------------------------------------------

--COMPONENT COMPARATOR
--GENERIC(n : INTEGER);
--PORT(
--	A	: IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
--	B	: IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
--	eq	: OUT STD_LOGIC
--);
--END COMPONENT;

--my_comp : COMPARATOR
--GENERIC MAP(n => comp_width)
--PORT MAP(
--	A	=> ,
--	B	=> ,
--	eq	=> 
--);