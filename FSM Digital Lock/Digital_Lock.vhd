----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/02/2023 06:59:09 PM
-- Design Name: 
-- Module Name: Digital_Lock - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Digital_Lock is

  Port (clk : in std_logic;
        reset: in std_logic;
        button: in std_logic_vector( 3 downto 0);
        lock: out std_logic;
        State_LED: out std_logic_vector( 3 downto 0);
        Correct_key: out std_logic
        );
end Digital_Lock;

architecture Behavioral of Digital_Lock is

type state_key is( START, ENTER, KEY_1, KEY_2, KEY_3, KEY_4, Wrong_key, FINISH, AD_key_1,AD_Key_2,lock_State);
signal state : state_key; 
constant CLK_period : integer := 8;
constant one_sec_delay: integer := 1_000_000_000/CLK_period; --1 sec
signal counter : integer := 0;
signal wrong_key_count: integer := 0;
begin

process(clk)
begin
    if(rising_edge(clk)) then 
        if(reset = '1') then
            state <= start;
         else          
            case state is 
                when start => --reset_state
                    counter <= 0;
                    lock <= '0';
                    correct_key <= '0';
                    wrong_key_count <= 0;
                    state <= ENTER;
                    State_LED<="0101";
                when ENTER  =>  --delay state
                    State_LED<="0000";
                    if(counter < one_sec_delay/16) then
                        counter <= counter + 1;
                        state <= ENTER;
                    else
                        counter <= 0;
                        state <= KEY_1;
                    end if;
                  when KEY_1 => 
                        State_LED<="1000";
                        case(button)  is 
                           when "1000" => --corect key is press
                                state <= Key_2;                                
                           when "0100" => --wrong key
                                wrong_key_count  <= wrong_key_count +1; -- add 1 to the wrong key count
                                state <= Wrong_key ;
                           when "0010" =>
                                wrong_key_count  <= wrong_key_count +1;
                                state <= Wrong_key;
                           when "0001" =>
                                wrong_key_count  <= wrong_key_count +1;
                                state <= Wrong_key;
                          when others =>  -- it not thing is press or two or button was press
                                state <= Key_1;
                          end case;
                  
                         
                  when KEY_2  =>     
                        State_LED <="0100";   --indicate which state is on
                        if(counter < one_sec_delay/4) then --a delay insert so button input is reset
                            counter <= counter + 1;
                            state <= Key_2;
                        else
                        counter <= 0;
                        case(button)  is       
                        when "0100" =>
                                state <= KEY_3;                                
                           when "1000" =>
                                wrong_key_count  <= wrong_key_count +1;
                                state <= Wrong_key ;
                           when "0010" =>
                                wrong_key_count  <= wrong_key_count +1;
                                state <= Wrong_key;
                           when "0001" =>
                                wrong_key_count  <= wrong_key_count +1;
                                state <= Wrong_key;
                          when others => 
                                state <= Key_2;
                          end case;
                       end if;
                      
                  when KEY_3  =>
                    State_LED<="0010";
                    if(counter < one_sec_delay/4) then
                            counter <= counter + 1;
                            state <= KEY_3;
                    else
                        counter <= 0;
                    case(button)  is
                         when "0010" =>                               
                            state <= KEY_4;
                           when "1000" =>
                                wrong_key_count  <= wrong_key_count +1;
                                state <= Wrong_key ;
                           when "0100" =>
                                wrong_key_count  <= wrong_key_count +1;
                                state <= Wrong_key;
                           when "0001" =>
                                wrong_key_count  <= wrong_key_count +1;
                                state <= Wrong_key;
                          when others => 
                                state <= Key_3;
                          end case;   
                    end if;
                  when KEY_4  =>
                    State_LED<="0001";
                    if(counter < one_sec_delay/4) then
                            counter <= counter + 1;
                            state <= KEY_4;
                    else
                        counter <= 0;
                         case(button)  is
                         when "0001" =>
                                state <= FINISH;
                           when "1000" =>
                                wrong_key_count  <= wrong_key_count +1;
                                state <= Wrong_key ;
                           when "0100" =>
                                wrong_key_count  <= wrong_key_count +1;
                                state <= Wrong_key;
                           when "0010" =>
                                wrong_key_count  <= wrong_key_count +1;
                                state <= Wrong_key;
                          when others => 
                                state <= Key_4;
                          end case;   
                     end if;
                 when Wrong_key =>
                    if( wrong_key_count < 3) then
                        state<= ENTER;
                    else    
                        state <= AD_key_1;
                    end if;
                            
                 when FINISH => 
                    State_LED<="0000"; --all the led are off
                    Correct_key <= '1'; --enable the ssd
                    lock <= '0';
                    state <= FINISH;--remain this state until reset goes high 
                 when AD_key_1 =>
                 State_LED<="1111";--all leds are on to indicate that is in lock mode
                 if(counter < one_sec_delay/8) then --delay
                            counter <= counter + 1;
                            state <= AD_key_1;
                  else
                    
                    if( button ="1000") then --once the correct key press move to the next state
                        state <= AD_Key_2;
                    else
                        state <= AD_Key_1;
                    end if;
                end if;
                   when AD_key_2 =>
                   State_LED<="1111";
                   if(counter < one_sec_delay/8) then
                            counter <= counter + 1;
                            state <= AD_key_2;
                  else
                    if( button ="0001") then
                        state <= START; -- once the correct passcode is enter it will go to start state where it will be reset
                    else
                        state <= AD_Key_2; 
                    end if;  
                end if;                        
               when others => 
                    state <= START;
            end case;
       end if;
    end if;
 end process;
                                                                

end Behavioral;
