--------------------------------------------------------------------------------
-- Engineer:		PANOS VASILEIOU
--
-- Create Date:		12/04/2022
-- Module Name:		ARITHMETIC_FU_TB.vhd - behv
-- Project Name:	Tomasulo_v1.00
-- Tool versions:	ISE Project Navigator & ISim (P.20131013)
-- Description:
-- 
-- VHDL Test Bench Created by the author for module: ARITHMETIC_FU
-- 
-- Dependencies:	ARITHMETIC_FU, common
-- 
-- Revision 0.01 - File Created
-- Additional Comments:
--------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
use work.common.all;
--------------------------------------------------------------------------------
ENTITY ARITHMETIC_FU_TB IS
GENERIC(
	N			: INTEGER := 16;
	op_width	: INTEGER := 3
);
END ARITHMETIC_FU_TB;
--------------------------------------------------------------------------------
ARCHITECTURE behv OF ARITHMETIC_FU_TB IS

	-- Component Declaration for the Unit Under Test (UUT)
	COMPONENT ARITHMETIC_FU
	GENERIC(
		N 			: INTEGER := 16;
		op_width	: INTEGER := 3
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
	END COMPONENT;

	-- Inputs
	SIGNAL CLK		: std_logic := '0' ;
	SIGNAL RST		: std_logic := '0';
	SIGNAL WrEn		: std_logic := '0';
	SIGNAL A		: STD_LOGIC_VECTOR(N-1 DOWNTO 0) := (OTHERS => '0');
	SIGNAL B		: STD_LOGIC_VECTOR(N-1 DOWNTO 0) := (OTHERS => '0');
	SIGNAL Op		: STD_LOGIC_VECTOR(op_width-1 DOWNTO 0) := (OTHERS => '0');
	SIGNAL A8		: STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '0');
	SIGNAL B8		: STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '0');
	SIGNAL Op8		: STD_LOGIC_VECTOR(op_width-1 DOWNTO 0) := (OTHERS => '0');

	-- Outputs
	SIGNAL Cout		: STD_LOGIC;
	SIGNAL Result	: STD_LOGIC_VECTOR(N-1 DOWNTO 0);
	SIGNAL Ovf		: STD_LOGIC;
	SIGNAL Zero		: STD_LOGIC;
	SIGNAL Cout8	: STD_LOGIC;
	SIGNAL Result8	: STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL Ovf8		: STD_LOGIC;
	SIGNAL Zero8	: STD_LOGIC;

