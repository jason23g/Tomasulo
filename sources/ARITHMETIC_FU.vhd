--------------------------------------------------------------------------------
-- Engineer:		PANOS VASILEIOU
-- 
-- Create Date:		12/04/2022
-- Design Name:		behv
-- Module Name:		ARITHMETIC_FU
-- Project Name:	Tomasulo_v1.00
-- Tool versions:	ISE Project Navigator (P.20131013)
-- Description:
--
-- This unit performs the operations ADD and SUB. It also detects overflow and
-- zero.
--
-- Dependencies:
--
-- Revision:
-- Revision 0.01 - File Created
--------------------------------------------------------------------------------
USE WORK.common.ALL;
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_unsigned.ALL;
USE IEEE.NUMERIC_STD.ALL;
--------------------------------------------------------------------------------
ENTITY ARITHMETIC_FU IS
GENERIC(
	N 		: INTEGER := 16;
	op_width : INTEGER := 3
);
PORT(
	CLK		: IN STD_LOGIC;
	RST		: IN STD_LOGIC;
	WrEn	: IN STD_LOGIC;
	A		: IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
	B		: IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
	Op		: IN STD_LOGIC_VECTOR(op_width-1 DOWNTO 0);

	Result	: OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0);

	Cout	: OUT STD_LOGIC;
	Ovf		: OUT STD_LOGIC;
	Zero	: OUT STD_LOGIC
);
END ARITHMETIC_FU;
--------------------------------------------------------------------------------
ARCHITECTURE behv OF ARITHMETIC_FU IS

	SIGNAL sig_res	: STD_LOGIC_VECTOR(N-1 DOWNTO 0);
	SIGNAL sig_ovf	: STD_LOGIC_VECTOR(N DOWNTO 0);
	SIGNAL sig_A	: STD_LOGIC_VECTOR(N DOWNTO 0);
	SIGNAL sig_B	: STD_LOGIC_VECTOR(N DOWNTO 0);

BEGIN

	PROCESS(CLK, RST, WrEn, A, B)
	BEGIN
	
		sig_A(N)			<= A(N-1);
		sig_A(N-1 DOWNTO 0)	<= A;
		sig_B(N)			<= B(N-1);
		sig_B(N-1 DOWNTO 0)	<= B;
		
		IF RST = '0' THEN
			sig_ovf	<= (OTHERS => '0');
			sig_res	<= (OTHERS => '0');
			Ovf		<= '0';
			Cout	<= '0';
		ELSIF rising_edge(CLK) THEN
			IF WrEn = '1' THEN

				CASE Op IS
				WHEN "100" => --Add Result, A, B

					sig_ovf	<= sig_A + sig_B;
					sig_res	<= sig_A(N-1 DOWNTO 0) + sig_B(N-1 DOWNTO 0);
					Cout	<= sig_ovf(N);

					IF (((NOT A(N-1)) AND (NOT B(N-1)) AND sig_ovf(N-1)) OR (A(N-1) AND B(N-1) AND (NOT sig_ovf(N-1)))) = '1' THEN
						Ovf	<= '1';
					ELSE
						Ovf	<= '0';
					END IF;

				WHEN "101" => --Sub Result, A, B

					sig_ovf	<= sig_A - sig_B;
					sig_res	<= sig_A(N-1 DOWNTO 0) - sig_B(N-1 DOWNTO 0);
					Cout	<= sig_ovf(N);

					IF ((A(N-1) AND (NOT B(N-1)) AND (NOT sig_ovf(N-1))) OR ((NOT A(N-1)) AND B(N-1) AND sig_ovf(N-1))) = '1' THEN
						Ovf	<= '1';
					ELSE
						Ovf	<= '0';
					END IF;

				WHEN "110" => --sll Result, A, B
					sig_ovf <= STD_LOGIC_VECTOR( unsigned(sig_A) sll to_integer(unsigned(sig_B(3 DOWNTO 0))) );
					sig_res <= STD_LOGIC_VECTOR( unsigned(sig_A(N-1 DOWNTO 0)) sll to_integer(unsigned(sig_B(3 DOWNTO 0))) );
					Cout	<= sig_ovf(N);

					IF ( A(N-1) XOR sig_ovf(N-1) ) = '1' THEN
						Ovf	<= '1';
					ELSE
						Ovf	<= '0';
					END IF;
					
				WHEN OTHERS => --any other input
					sig_ovf	<= (OTHERS => '0');
					sig_res	<= (OTHERS => '0');
					Ovf		<= '0';
					Cout	<= '0';
				END CASE;
				
				
			
			END IF;
		END IF;

	END PROCESS;

	-- for zero output
	Zero <= '1' WHEN sig_res = (sig_res'RANGE => '0')
			ELSE '0';

	-- connect internal signal with output
	Result <= sig_res;

END behv;
--------------------------------------------------------------------------------