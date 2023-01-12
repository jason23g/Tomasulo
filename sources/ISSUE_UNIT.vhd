--------------------------------------------------------------------------------
-- Engineer:		JASON GEORGAKAS
-- 
-- Create Date:		13/05/2022 
-- Module Name:		Issue - behv
-- Project Name:	Tomasulo_v1.00
-- Tool versions:	ISE Project Navigator (P.20131013)
-- Description:
-- 
-- This module decides if an instruction is going to execute by using the
-- information about the state of the RS's of the Arithmetic and Logical units.
-- 
-- Revision:
-- Revision 0.02 - File header updated
-- Additional Comments:
-- Op codes for  ISA
--
-- 		OR	: 001
-- 		AND	: 010
-- 		NOT	: 011
-- 		ADD	: 100
-- 		SUB	: 101
-- 		SLL	: 110
-- 		LI	: 111
--
--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--------------------------------------------------------------------------------
ENTITY ISSUE_UNIT IS
PORT(
	CLK				: IN STD_LOGIC;
	RST				: IN STD_LOGIC;

	Issue			: IN  STD_LOGIC;

	FU_Type			: IN  STD_LOGIC_VECTOR(1 DOWNTO 0);
	Fop_IF			: IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
	Ri_IF			: IN  STD_LOGIC_VECTOR(4 DOWNTO 0);
	Rj_IF			: IN  STD_LOGIC_VECTOR(4 DOWNTO 0);
	Rk_IF			: IN  STD_LOGIC_VECTOR(4 DOWNTO 0);
	Immed_IF		: IN  STD_LOGIC_VECTOR(15 DOWNTO 0);

	-- from arithmetic and logical
	Avail_RS		: IN  STD_LOGIC_VECTOR(1 DOWNTO 0);

	-- to arithmetic, logical
	Fop				: OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
	-- to arithmetic, logical and Register File
	Ri				: OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
	Rj				: OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
	Rk				: OUT STD_LOGIC_VECTOR(4 DOWNTO 0);

	-- to Register File
	Immed			: OUT STD_LOGIC_VECTOR(15 DOWNTO 0); 

	-- to Register File
	Accepted		: OUT STD_LOGIC;
	-- to arithmetic, logical and Register File
	Arith_Issue		: OUT STD_LOGIC;
	Logical_Issue	: OUT STD_LOGIC;
	Issue_Immed		: OUT STD_LOGIC
);
END ISSUE_UNIT;
--------------------------------------------------------------------------------
ARCHITECTURE behv OF ISSUE_UNIT IS

BEGIN


	PROCESS(CLK, RST, Issue, Avail_RS, FU_Type, Fop_IF)
	BEGIN
		IF RST = '0' THEN

			Fop				<= (OTHERS => '0');
			Ri				<= (OTHERS => '0');
			Rj				<= (OTHERS => '0');
			Rk				<= (OTHERS => '0');
			Immed			<= (OTHERS => '0');
			Accepted		<= '0';
			Arith_Issue		<= '0';
			Logical_Issue	<= '0';
			Issue_Immed		<= '0';

		ELSIF rising_edge(CLK) THEN

			IF Issue = '1' THEN

				Fop				<= Fop_IF;
				Ri				<= Ri_IF;
				Rj				<= Rj_IF;
				Rk				<= Rk_IF;
				Immed			<= Immed_IF;

				-- load immediate
				IF Fop_IF = "111" THEN
					Accepted		<= '1';
					Arith_Issue		<= '0';
					Logical_Issue	<= '0';
					Issue_Immed		<= '1';
				ELSE
					Issue_Immed	<= '0';

					IF Avail_RS = "00" THEN
						Accepted		<='0';

					-- logical instr
					ELSIF Avail_RS = "10" AND FU_Type = "10" THEN
						Accepted		<= '1';
						Arith_Issue		<= '0';
						Logical_Issue	<= '1';

					-- arithmetic instr
					ELSIF Avail_RS = "01" AND FU_Type = "01" THEN
						Accepted		<= '1';
						Arith_Issue		<= '1';
						Logical_Issue	<= '0';

					ELSIF Avail_RS = "11" THEN

						IF FU_Type = "10" THEN
							Accepted		<= '1';
							Arith_Issue		<= '0';
							Logical_Issue	<= '1';
						ELSIF FU_Type = "01" THEN
							Accepted		<= '1';
							Arith_Issue		<= '1';
							Logical_Issue	<= '0';
						ELSE
							Accepted		<= '0';
							Arith_Issue		<= '0';
							Logical_Issue	<= '0';
						END IF;

					ELSE
						Accepted		<= '0';
						Arith_Issue		<= '0';
						Logical_Issue	<= '0';
					END IF;
				END IF;

			ELSE
				Accepted		<= '0';
				Arith_Issue		<= '0';
				Logical_Issue	<= '0';
			END IF;

		END IF;

	END PROCESS;

END behv;
--------------------------------------------------------------------------------