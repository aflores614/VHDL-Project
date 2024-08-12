----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/17/2023 02:32:14 PM
-- Design Name: 
-- Module Name: Motor_control - Behavioral
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
use ieee.numeric_std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Motor_control is
      Port (clk: in std_logic;
            reset: in std_logic;
            enable: in std_logic;
            
            EN1_PWM: in std_logic;
            EN2_PWM: in std_logic;
            Motor_code: in std_logic_vector( 2 downto 0);
            EN1, EN2: out std_logic;
            DIR1, DIR2: out std_logic
             );
            
            
end Motor_control;

architecture Behavioral of Motor_control is

begin
    
 process(clk) 
 begin
    if(rising_edge(clk)) then
        if( reset = '1' ) then
            EN1 <= '0';
            EN2 <= '0';
        else
           if(enable = '1') then
            case (Motor_code) is
                when "000" => --up
                    EN1 <= EN1_PWM;
                    DIR1<= '0';
                    EN2 <= '0';
                    DIR2<= '0';
                when "001" => --down
                    EN1 <= EN1_PWM;
                    DIR1<= '1';
                    EN2 <= '0';
                    DIR2<= '0';
                when "010" => --right
                    EN1 <= '0';
                    DIR1<= '0';
                    EN2 <= EN2_PWM;
                    DIR2<= '0';
                when "011" => --left
                    EN1 <= '0';
                    DIR1<= '0';
                    EN2 <= EN2_PWM;
                    DIR2<= '1';
                when "100" => --up/right
                    EN1 <= EN1_PWM;
                    DIR1<= '0';
                    EN2 <= EN2_PWM;
                    DIR2<= '0';
                when "101" => --up/left
                    EN1 <= EN1_PWM;
                    DIR1<= '0';
                    EN2 <= EN2_PWM;
                    DIR2<= '1';
                when "110" => --down/right
                    EN1 <= EN1_PWM;
                    DIR1<= '1';
                    EN2 <= EN2_PWM;
                    DIR2<= '0';
                when "111" => --down/left
                    EN1 <= EN1_PWM;
                    DIR1<= '1';
                    EN2 <= EN2_PWM;
                    DIR2<= '1';
                    
                
               when others => 
                    EN1<='0';
                    EN2<='0';
          end case;
          else
            EN1 <= '0';
            EN2 <= '0';
         end if;
         
       end if;
   end if;
 end process;
                   
                    
                    
                    
            
    
    

end Behavioral;
