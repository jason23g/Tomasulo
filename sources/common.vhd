--------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
--------------------------------------------------------------------------------
PACKAGE common IS
	CONSTANT CLK_period	: TIME := 100 ns;
	CONSTANT cc			: TIME := 100 ns;
	--CONSTANT OP_WIDTH	: INTEGER := 3;
	CONSTANT TAG_WIDTH	: INTEGER := 3;
	CONSTANT HWORD		: INTEGER := 16;
	--CONSTANT DWIDTH		: NATURAL := 63;
	--CONSTANT DWORD		: INTEGER := 64;
	--CONSTANT WORD		: INTEGER := 32;
	--CONSTANT HWORD		: INTEGER := 16;
	CONSTANT REG_NUM	: INTEGER := 32;
	--CONSTANT FUs		: INTEGER := 2;
	TYPE regBus IS ARRAY (0 TO REG_NUM-1) OF STD_LOGIC_VECTOR(HWORD-1 DOWNTO 0);
	TYPE statBus IS ARRAY (0 TO REG_NUM-1) OF STD_LOGIC_VECTOR(TAG_WIDTH-1 DOWNTO 0);
END common;
--------------------------------------------------------------------------------
PACKAGE BODY common IS

END PACKAGE BODY;