----------------------------------------------------------------------------------
-- Company: CSUN
-- Engineer: Andres Flores
-- 
-- Create Date: 11/11/2023 01:43:16 PM
-- Design Name: Guessing Game
-- Module Name: Guess_game - Behavioral
-- Project Name: LAB 8
-- Target Devices:ZYBO 10 

-- Description: A game where user enter a number and the board will let them know if 
--              they are close to the target number by display a red/blue/green light. 
--              Red light (HOT) gettting closer. Blue(COLD) light getting far and green(CORRECT) 
--              when the guess is correct.
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY seven_segments IS

	PORT (
		clk            : IN std_logic;
		reset          : IN std_logic;
		stop           : IN std_logic;
		seven_segments : OUT std_logic_vector(7 DOWNTO 0);
		seg0           : OUT std_logic_vector(7 DOWNTO 0);
		seg1           : OUT std_logic_vector(7 DOWNTO 0);
		button_press   : IN std_logic;
		data           : IN std_logic_vector(7 DOWNTO 0);
		target_number  : OUT std_logic_vector(7 DOWNTO 0);
		GAME_ENABLE    : OUT std_logic
	);

END ENTITY seven_segments;
ARCHITECTURE rtl OF seven_segments IS
	COMPONENT timer IS
		GENERIC (TERMINAL_COUNT : INTEGER := 1000);
		PORT (
			clk   : IN std_logic;
			reset : IN std_logic;
			timer : OUT std_logic
		);
	END COMPONENT;

	SIGNAL timer_expired_int : std_logic;
	SIGNAL segment_select    : std_logic;
	SIGNAL segment0          : std_logic_vector(7 DOWNTO 0);
	SIGNAL segment1          : std_logic_vector(7 DOWNTO 0);
	SIGNAL segment1_reg      : std_logic_vector(7 DOWNTO 0);
	SIGNAL segment0_map      : std_logic_vector(6 DOWNTO 0);
	SIGNAL segment1_map      : std_logic_vector(6 DOWNTO 0);
	SIGNAL timer_one_second  : std_logic;
	SIGNAL increment_digit   : std_logic;
	SIGNAL increment_ack     : std_logic;
	SIGNAL timer_expired     : std_logic;
	SIGNAL timer_delay       : INTEGER := 0;
	SIGNAL target            : INTEGER := 49;
	SIGNAL one_sec           : INTEGER := 1_000_000_000/8; 
	TYPE state_type IS(idle, target_num, input_1, input_2, button_press_state);
	SIGNAL state : state_type;
 
BEGIN
	------------------------------------------------------------------------------
	-- This timer is used to manage switching which seven segment display to drive
	------------------------------------------------------------------------------ 
	update_timer : timer
		GENERIC MAP(TERMINAL_COUNT => 1_250_000)
	--generic map (TERMINAL_COUNT => 1_00)
	PORT MAP(
		clk   => clk, 
		reset => reset, 
		timer => timer_expired_int
	);

		------------------------------------------------------------------------------
		-- This timer is used to manage incrementing the seven segment display
		------------------------------------------------------------------------------ 
		one_second_timer : timer
			GENERIC MAP(TERMINAL_COUNT => 125_000_000)
	--generic map (TERMINAL_COUNT => 10_000)
	PORT MAP(
		clk   => clk, 
		reset => reset, 
		timer => timer_one_second
	);

		------------------------------------------------------------------------------
		-- This process manages the counting for the seven segment displays
		------------------------------------------------------------------------------ 
PROCESS (clk)
		
