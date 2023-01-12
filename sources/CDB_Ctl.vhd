--------------------------------------------------------------------------------
-- Engineer:		JASON GEORGAKAS, PANOS VASILEIOU
-- 
-- Create Date:		12/04/2022 
-- Module Name:		CDB_Ctl - behv
-- Project Name:	Tomasulo_v1.00
-- Tool versions:	ISE Project Navigator (P.20131013)
-- Description:
-- 
-- The control of the Common Data Bus (CDB). It can arbitrate up to 3 devices.
-- It uses a simple Round-Robin (RR) scheme.
-- 
-- Revision:
-- Revision 0.01 - File Created
--------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
--------------------------------------------------------------------------------
ENTITY CDB_Ctl IS
PORT(
	CLK				: IN STD_LOGIC;
	RST				: IN STD_LOGIC;

	DEV_REQ			: IN STD_LOGIC_VECTOR(3 DOWNTO 0);

	DEV_GRANT		: OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
);
END CDB_Ctl;
--------------------------------------------------------------------------------
ARCHITECTURE behv OF CDB_Ctl IS

	-- MSB		: High priority request
	-- Bit 2	: Device 3, NC
	-- Bit 1	: Device 2, Logical
	-- Bit 0	: Device 1, Arithmetic
	--SIGNAL sig_DEV_GRANT	: STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL hist				: STD_LOGIC_VECTOR(1 DOWNTO 0);

BEGIN

	PROCESS(CLK, RST, hist, DEV_REQ)--, DEV_GRANT)
	BEGIN
		IF RST = '0' THEN
			DEV_GRANT	<= "0000";
			hist			<= "00";

		ELSIF rising_edge(CLK) THEN
			IF DEV_REQ(3) = '1' THEN
				DEV_GRANT	<= "1000";
				hist			<= "00";
			ELSIF DEV_REQ = "0001" THEN -- dev.1 ready
				DEV_GRANT	<= "0001";
				hist			<= "01";

			ELSIF DEV_REQ = "0010" THEN -- dev.2 ready
				DEV_GRANT	<= "0010";
				hist			<= "10";

			ELSIF DEV_REQ = "0100" THEN -- dev.3 ready
				DEV_GRANT	<= "0100";
				hist			<= "11";

			ELSIF DEV_REQ = "0011" THEN -- conflict between dev.1 and dev.2
				IF hist = "01" THEN
					DEV_GRANT	<= "0010";
					hist			<= "10";
				ELSE
					DEV_GRANT	<= "0001";
					hist			<= "01";
				END IF;

			ELSIF DEV_REQ = "0101" THEN -- conflict between dev.1 and dev.3
				IF hist = "01" THEN
					DEV_GRANT	<= "0100";
					hist			<= "11";
				ELSE 
					DEV_Grant	<= "0001";
					hist			<= "01";
				END IF;

			ELSIF DEV_REQ = "0110" THEN -- conflict between dev.2 and dev.3
				IF hist = "10" THEN
					DEV_GRANT	<= "0100";
					hist			<= "11";
				ELSE 
					DEV_GRANT	<= "0010";
					hist			<= "10";
				END IF;

			ELSIF DEV_REQ = "0111" THEN -- conflict between all devs
				IF hist = "01" THEN
					DEV_GRANT	<= "0010";
					hist			<= "10";
				ELSIF hist = "10" THEN
					DEV_GRANT	<= "0100";
					hist			<= "11";
				ELSE 
					DEV_GRANT	<= "0001";
					hist			<= "01";
				END IF;

			ELSE --IF DEV_REQ = "0000" THEN -- no dev ready
				DEV_GRANT	<= "0000";
				hist			<= "00";
			END IF;
		END IF;
	END PROCESS;

--DEV_GRANT <= DEV_GRANT;

END behv;
--------------------------------------------------------------------------------