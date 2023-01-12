-------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE WORK.common.ALL;
-------------------------------------------------------------------------------
ENTITY MUX_32xN_TB IS
GENERIC(
	data_size	: NATURAL := 16
);
END MUX_32xN_TB;
-------------------------------------------------------------------------------
ARCHITECTURE behv OF MUX_32xN_TB IS

	-- Component Declaration for the Unit Under Test (UUT)
	COMPONENT MUX_32xN
	GENERIC(n: INTEGER);
	PORT(
		sel		: IN STD_LOGIC_VECTOR(4 DOWNTO 0);
		Din0	: IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
		Din1	: IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
		Din2	: IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
		Din3	: IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
		Din4	: IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
		Din5	: IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
		Din6	: IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
		Din7	: IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
		Din8	: IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
		Din9	: IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
		Din10	: IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
		Din11	: IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
		Din12	: IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
		Din13	: IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
		Din14	: IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
		Din15	: IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
		Din16	: IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
		Din17	: IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
		Din18	: IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
		Din19	: IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
		Din20	: IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
		Din21	: IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
		Din22	: IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
		Din23	: IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
		Din24	: IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
		Din25	: IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
		Din26	: IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
		Din27	: IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
		Din28	: IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
		Din29	: IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
		Din30	: IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
		Din31	: IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
		Dout	: OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0)
	);
	END COMPONENT;

	-- Inputs
	SIGNAL sel : STD_LOGIC_VECTOR(4 DOWNTO 0) := (OTHERS => '0');
	SIGNAL Din0 : STD_LOGIC_VECTOR(data_size-1 DOWNTO 0) := (OTHERS => '0');
	SIGNAL Din1 : STD_LOGIC_VECTOR(data_size-1 DOWNTO 0) := (OTHERS => '0');
	SIGNAL Din2 : STD_LOGIC_VECTOR(data_size-1 DOWNTO 0) := (OTHERS => '0');
	SIGNAL Din3 : STD_LOGIC_VECTOR(data_size-1 DOWNTO 0) := (OTHERS => '0');
	SIGNAL Din4 : STD_LOGIC_VECTOR(data_size-1 DOWNTO 0) := (OTHERS => '0');
	SIGNAL Din5 : STD_LOGIC_VECTOR(data_size-1 DOWNTO 0) := (OTHERS => '0');
	SIGNAL Din6 : STD_LOGIC_VECTOR(data_size-1 DOWNTO 0) := (OTHERS => '0');
	SIGNAL Din7 : STD_LOGIC_VECTOR(data_size-1 DOWNTO 0) := (OTHERS => '0');
	SIGNAL Din8 : STD_LOGIC_VECTOR(data_size-1 DOWNTO 0) := (OTHERS => '0');
	SIGNAL Din9 : STD_LOGIC_VECTOR(data_size-1 DOWNTO 0) := (OTHERS => '0');
	SIGNAL Din10 : STD_LOGIC_VECTOR(data_size-1 DOWNTO 0) := (OTHERS => '0');
	SIGNAL Din11 : STD_LOGIC_VECTOR(data_size-1 DOWNTO 0) := (OTHERS => '0');
	SIGNAL Din12 : STD_LOGIC_VECTOR(data_size-1 DOWNTO 0) := (OTHERS => '0');
	SIGNAL Din13 : STD_LOGIC_VECTOR(data_size-1 DOWNTO 0) := (OTHERS => '0');
	SIGNAL Din14 : STD_LOGIC_VECTOR(data_size-1 DOWNTO 0) := (OTHERS => '0');
	SIGNAL Din15 : STD_LOGIC_VECTOR(data_size-1 DOWNTO 0) := (OTHERS => '0');
	SIGNAL Din16 : STD_LOGIC_VECTOR(data_size-1 DOWNTO 0) := (OTHERS => '0');
	SIGNAL Din17 : STD_LOGIC_VECTOR(data_size-1 DOWNTO 0) := (OTHERS => '0');
	SIGNAL Din18 : STD_LOGIC_VECTOR(data_size-1 DOWNTO 0) := (OTHERS => '0');
	SIGNAL Din19 : STD_LOGIC_VECTOR(data_size-1 DOWNTO 0) := (OTHERS => '0');
	SIGNAL Din20 : STD_LOGIC_VECTOR(data_size-1 DOWNTO 0) := (OTHERS => '0');
	SIGNAL Din21 : STD_LOGIC_VECTOR(data_size-1 DOWNTO 0) := (OTHERS => '0');
	SIGNAL Din22 : STD_LOGIC_VECTOR(data_size-1 DOWNTO 0) := (OTHERS => '0');
	SIGNAL Din23 : STD_LOGIC_VECTOR(data_size-1 DOWNTO 0) := (OTHERS => '0');
	SIGNAL Din24 : STD_LOGIC_VECTOR(data_size-1 DOWNTO 0) := (OTHERS => '0');
	SIGNAL Din25 : STD_LOGIC_VECTOR(data_size-1 DOWNTO 0) := (OTHERS => '0');
	SIGNAL Din26 : STD_LOGIC_VECTOR(data_size-1 DOWNTO 0) := (OTHERS => '0');
	SIGNAL Din27 : STD_LOGIC_VECTOR(data_size-1 DOWNTO 0) := (OTHERS => '0');
	SIGNAL Din28 : STD_LOGIC_VECTOR(data_size-1 DOWNTO 0) := (OTHERS => '0');
	SIGNAL Din29 : STD_LOGIC_VECTOR(data_size-1 DOWNTO 0) := (OTHERS => '0');
	SIGNAL Din30 : STD_LOGIC_VECTOR(data_size-1 DOWNTO 0) := (OTHERS => '0');
	SIGNAL Din31 : STD_LOGIC_VECTOR(data_size-1 DOWNTO 0) := (OTHERS => '0');

	-- Outputs
	SIGNAL Dout : STD_LOGIC_VECTOR(data_size-1 DOWNTO 0);

