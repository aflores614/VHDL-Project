----------------------------------------------------------------------------------
-- Company: CSUN
-- Engineer:ANDRES FLORES
-- 
-- Create Date: 11/25/2023 09:05:16 PM
-- Design Name: 
-- Module Name: seq_detection - Behavioral
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

entity seq_detection is
  generic(
        overlapping_enble : std_logic := '1'
          ); 
  Port ( 
        CLK: in std_logic;
        RESET: in std_logic;       
        DATA_IN: in std_logic;
        DECTECTOR: out std_logic
  );
end seq_detection;

architecture Behavioral of seq_detection is

type seq is (intial, num1, num2, num3);
signal state: seq;

begin

process(clk) 
begin
    if(rising_edge(CLK)) then
        if(reset='1') then
            DECTECTOR <= '0';
            state <= intial;
        else
          if(overlapping_enble = '0') then
            case(state) is
                when (intial) => 
                   DECTECTOR <= '0';
                   if(data_in = '1') then
                    state <= num1;
                   else
                    state<= intial;
                   end if;
                when num1 => 
                    DECTECTOR <= '0';
                    if(data_in = '1') then
                        state <= num2;
                    else
                        state <= intial;
                    end if;
                when num2 =>
                     DECTECTOR <= '0';
                     if(data_in = '1') then
                        state <= num3;
                    else
                        state <= intial;
                    end if;
                when num3 => 
                    DECTECTOR <= '1';
                    if(data_in = '1') then
                        state <= num1;
                    else
                        state <= intial;
                    end if;
                when others => 
                    state <= intial;
          end case;
       else 
            case(state) is
                when (intial) => 
                   DECTECTOR <= '0';
                   if(data_in = '1') then
                    state <= num1;
                   else
                    state<= intial;
                   end if;
                when num1 => 
                    DECTECTOR <= '0';
                    if(data_in = '1') then
                        state <= num2;
                    else
                        state <= intial;
                    end if;
                when num2 =>
                     DECTECTOR <= '0';
                     if(data_in = '1') then
                        state <= num3;
                    else
                        state <= intial;
                    end if;
                when num3 => 
                    DECTECTOR <= '1';
                    if(data_in = '1') then
                        state <= num3;
                    else
                        state <= intial;
                    end if;
                when others => 
                    state <= intial;
          end case;
          end if;         
        end if;
    end if;
end process;


end Behavioral;
