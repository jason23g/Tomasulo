-------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE WORK.common.ALL;
-------------------------------------------------------------------------------
ENTITY MUX_2xN_TB IS
GENERIC(
	n : INTEGER := 16
);
END MUX_2xN_TB;
-------------------------------------------------------------------------------
ARCHITECTURE behv OF MUX_2xN_TB IS

	-- Component Declaration for the Unit Under Test (UUT)
	COMPONENT MUX_2xN
	GENERIC(n: INTEGER);
	PORT(
		sel		: IN STD_LOGIC;
		Din0	: IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
		Din1	: IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
		Dout	: OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0)
	);
	END COMPONENT;

	-- Inputs
	SIGNAL sel : STD_LOGIC := '0';
	SIGNAL Din0 : STD_LOGIC_VECTOR(DWORD-1 DOWNTO 0) := (OTHERS => '0');
	SIGNAL Din1 : STD_LOGIC_VECTOR(DWORD-1 DOWNTO 0) := (OTHERS => '0');

	-- Outputs
	SIGNAL Dout : STD_LOGIC_VECTOR(DWORD-1 DOWNTO 0);

BEGIN
	-- Instantiate the Unit Under Test (UUT)
	uut : MUX_2xN
	GENERIC MAP(n => n)
	PORT MAP(
		sel => sel,
		Din0 => Din0,
		Din1 => Din1,
		Dout => Dout
	);

	-- Stimulus process
	stim_proc : PROCESS
	BEGIN
	-- insert stimulus here
	Din0 <= x"ABCD";
	Din1 <= x"3333";

	sel <= '0';
	WAIT FOR 100 ns;

	sel <= '1';
	WAIT FOR 100 ns;

	Din0 <= x"0000";
	Din1 <= x"FFFF";
	sel <= '0';
	WAIT FOR 100 ns;

	sel <= '1';
	WAIT FOR 100 ns;

	WAIT;
	END PROCESS;

END;
-------------------------------------------------------------------------------