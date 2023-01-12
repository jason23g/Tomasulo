--------------------------------------------------------------------------------
USE WORK.common.ALL;
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
--------------------------------------------------------------------------------
ENTITY COMPARATOR_TB IS
GENERIC(
	n : INTEGER := 3
);
END COMPARATOR_TB;
--------------------------------------------------------------------------------
ARCHITECTURE behv OF COMPARATOR_TB IS

	COMPONENT COMPARATOR
	GENERIC(n : INTEGER);
	PORT(
		A	: IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
		B	: IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
		eq	: OUT STD_LOGIC
	);
	END COMPONENT;

	-- Inputs
	SIGNAL A : STD_LOGIC_VECTOR(n-1 DOWNTO 0) := (OTHERS => '0');
	SIGNAL B : STD_LOGIC_VECTOR(n-1 DOWNTO 0) := (OTHERS => '0');

	-- Outputs
	SIGNAL eq : STD_LOGIC;

BEGIN

	uut : COMPARATOR
	GENERIC MAP(n => n)
	PORT MAP(
		A	=> A,
		B	=> B,
		eq	=> eq
	);

	-- Stimulus process
	stim_proc : PROCESS
	BEGIN

	-- insert stimulus here
	A <= "000";
	B <= "000";
	WAIT FOR 100 ns;

	A <= "000";
	B <= "011";
	WAIT FOR 100 ns;

	A <= "100";
	B <= "100";
	WAIT FOR 100 ns;

	A <= "111";
	B <= "111";
	WAIT FOR 100 ns;

	WAIT;
	END PROCESS;

END;
--------------------------------------------------------------------------------