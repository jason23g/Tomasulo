--------------------------------------------------------------------------------
-- Engineer:		JASON GEORGAKAS
-- 
-- Create Date:		11/04/2022
-- Design Name:		behv
-- Module Name:		LOGICAL_FU
-- Project Name:	Tomasulo_v1.00
-- Tool versions:	ISE Project Navigator (P.20131013)
-- Description:
-- 
-- A clocked ALU that supports the OR, AND & NOT operations. It has an 
-- asynchronous reset and a synchronous write-enable.
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
--------------------------------------------------------------------------------
--USE WORK.common.ALL;
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
--------------------------------------------------------------------------------
ENTITY LOGICAL_FU IS
GENERIC(
	reg_size : INTEGER := 16;
	op_width : INTEGER := 3
);
PORT(
	CLK		: IN STD_LOGIC;
	RST		: IN STD_LOGIC;
	WrEn	: In STD_LOGIC;

	A		: IN STD_LOGIC_VECTOR(reg_size-1 downto 0);
	B		: IN STD_LOGIC_VECTOR(reg_size-1 downto 0);
	Op		: IN STD_LOGIC_VECTOR(op_width-1 downto 0);

	Result	: OUT STD_LOGIC_VECTOR(reg_size-1 downto 0)
);
END LOGICAL_FU;
--------------------------------------------------------------------------------
ARCHITECTURE behv OF LOGICAL_FU IS
BEGIN
	PROCESS(CLK, RST, WrEn, Op, A, B)
	BEGIN
		IF RST = '0' THEN
			Result <= (OTHERS => '0');
		ELSIF rising_edge(CLK) THEN
			IF WrEn = '1' THEN
				CASE Op IS
					WHEN "001" => -- OR
						Result <=  A OR B;
					WHEN "010" => -- AND
						Result <= A AND B;
					WHEN "011" => -- NOT
						Result <= NOT A;
					WHEN OTHERS => -- any other input
						Result <= (OTHERS => '0');
				END CASE;
			END IF;
		END IF;
	END PROCESS;
END behv;
--------------------------------------------------------------------------------