--------------------------------------------------------------------------------
-- Engineer:		Panagiotis Vasileiou
-- 
-- Create Date:		13/04/2022
-- Design Name:		behv
-- Module Name:		REG.vhd
-- Project Name:	Tomasulo_v1.00
-- Tool versions:	ISE Project Navigator (P.20131013)
-- Description:
-- 
-- n-bit Generic Register. It has an asynchronous reset and a synchronous
-- write-enable.
-- 
-- Revision 1.00 - Ready (I hope)
-- 
-- Additional Comments: Completely removed internal signal sig_q. Also removed
-- input D from the sensitivity list.
--------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
--------------------------------------------------------------------------------
ENTITY REG IS
GENERIC(N : INTEGER := 16);
PORT(
	CLK		: IN STD_LOGIC;
	RST		: IN STD_LOGIC;
	WrEn	: IN STD_LOGIC;
	D		: IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
	Q		: OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0)
);
END REG;
--------------------------------------------------------------------------------
ARCHITECTURE behv OF REG IS
BEGIN
	PROCESS(CLK, RST, WrEn)
	BEGIN
		IF RST = '0' THEN
			-- use 'range in signal assigment 
			Q <= (OTHERS => '0');
		ELSIF rising_edge(CLK) THEN
			IF WrEn = '1' THEN
				Q <= D;
			END IF;
		END IF;
	END PROCESS;
END behv;
--------------------------------------------------------------------------------