LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY Traffic_light_controller IS
    generic(
               CONSTANT time_sec        : INTEGER := 1_000_000_000 
        );                 
	PORT (
		CLK             : IN std_logic;
		reset           : IN std_logic;
		SA              : IN std_logic;
		SB              : IN std_logic;
		GA              : OUT std_logic;
		YA              : OUT std_logic;
		RA              : OUT std_logic;
		GB              : OUT std_logic;
		YB              : OUT std_logic;
		RB              : OUT std_logic;
		Xseven_segments : OUT std_logic_vector(7 DOWNTO 0)
	);
END Traffic_light_controller;
ARCHITECTURE Behavioral OF Traffic_light_controller IS
	COMPONENT TIMER_DISPLAY IS
		PORT (
			clk            : IN std_logic;
			reset          : IN std_logic;
			segment1       : IN std_logic_vector(3 DOWNTO 0);
			segment0       : IN std_logic_vector(3 DOWNTO 0);
			seven_segments : OUT std_logic_vector(7 DOWNTO 0)
		);
	END COMPONENT;
	CONSTANT CLK_period : INTEGER := 8; --CLOCK Freq 125 MHZ
	CONSTANT sec        : INTEGER := time_sec / CLK_period; -- 1 secound
	SIGNAL counter      : INTEGER := 0;
	SIGNAL seg1, seg0   : std_logic_vector(3 DOWNTO 0) := (OTHERS => '0');
	TYPE light_state IS (idle, A_stret_G_intial, A_street_G, A_Street_Y, B_street_G, extent_B_Street_G, B_Street_Y);
	SIGNAL state : light_state;
BEGIN
	ssd : TIMER_DISPLAY
	PORT MAP(clk => clk, reset => reset, segment1 => seg1, segment0 => seg0, seven_segments => Xseven_segments);
	PROCESS (clk)
	BEGIN
		IF (rising_edge(clk)) THEN
			IF (reset = '1') THEN
				state <= idle;
			ELSE
				CASE(state) IS
					WHEN(idle) => --reset state
						GA      <= '0';
						RA      <= '0';
						YA      <= '0';
						GB      <= '0';
						RB      <= '0';
						YB      <= '0';
						counter <= 0;
						seg0    <= "0000";
						seg1    <= "0000";
						state   <= A_stret_G_intial;
					WHEN(A_stret_G_intial) => -- "A" street has a green light until a car approaches on "B". 
						GA <= '1';
						RA <= '0';
						YA <= '0';
						GB <= '0';
						RB <= '1';
						YB <= '0';
						IF (SB = '1') THEN
							state <= A_Street_Y;
						ELSE
							state <= A_stret_G_intial;
						END IF;
					WHEN(A_street_Y) => --transition of light A street is in yellow for 3 secounds
						GA <= '0';
						YA <= '1';
						RA <= '0';
						GB <= '0';
						YB <= '0';
						RB <= '1';
						IF (counter < 3 * sec) THEN
							counter <= counter + 1;
							State   <= A_street_Y;
						ELSE
							counter <= 0;
							State   <= B_street_G;
						END IF;
		          --B street is Green and at the end of 50 seconds, the lights change back unless there is a car on "B" street and
                  --none on "A", in which case the "B" cycle is extended for another 10 second 
					WHEN (B_street_G) =>

						GA <= '0';
						YA <= '0';
						RA <= '1';
						GB <= '1';
						YB <= '0';
						RB <= '0';
						IF (counter < sec) THEN
							counter <= counter + 1;
							state   <= B_street_G;
						ELSE
							counter <= 0;
							IF (seg0 < "1001") THEN
								seg0  <= seg0 + '1';
								state <= B_street_G;
							ELSE
								seg0 <= (OTHERS => '0');
								IF (seg1 < "0100") THEN
									seg1  <= seg1 + '1';
									state <= B_street_G;
								ELSE
									seg1 <= (OTHERS => '0');
									IF (SA = '0' AND SB = '1') THEN
										state <= extent_B_Street_G;
									ELSE
										State <= B_Street_Y;
									END IF;
								END IF;
							END IF;
						END IF;
					WHEN (extent_B_Street_G) => --Extended for another 10 secounds 
						GA <= '0';
						YA <= '0';
						RA <= '1';
						GB <= '1';
						YB <= '0';
						RB <= '0';
						IF (counter < sec) THEN
							counter <= counter + 1;
							state   <= extent_B_Street_G;
						ELSE
							counter <= 0;
							IF (seg0 < "1001") THEN
								seg0  <= seg0 + '1';
								state <= extent_B_Street_G;
							ELSE
								seg0  <= (OTHERS => '0');
								state <= B_Street_Y;
							END IF;
						END IF;
					WHEN(B_Street_Y) =>  --transition of light B street is in yellow for 3 secounds
						GA <= '0';
						YA <= '0';
						RA <= '1';
						GB <= '0';
						YB <= '1';
						RB <= '0';
						IF (counter < 3 * sec) THEN
							counter <= counter + 1;
							State   <= B_street_Y;
						ELSE
							counter <= 0;
							State   <= A_street_G;
						END IF;
				-- "A" is green, it remains green at least 60 seconds, and then the 
				-- lights change only when a car approaches on "B"
					WHEN(A_street_G) => 
						GA <= '1';
						YA <= '0';
						RA <= '0';
						GB <= '0';
						YB <= '0';
						RB <= '1';
						IF (counter < sec) THEN
							counter <= counter + 1;
							state   <= A_street_G;
						ELSE
							counter <= 0;
							IF (seg0 < "1001") THEN
								seg0  <= seg0 + '1';
								state <= A_street_G;
							ELSE
								seg0 <= (OTHERS => '0');
								IF (seg1 < "0101") THEN
									seg1  <= seg1 + '1';
									state <= A_street_G;
								ELSE
									seg1 <= (OTHERS => '0');
									IF (SB = '1') THEN
										state <= A_Street_Y;
									ELSE
										state <= A_stret_G_intial;
									END IF;
								END IF;
							END IF;
						END IF;
					WHEN OTHERS =>
						state <= idle;

				END CASE;
			END IF;
		END IF;
	END PROCESS;


END Behavioral;