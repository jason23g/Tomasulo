----------------------------------------------------------------------------------
-- Engineer: 
-- 
-- Create Date:		04/06/2022 
-- Module Name:		PROCESSOR_TB - behv
-- Project Name:	Tomasulo_v1.00
-- Tool versions:
-- Description:
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use work.common.all;
--------------------------------------------------------------------------------
ENTITY PROCESSOR_TB IS
generic(
	reg_size	: INTEGER := 16;
	reg_num		: INTEGER := 32;
	reg_width	: INTEGER := 5;
	rs_num		: INTEGER := 5+1;
	rs_width	: INTEGER := 3;
	op_width	: INTEGER := 3
);
END PROCESSOR_TB;
--------------------------------------------------------------------------------
ARCHITECTURE behavior OF PROCESSOR_TB IS 

	-- Component Declaration
	COMPONENT PROCESSOR
	PORT(
		CLK			: IN std_logic;
		RST			: IN std_logic;
		Issue		: IN std_logic;
		FU_Type		: IN std_logic_vector(1 DOWNTO 0);
		Fop_IF		: IN std_logic_vector(2 DOWNTO 0);
		Ri_IF		: IN std_logic_vector(4 DOWNTO 0);
		Rj_IF		: IN std_logic_vector(4 DOWNTO 0);
		Rk_IF		: IN std_logic_vector(4 DOWNTO 0);
		Immed_IF	: IN std_logic_vector(reg_size-1 DOWNTO 0)
	);
	END COMPONENT;

	SIGNAL CLK		: std_logic := '0';
	SIGNAL RST		: std_logic := '0';
	SIGNAL Issue	: std_logic := '0';
	SIGNAL FU_Type	: std_logic_vector(1 DOWNTO 0):= (OTHERS => '0');
	SIGNAL Fop_IF	: std_logic_vector(2 DOWNTO 0):= (OTHERS => '0');
	SIGNAL Ri_IF	: std_logic_vector(4 DOWNTO 0):= (OTHERS => '0');
	SIGNAL Rj_IF	: std_logic_vector(4 DOWNTO 0):= (OTHERS => '0');
	SIGNAL Rk_IF	: std_logic_vector(4 DOWNTO 0):= (OTHERS => '0');
	SIGNAL Immed_IF : std_logic_vector(reg_size-1 DOWNTO 0):= (OTHERS => '0');

