----------------------------------------------------------------------------------
--USE WORK.common.ALL;
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
----------------------------------------------------------------------------------
ENTITY DEC_5_to_32 IS
PORT(
	dec_in	: IN STD_LOGIC_VECTOR(4 DOWNTO 0);
	dec_out	: OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
);
END DEC_5_to_32;
----------------------------------------------------------------------------------
ARCHITECTURE behv OF DEC_5_to_32 IS
BEGIN
PROCESS(dec_in)
BEGIN
	dec_out <= (OTHERS => '0');
	CASE dec_in IS
		WHEN "00000" => dec_out(0) <= '1';
		WHEN "00001" => dec_out(1) <= '1';
		WHEN "00010" => dec_out(2) <= '1';
		WHEN "00011" => dec_out(3) <= '1';
		WHEN "00100" => dec_out(4) <= '1';
		WHEN "00101" => dec_out(5) <= '1';
		WHEN "00110" => dec_out(6) <= '1';
		WHEN "00111" => dec_out(7) <= '1';
		WHEN "01000" => dec_out(8) <= '1';
		WHEN "01001" => dec_out(9) <= '1';
		WHEN "01010" => dec_out(10) <= '1';
		WHEN "01011" => dec_out(11) <= '1';
		WHEN "01100" => dec_out(12) <= '1';
		WHEN "01101" => dec_out(13) <= '1';
		WHEN "01110" => dec_out(14) <= '1';
		WHEN "01111" => dec_out(15) <= '1';
		WHEN "10000" => dec_out(16) <= '1';
		WHEN "10001" => dec_out(17) <= '1';
		WHEN "10010" => dec_out(18) <= '1';
		WHEN "10011" => dec_out(19) <= '1';
		WHEN "10100" => dec_out(20) <= '1';
		WHEN "10101" => dec_out(21) <= '1';
		WHEN "10110" => dec_out(22) <= '1';
		WHEN "10111" => dec_out(23) <= '1';
		WHEN "11000" => dec_out(24) <= '1';
		WHEN "11001" => dec_out(25) <= '1';
		WHEN "11010" => dec_out(26) <= '1';
		WHEN "11011" => dec_out(27) <= '1';
		WHEN "11100" => dec_out(28) <= '1';
		WHEN "11101" => dec_out(29) <= '1';
		WHEN "11110" => dec_out(30) <= '1';
		WHEN "11111" => dec_out(31) <= '1';
		WHEN OTHERS => dec_out <= (OTHERS => '0');
	END CASE;
END PROCESS;
END behv;
----------------------------------------------------------------------------------