BEGIN
	IF rising_edge(clk) THEN
		IF (reset = '1') THEN			
			GAME_ENABLE   <= '0';
			target_number <= (OTHERS => '1');
			segment0      <= (OTHERS => '0');
			segment1      <= (OTHERS => '0'); 
			state         <= idle;
		ELSE
 
			CASE(state) IS   --reset state
				WHEN idle => 
					segment0 <= (OTHERS => '0');
					segment1 <= (OTHERS => '0'); 
					state    <= target_num;
 
				WHEN target_num =>  -- Create a roll over counter that counts from 1 to F
 
					IF (stop = '0') THEN 
						GAME_ENABLE <= '0';
						IF (target < 57) THEN --ASCII Format 
							target <= target + 1;
							state  <= target_num;
						ELSE
							IF (target = 57) THEN
								target <= 65;
								state  <= target_num; 
							ELSE
								IF (target < 70) THEN
									target <= target + 1;
									state  <= target_num; 
								ELSE
									target <= 49;
									state  <= target_num; 
								END IF;
							END IF;
							state <= target_num; 
						END IF;
            --once user press the button a target number gets selected
            -- LED[0] will turn on to let the user know the number is selectd and ready to enter input
					ELSE 
						GAME_ENABLE   <= '1';
						target_number <= std_logic_vector(to_unsigned(target, 8));
						state         <= button_press_state;
					END IF;
 
				WHEN button_press_state =>  --Will stay in this state until receive a input from the keypad
					IF (button_press = '1') THEN
						IF (timer_delay < 22) THEN --an delay of 22 clock cycle so it could doesn't ready muiltiple input of same key press
							timer_delay <= timer_delay + 1;
							state       <= button_press_state;
						ELSE
							timer_delay <= 0;
							state       <= input_1;
						END IF;
					ELSE
						segment0 <= segment0;
						segment1 <= segment1;
						seg0     <= segment0;
						seg1     <= segment1; 
						state    <= button_press_state;
					END IF;
 
				WHEN input_1 =>  --pervios input will go a buffer segment1_reg and new input to seg0
					segment1_reg <= segment0;
					segment0     <= data;
					state        <= input_2;
 
				WHEN input_2 =>  
					segment1 <= segment1_reg;
					state    <= button_press_state;
 
				WHEN OTHERS => 
					state <= idle;
			END CASE;
 
		END IF;
	END IF;
 
END PROCESS;

------------------------------------------------------------------------------
-- This process manages switching which seven segment display to drive
------------------------------------------------------------------------------ 
PROCESS (clk) 
BEGIN
	IF (rising_edge(clk)) THEN
		IF (reset = '1') THEN
			segment_select <= '0';
		ELSE
			IF timer_expired_int = '1' THEN
				segment_select <= segment_select XOR '1';
			END IF;
		END IF;
	END IF;
END PROCESS;
 
------------------------------------------------------------------------------
-- The maps convert a decimal number to a seven segment display
------------------------------------------------------------------------------ 
-- GFEDCBA
segment0_map <= "0111111" WHEN segment0 = "00110000" ELSE --0
                "0000110" WHEN segment0 = "00110001" ELSE --1
                "1011011" WHEN segment0 = "00110010" ELSE --2
                "1001111" WHEN segment0 = "00110011" ELSE --3
                "1100110" WHEN segment0 = "00110100" ELSE --4
                "1101101" WHEN segment0 = "00110101" ELSE --5
                "1111101" WHEN segment0 = "00110110" ELSE --6
                "0000111" WHEN segment0 = "00110111" ELSE --7
                "1111111" WHEN segment0 = "00111000" ELSE --8
                "1100111" WHEN segment0 = "00111001" ELSE --9
                "1110111" WHEN segment0 = "01000001" ELSE --A
                "1111100" WHEN segment0 = "01000010" ELSE --B
                "0111001" WHEN segment0 = "01000011" ELSE --C
                "1011110" WHEN segment0 = "01000100" ELSE --D
                "1111001" WHEN segment0 = "01000101" ELSE --E
                "1110001" WHEN segment0 = "01000110" ELSE --F 
                "0111111";

-- GFEDCBA 
segment1_map <= "0111111" WHEN segment1 = "00110000" ELSE --0
                "0000110" WHEN segment1 = "00110001" ELSE --1
                "1011011" WHEN segment1 = "00110010" ELSE --2
                "1001111" WHEN segment1 = "00110011" ELSE --3
                "1100110" WHEN segment1 = "00110100" ELSE --4
                "1101101" WHEN segment1 = "00110101" ELSE --5
                "1111101" WHEN segment1 = "00110110" ELSE --6
                "0000111" WHEN segment1 = "00110111" ELSE --7
                "1111111" WHEN segment1 = "00111000" ELSE --8
                "1100111" WHEN segment1 = "00111001" ELSE --9
                "1110111" WHEN segment1 = "01000001" ELSE --A
                "1111100" WHEN segment1 = "01000010" ELSE --B
                "0111001" WHEN segment1 = "01000011" ELSE --C
                "1011110" WHEN segment1 = "01000100" ELSE --D
                "1111001" WHEN segment1 = "01000101" ELSE --E
                "1110001" WHEN segment1 = "01000110" ELSE --F 
                "0111111";
 

------------------------------------------------------------------------------
-- Drive outputs based on internal signals
------------------------------------------------------------------------------ 
seven_segments(6 DOWNTO 0) <= segment0_map WHEN segment_select = '0' ELSE
                              segment1_map; --"1001111";
seven_segments(7) <= segment_select;
timer_expired     <= timer_expired_int;

END rtl;