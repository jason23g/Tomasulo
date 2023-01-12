-------------------------------------------------------------------------------
USE WORK.common.ALL;
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
-------------------------------------------------------------------------------
ENTITY DEC_5_to_32_TB IS
END DEC_5_to_32_TB;
-------------------------------------------------------------------------------
ARCHITECTURE behv OF DEC_5_to_32_TB IS

	-- Component Declaration for the Unit Under Test (UUT)
	COMPONENT DEC_5_to_32
	PORT(
		dec_in : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
		dec_out: OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
	);
	END COMPONENT;

	-- Inputs
	SIGNAL dec_in : STD_LOGIC_VECTOR(4 DOWNTO 0) := (OTHERS => '0');

	-- Outputs
	SIGNAL dec_out : STD_LOGIC_VECTOR(31 DOWNTO 0);

BEGIN

	-- Instantiate the Unit Under Test (UUT)
	uut : DEC_5_to_32
	PORT MAP(
		dec_in => dec_in,
		dec_out => dec_out
	);

	-- Stimulus process
	stim_proc : PROCESS
	BEGIN
		-- insert stimulus here
		dec_in <= "00000";
		WAIT FOR 10 ns;

		dec_in <= "00001";
		WAIT FOR 10 ns;

		dec_in <= "00010";
		WAIT FOR 10 ns;

		dec_in <= "00100";
		WAIT FOR 10 ns;

		dec_in <= "01000";
		WAIT FOR 10 ns;

		dec_in <= "10000";
		WAIT FOR 10 ns;

		dec_in <= "10101";
		WAIT FOR 10 ns;
		WAIT;
	END PROCESS;
END;
-------------------------------------------------------------------------------