BEGIN

	-- Component Instantiation
	uut :  PROCESSOR 
	PORT MAP(
		CLK			=> CLK,
		RST			=> RST,
		Issue		=> Issue,
		FU_Type		=> FU_Type,
		Fop_IF		=> Fop_IF,
		Ri_IF		=> Ri_IF,
		Rj_IF		=> Rj_IF,
		Rk_IF		=> Rk_IF,
		Immed_IF	=> Immed_IF
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
		-- hold reset state for 100 ns.
		RST			<= '0';
		WAIT FOR CLK_period*2;

		RST			<= '1';

		-- li R1, x0020
		Issue		<= '1';
		FU_Type		<= "01";
		Fop_IF		<= "111";
		Ri_IF		<= "00001";
		Rj_IF		<= "00000";
		Rk_IF		<= "00000";
		Immed_IF	<= x"0002";
		WAIT FOR CLK_period;

		-- li R2, x0300
		Issue		<= '1';
		FU_Type		<= "01";
		Fop_IF		<= "111";
		Ri_IF		<= "00010";
		Rj_IF		<= "00000";
		Rk_IF		<= "00000";
		Immed_IF	<= x"03F0";
		WAIT FOR CLK_period;

		-- li R3, x0327
		Issue		<= '1';
		FU_Type		<= "01";
		Fop_IF		<= "111";
		Ri_IF		<= "00011";
		Rj_IF		<= "00000";
		Rk_IF		<= "00000";
		Immed_IF	<= x"0327";
		WAIT FOR CLK_period;


--		--Senario 1
--
--		-- sub R4, R3, R2
--		Issue		<= '1';
--		FU_Type		<= "01";
--		Fop_IF		<= "101";
--		Ri_IF		<= "00100";
--		Rj_IF		<= "00011";
--		Rk_IF		<= "00010";
--		Immed_IF	<= x"0000";
--		WAIT FOR CLK_period;
--
--		Issue		<= '0';
--		WAIT FOR CLK_period*4;
--
--		-- and R5, R3, R1
--		Issue		<= '1';
--		FU_Type		<= "10";
--		Fop_IF		<= "010";
--		Ri_IF		<= "00101";
--		Rj_IF		<= "00011";
--		Rk_IF		<= "00001";
--		Immed_IF	<= x"0000";
--		WAIT FOR CLK_period;
--
--		Issue		<= '0';
--		WAIT FOR CLK_period*4;
--
--		-- or R6, R2, R1
--		Issue		<= '1';
--		FU_Type		<= "10";
--		Fop_IF		<= "001";
--		Ri_IF		<= "00110";
--		Rj_IF		<= "00010";
--		Rk_IF		<= "00001";
--		Immed_IF	<= x"0000";
--		WAIT FOR CLK_period;
--
--		Issue		<= '0';
--		WAIT FOR CLK_period*4;
--
--
--		-- add R7, R3, R1
--		Issue		<= '1';
--		FU_Type		<= "01";
--		Fop_IF		<= "101";
--		Ri_IF		<= "00111";
--		Rj_IF		<= "00011";
--		Rk_IF		<= "00001";
--		Immed_IF	<= x"0000";
--		WAIT FOR CLK_period;
--
--		Issue		<= '0';
--		WAIT FOR CLK_period*4;
--
--		-- not R8, R3, R2
--		Issue		<= '1';
--		FU_Type		<= "10";
--		Fop_IF		<= "011";
--		Ri_IF		<= "01000";
--		Rj_IF		<= "00011";
--		Rk_IF		<= "00010";
--		Immed_IF	<= x"0000";
--		WAIT FOR CLK_period;
--
--		Issue		<= '0';
--		WAIT FOR CLK_period;

--		-- Senario 2
--
--		-- sub R4, R3, R2
--		Issue		<= '1';
--		FU_Type		<= "01";
--		Fop_IF		<= "101";
--		Ri_IF		<= "00100";
--		Rj_IF		<= "00011";
--		Rk_IF		<= "00010";
--		Immed_IF	<= x"0000";
--		WAIT FOR CLK_period;
--
--		-- and R5, R3, R1
--		Issue		<= '1';
--		FU_Type		<= "10";
--		Fop_IF		<= "010";
--		Ri_IF		<= "00101";
--		Rj_IF		<= "00011";
--		Rk_IF		<= "00001";
--		Immed_IF	<= x"0000";
--		WAIT FOR CLK_period;
--
--		Issue		<= '0';
--		WAIT FOR CLK_period;

--		-- Senario 3
--
--		-- or R6, R2, R1
--		Issue		<= '1';
--		FU_Type		<= "10";
--		Fop_IF		<= "001";
--		Ri_IF		<= "00110";
--		Rj_IF		<= "00010";
--		Rk_IF		<= "00001";
--		Immed_IF	<= x"0000";
--		WAIT FOR CLK_period;
--
--		-- and R5, R3, R1
--		Issue		<= '1';
--		FU_Type		<= "10";
--		Fop_IF		<= "010";
--		Ri_IF		<= "00101";
--		Rj_IF		<= "00011";
--		Rk_IF		<= "00001";
--		Immed_IF	<= x"0000";
--		WAIT FOR CLK_period;
--
--		-- not R8, R3, R2
--		Issue		<= '1';
--		FU_Type		<= "10";
--		Fop_IF		<= "011";
--		Ri_IF		<= "01000";
--		Rj_IF		<= "00011";
--		Rk_IF		<= "00010";
--		Immed_IF	<= x"0000";
--		WAIT FOR CLK_period;
--
--		Issue		<= '0';


--		-- Senario 4
--
--		-- sub R4, R3, R2
--		Issue		<= '1';
--		FU_Type		<= "01";
--		Fop_IF		<= "101";
--		Ri_IF		<= "00100";
--		Rj_IF		<= "00011";
--		Rk_IF		<= "00010";
--		Immed_IF	<= x"0000";
--		WAIT FOR CLK_period;
--
--		-- and R5, R3, R1
--		Issue		<= '1';
--		FU_Type		<= "10";
--		Fop_IF		<= "010";
--		Ri_IF		<= "00101";
--		Rj_IF		<= "00011";
--		Rk_IF		<= "00001";
--		Immed_IF	<= x"0000";
--		WAIT FOR CLK_period;
--
--		-- or R6, R2, R1
--		Issue		<= '1';
--		FU_Type		<= "10";
--		Fop_IF		<= "001";
--		Ri_IF		<= "00110";
--		Rj_IF		<= "00010";
--		Rk_IF		<= "00001";
--		Immed_IF	<= x"0000";
--		WAIT FOR CLK_period;
--
--		-- add R7, R3, R1
--		Issue		<= '1';
--		FU_Type		<= "01";
--		Fop_IF		<= "101";
--		Ri_IF		<= "00111";
--		Rj_IF		<= "00011";
--		Rk_IF		<= "00001";
--		Immed_IF	<= x"0000";
--		WAIT FOR CLK_period;
--
--		Issue		<= '0';
--		WAIT FOR CLK_period*3;
--
--		-- not R8, R3, R2
--		Issue		<= '1';
--		FU_Type		<= "10";
--		Fop_IF		<= "011";
--		Ri_IF		<= "01000";
--		Rj_IF		<= "00011";
--		Rk_IF		<= "00010";
--		Immed_IF	<= x"0000";
--		WAIT FOR CLK_period;
--
--		Issue		<= '0';


		-- Senario 5

		-- sll R4, R1, R1 : 0x8
		Issue		<= '1';
		FU_Type		<= "01";
		Fop_IF		<= "110";
		Ri_IF		<= "00100";
		Rj_IF		<= "00001";
		Rk_IF		<= "00001";
		Immed_IF	<= x"0000";
		WAIT FOR CLK_period;

		-- add R5, R2, R4 : 0x3F8
		Issue		<= '1';
		FU_Type		<= "01";
		Fop_IF		<= "100";
		Ri_IF		<= "00101";
		Rj_IF		<= "00010";
		Rk_IF		<= "00100";
		Immed_IF	<= x"0000";
		WAIT FOR CLK_period;

		-- and R6, R5, R1 : 0x0
		Issue		<= '1';
		FU_Type		<= "10";
		Fop_IF		<= "010";
		Ri_IF		<= "00110";
		Rj_IF		<= "00101";
		Rk_IF		<= "00001";
		Immed_IF	<= x"0000";
		WAIT FOR CLK_period;

		-- add R7, R5, R4 : 0x400
		Issue		<= '1';
		FU_Type		<= "01";
		Fop_IF		<= "100";
		Ri_IF		<= "00111";
		Rj_IF		<= "00101";
		Rk_IF		<= "00100";
		Immed_IF	<= x"0000";
		WAIT FOR CLK_period;

		Issue		<= '0';
		WAIT FOR CLK_period*3;

		-- not R8, R7 : 0xfbff
		Issue		<= '1';
		FU_Type		<= "10";
		Fop_IF		<= "011";
		Ri_IF		<= "01000";
		Rj_IF		<= "00111";
		Rk_IF		<= "00000";
		Immed_IF	<= x"0000";
		WAIT FOR CLK_period;
		
		Issue		<= '0';

		WAIT; -- will wait forever
	END PROCESS; -- stim_proc

END;
--------------------------------------------------------------------------------