BEGIN

	-- Instantiate the Unit Under Test (UUT)
	uut1 : ARITHMETIC_FU
	GENERIC MAP(
		N		=> N,
		op_width => op_width
	)
	PORT MAP(
		CLK		=> CLK,
		RST		=> RST,
		WrEn	=> WrEn,
		A		=> A,
		B		=> B,
		Op		=> Op,
		Result	=> Result,
		Cout	=> Cout,
		Ovf		=> Ovf,
		Zero	=> Zero
	);

	-- Instantiate the Unit Under Test (UUT)
	uut2 : ARITHMETIC_FU
	GENERIC MAP(
		N		=> 8,
		op_width => op_width
	)
	PORT MAP(
		CLK		=> CLK,
		RST		=> RST,
		WrEn	=> WrEn,
		A		=> A8,
		B		=> B8,
		Op		=> Op8,
		Result	=> Result8,
		Cout	=> Cout8,
		Ovf		=> Ovf8,
		Zero	=> Zero8
	);
	
	-- Clock process definitions
	CLK_process : PROCESS
	BEGIN
		CLK <= '0';
		WAIT FOR CLK_period/2;
		CLK <= '1';
		WAIT FOR CLK_period/2;
	END PROCESS;

	-- Stimulus process
	stim_proc : PROCESS
	BEGIN
	
		RST			<= '0';
		WAIT FOR CLK_period*2;

		RST			<= '1';
		WrEn		<= '1';
		
		--------------- Addition --------------
		Op8 <= "100";--Add_1
		A8 <= "00001110";
		B8 <= "00000110";

		Op <= "100";
		A <= "0111110000000101";
		B <= "1111111000111111";
		WAIT FOR CLK_period;

		Op8 <= "100";--Add_2
		A8 <= "00000110";
		B8 <= "11111100";

		Op <= "100";
		A <= "0000001101110100";
		B <= "0111111111111111";
		WAIT FOR CLK_period;

		Op8 <= "100";--Add_3
		A8 <= "01111010";
		B8 <= "00001000";
		WAIT FOR CLK_period;

		Op8 <= "100";--Add_4
		A8 <= "01111010";
		B8 <= "11111000";
		WAIT FOR CLK_period;

		Op8 <= "100";--Add_5
		A8 <= "11000000";
		B8 <= "00001111";
		WAIT FOR 10 ns;

		Op8 <= "100";--Add_6
		A8 <= "10000100";
		B8 <= "11111100";
		WAIT FOR CLK_period;

		Op8 <= "100";--Add_7
		A8 <= "11111110";
		B8 <= "11111010";
		WAIT FOR CLK_period;

		Op8 <= "100";--Add_8
		A8 <= "11111111";
		B8 <= "00000001";
		WAIT FOR CLK_period;

		Op8 <= "100";--Add_9
		A8 <= "01111111";
		B8 <= "00000001";
		WAIT FOR CLK_period;

		-------------- Subtraction -------------

		Op8 <= "101";--Sub_1
		A8 <= "00001110";
		B8 <= "00000110";

		Op <= "101";
		A <= "0111110000000101";
		B <= "1111111000111111";
		WAIT FOR 10 ns;


		Op8 <= "101";--Sub_2
		A8 <= "00000110";
		B8 <= "11111100";

		Op <= "101";
		A <= "0000001101110100";
		B <= "0111111111111111";
		WAIT FOR CLK_period;

		Op8 <= "101";--Sub_3
		A8 <= "01111010";
		B8 <= "00001000";
		WAIT FOR CLK_period;
			
		Op8 <= "101";--Sub_4
		A8 <= "01111010";
		B8 <= "11111000";
		WAIT FOR CLK_period;

		Op8 <= "101";--Sub_5
		A8 <= "11000000";
		B8 <= "00001111";
		WAIT FOR CLK_period;

		Op8 <= "101";--Sub_6
		A8 <= "10000100";
		B8 <= "11111100";
		WAIT FOR CLK_period;

		Op8 <= "101";--Sub_7
		A8 <= "11111110";
		B8 <= "11111010";
		WAIT FOR CLK_period;

		Op8 <= "101";--Sub_8
		A8 <= "11111111";
		B8 <= "00000001";
		WAIT FOR CLK_period;

		Op8 <= "101";--Sub_9
		A8 <= "01111111";
		B8 <= "00000001";
		WAIT FOR CLK_period;

		Op8 <= "110";
		A8 <= "00100111";
		B8 <= x"01";
		Op <= "110";
		A <= "0010011100010010";
		B <= x"0004";
		WAIT FOR CLK_period;

		Op8 <= "110";
		A8 <= "00100111";
		B8 <= x"01";
		Op <= "110";
		A <= "1111111111111111";
		B <= x"0008";
		WAIT FOR CLK_period;

		Op8 <= "110";
		A8 <= "11100110";
		B8 <= x"02";
		Op <= "110";
		A <= "0111111111111111";
		B <= x"0001";
		WAIT FOR CLK_period;

		Op8 <= "110";
		A8 <= "00100111";
		B8 <= x"05";
		Op <= "110";
		A <= "0000000000000000";
		B <= x"0008";
		WAIT FOR CLK_period;

		WAIT;
	END PROCESS;

END behv;
--------------------------------------------------------------------------------