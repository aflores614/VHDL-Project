----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/01/2023 09:01:59 PM
-- Design Name: 
-- Module Name: Debouncer_Top - Behavioral
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

entity Debouncer_Top is
Port ( clk: in std_logic; 
       Reset: in std_logic;
       button: in std_logic_vector ( 3 downto 0);
       button_stable: out std_logic_vector( 3 downto 0) 
       );
end Debouncer_Top;

architecture Behavioral of Debouncer_Top is
component Debouncer is
    Port (Clk: in std_logic;                
      Reset: in std_logic;              
      Button: in std_logic;             
      debouncer_button: out std_logic );
end component;
begin
button_de_0: Debouncer port map(clk=> clk, reset => reset, button => button(0), debouncer_button => button_stable(0));
button_de_1: Debouncer port map(clk=> clk, reset => reset, button => button(1), debouncer_button => button_stable(1));
button_de_2: Debouncer port map(clk=> clk, reset => reset, button => button(2), debouncer_button => button_stable(2));
button_de_3: Debouncer port map(clk=> clk, reset => reset, button => button(3), debouncer_button => button_stable(3));

end Behavioral;
