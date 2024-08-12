----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/01/2023 08:08:09 PM
-- Design Name: 
-- Module Name: Debouncer - Behavioral
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

entity Debouncer is
  generic (
    clk_freq    : integer := 125000000;  --system clock frequency in Hz
    stable_time : integer := 10); 
  Port (Clk: in std_logic;
        Reset: in std_logic;
        Button: in std_logic;
        debouncer_button: out std_logic );
end Debouncer;
architecture Behavioral of Debouncer is

signal reg_1, reg_2, reg_3, xor_reg: std_logic:= '0';    
signal counter: integer:= 0;
begin

process(clk)
begin   
    if(rising_edge(clk)) then
        if( reset = '1') then
            reg_1 <= '0';
            reg_2 <= '0';
            debouncer_button <= '0';
        else
            reg_1 <= button;
            reg_2 <= reg_1;          
            xor_reg <= reg_1 xor reg_2;
            if(xor_reg ='1') then
                counter <= 0;
            else
                if(counter < clk_freq*stable_time/1000) then
                    counter <= counter + 1;
                else
                    debouncer_button <= reg_2;
                end if;
            end if;
         end if;   
     end if;     
end process;
end Behavioral;
