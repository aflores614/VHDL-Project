----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/01/2023 09:08:08 PM
-- Design Name: 
-- Module Name: FSM_Contoller - Behavioral
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

entity FSM_Contoller is
      Port (clk: in std_logic;
            reset: in std_logic;
            button: in std_logic;
            Pass: out std_logic);
end FSM_Contoller;

architecture Behavioral of FSM_Contoller is

begin

process(clk)
begin
    if(rising_edge (clk)) then
        

end Behavioral;
