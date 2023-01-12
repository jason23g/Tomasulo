-------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
-------------------------------------------------------------------------------
ENTITY MUX_2xN IS
GENERIC(n: INTEGER);
PORT(
	sel		: IN STD_LOGIC;
	Din0	: IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
	Din1	: IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
	Dout	: OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0)
);
END MUX_2xN;
-------------------------------------------------------------------------------
ARCHITECTURE behv OF MUX_2xN IS
BEGIN
	PROCESS(sel, Din0, Din1)
	BEGIN
		CASE sel IS
			WHEN '0' => Dout <= Din0;
			WHEN '1' => Dout <= Din1;
			WHEN OTHERS =>	Dout <= (OTHERS => '0');
		END CASE;
	END PROCESS;
END behv;
-------------------------------------------------------------------------------

--COMPONENT MUX_2xN
--GENERIC(n: INTEGER);
--PORT(
--	sel		: IN STD_LOGIC;
--	Din0	: IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
--	Din1	: IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
--	Dout	: OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0)
--);
--END COMPONENT;


--my_mux : MUX_2xN
--GENERIC MAP(n => mux_width) -- change to your preferred size
--PORT MAP(
--	sel		=> ,
--	Din0	=> ,
--	Din1	=> ,
--	Dout	=>
--);