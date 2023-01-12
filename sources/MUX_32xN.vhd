-------------------------------------------------------------------------------
USE WORK.common.ALL;
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
-------------------------------------------------------------------------------
ENTITY MUX_32xN IS
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
END MUX_32xN;
-------------------------------------------------------------------------------
ARCHITECTURE behv OF MUX_32xN IS
BEGIN
	PROCESS(sel, Din0, Din1, Din2, Din3, Din4, Din5, Din6, Din7, Din8, Din9,
			Din10, Din11, Din12, Din13, Din14, Din15, Din16, Din17, Din18,
			Din19, Din20, Din21, Din22, Din23, Din24, Din25, Din26, Din27,
			Din28, Din29, Din30, Din31)
	BEGIN
		CASE sel IS
			WHEN "00000" => Dout <= Din0;
			WHEN "00001" => Dout <= Din1;
			WHEN "00010" => Dout <= Din2;
			WHEN "00011" => Dout <= Din3;
			WHEN "00100" => Dout <= Din4;
			WHEN "00101" => Dout <= Din5;
			WHEN "00110" => Dout <= Din6;
			WHEN "00111" => Dout <= Din7;
			WHEN "01000" => Dout <= Din8;
			WHEN "01001" => Dout <= Din9;
			WHEN "01010" => Dout <= Din10;
			WHEN "01011" => Dout <= Din11;
			WHEN "01100" => Dout <= Din12;
			WHEN "01101" => Dout <= Din13;
			WHEN "01110" => Dout <= Din14;
			WHEN "01111" => Dout <= Din15;
			WHEN "10000" => Dout <= Din16;
			WHEN "10001" => Dout <= Din17;
			WHEN "10010" => Dout <= Din18;
			WHEN "10011" => Dout <= Din19;
			WHEN "10100" => Dout <= Din20;
			WHEN "10101" => Dout <= Din21;
			WHEN "10110" => Dout <= Din22;
			WHEN "10111" => Dout <= Din23;
			WHEN "11000" => Dout <= Din24;
			WHEN "11001" => Dout <= Din25;
			WHEN "11010" => Dout <= Din26;
			WHEN "11011" => Dout <= Din27;
			WHEN "11100" => Dout <= Din28;
			WHEN "11101" => Dout <= Din29;
			WHEN "11110" => Dout <= Din30;
			WHEN "11111" => Dout <= Din31;
			WHEN OTHERS =>	Dout <= (OTHERS => '0');
		END CASE;
	END PROCESS;
END behv;
-------------------------------------------------------------------------------


--COMPONENT MUX_32xN
--GENERIC(n: INTEGER);
--PORT(
--	sel		: IN STD_LOGIC_VECTOR(4 DOWNTO 0);
--	Din0	: IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
--	Din1	: IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
--	Din2	: IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
--	Din3	: IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
--	Din4	: IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
--	Din5	: IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
--	Din6	: IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
--	Din7	: IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
--	Din8	: IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
--	Din9	: IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
--	Din10	: IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
--	Din11	: IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
--	Din12	: IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
--	Din13	: IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
--	Din14	: IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
--	Din15	: IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
--	Din16	: IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
--	Din17	: IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
--	Din18	: IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
--	Din19	: IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
--	Din20	: IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
--	Din21	: IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
--	Din22	: IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
--	Din23	: IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
--	Din24	: IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
--	Din25	: IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
--	Din26	: IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
--	Din27	: IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
--	Din28	: IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
--	Din29	: IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
--	Din30	: IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
--	Din31	: IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
--	Dout	: OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0)
--);
--END COMPONENT;


--my_mux : MUX_32xN
--GENERIC MAP(n => mux_width) -- change to your preferred size
--PORT MAP(
--	sel		=> ,
--	Din0	=> ,
--	Din1	=> ,
--	Din2	=> ,
--	Din3	=> ,
--	Din4	=> ,
--	Din5	=> ,
--	Din6	=> ,
--	Din7	=> ,
--	Din8	=> ,
--	Din9	=> ,
--	Din10	=> ,
--	Din11	=> ,
--	Din12	=> ,
--	Din13	=> ,
--	Din14	=> ,
--	Din15	=> ,
--	Din16	=> ,
--	Din17	=> ,
--	Din18	=> ,
--	Din19	=> ,
--	Din20	=> ,
--	Din21	=> ,
--	Din22	=> ,
--	Din23	=> ,
--	Din24	=> ,
--	Din25	=> ,
--	Din26	=> ,
--	Din27	=> ,
--	Din28	=> ,
--	Din29	=> ,
--	Din30	=> ,
--	Din31	=> ,
--	Dout	=>
--);