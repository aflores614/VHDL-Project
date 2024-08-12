----------------------------------------------------------------------------------
-- Company: CSUN
-- Engineer: Andres Flores
-- 
-- Create Date: 10/22/2023 10:22:52 PM
-- Design Name: UART LAB 5 
-- Module Name: System_Controller - Behavioral
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity System_Controller is
     Port (Clk, RST: in  std_logic;      
           Locked, reset_out, clk_out: out std_logic            
            );
end System_Controller;

architecture Behavioral of System_Controller is
signal lock : std_logic:='0';
signal counter: std_logic_vector(5 downto 0):= (others=> '0');
signal enable_counter : std_logic:='0';
signal  disable_counter: std_logic:='0';
component clk_wiz_0 is
    port(
        clk_out1 : out std_logic;
        reset : in std_logic;       
        locked :out std_logic;
        clk_in1: in std_logic 
        );
end component;
begin
sys_con: clk_wiz_0 port map(
            clk_in1 => clk,
            reset => RST,
            locked => lock,
            clk_out1 => clk_out            
            );
process(clk)
begin 
 if(rising_edge(clk)) then
  if(RST ='1') then
      disable_counter <= '0';
      
  else
   if(enable_counter = '1') then   
       
        if (counter < "100000" and disable_counter ='0') then 
             reset_out<='1';
             counter <= counter + 1;
               
        else 
            counter <= (others => '0');      
            reset_out <= '0';
            disable_counter <= '1'; 
        end if;
     else 
            counter <= counter;
            reset_out<='1';
    end if;
 end if;
 end if;
end process; 

process(lock, RST)
begin
     if(RST ='1') then
          enable_counter <= '0'; 
      
    elsif (lock = '1') then
       enable_counter <= '1'; 
     end if;  
     
    
    
end process;        
            
 locked <= lock;

end Behavioral;