BEGIN
	-- Instantiate the Unit Under Test (UUT)
	uut : MUX_32xN
	GENERIC MAP(n => data_size)
	PORT MAP(
		sel => sel,
		Din0 => Din0,
		Din1 => Din1,
		Din2 => Din2,
		Din3 => Din3,
		Din4 => Din4,
		Din5 => Din5,
		Din6 => Din6,
		Din7 => Din7,
		Din8 => Din8,
		Din9 => Din9,
		Din10 => Din10,
		Din11 => Din11,
		Din12 => Din12,
		Din13 => Din13,
		Din14 => Din14,
		Din15 => Din15,
		Din16 => Din16,
		Din17 => Din17,
		Din18 => Din18,
		Din19 => Din19,
		Din20 => Din20,
		Din21 => Din21,
		Din22 => Din22,
		Din23 => Din23,
		Din24 => Din24,
		Din25 => Din25,
		Din26 => Din26,
		Din27 => Din27,
		Din28 => Din28,
		Din29 => Din29,
		Din30 => Din30,
		Din31 => Din31,
		Dout => Dout
	);

	-- Stimulus process
	stim_proc : PROCESS
	BEGIN
		-- insert stimulus here
		Din0 <= x"ABCD";
		Din1 <= x"AAAA";
		Din2 <= x"BBBB";
		Din4 <= x"CCCC";
		Din8 <= x"7777";
		Din16 <= x"FFFF";
		Din18 <= x"8585";
		Din31 <= x"00B0";

		sel <= "00000";
		WAIT FOR 10 ns;

		sel <= "00001";
		WAIT FOR 10 ns;

		sel <= "00010";
		WAIT FOR 10 ns;

		Din2 <= x"00FD";
		Din4 <= x"00FC";
		sel <= "00100";
		WAIT FOR 10 ns;

		sel <= "01000";
		WAIT FOR 10 ns;

		sel <= "10000";
		WAIT FOR 10 ns;

		sel <= "10010";
		WAIT FOR 10 ns;

		sel <= "11111";
		WAIT FOR 10 ns;

		WAIT;
	END PROCESS;

END;
-------------------------------------------------------------------------------