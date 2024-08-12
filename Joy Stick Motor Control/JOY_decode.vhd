----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/13/2023 07:48:19 PM
-- Design Name: 
-- Module Name: JOY_decode - Behavioral
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

entity JOY_decode is
  Port (CLK: in std_logic;
        RESET : in std_logic; 
        x_position      : in    STD_LOGIC_VECTOR(3 DOWNTO 0);  --joystick x-axis position
        y_position      : in    STD_LOGIC_VECTOR(3 DOWNTO 0); 
        LED             : out std_logic_vector( 3 downto 0);
        Motor_Enable    : out std_logic;
        Motor_code      : out std_logic_vector ( 2 downto 0);
       
        trigger_button: in std_logic
   );
end JOY_decode;

architecture Behavioral of JOY_decode is

constant center_postion: std_logic_vector(3 downto 0):="1000";
constant center: std_logic_vector ( 3 downto 0) := "1000";

begin

process(clk) 
begin
    if(rising_edge(clk)) then   
        if (RESET = '1' or trigger_button = '1') then
            LED <= (others => '0');
            Motor_Enable <= '0';
        else
               
            if( x_position = center_postion and y_position = center_postion) then
                led <= "0000";
                Motor_Enable <= '0';
            elsif ( x_position < center_postion) then --left 
                    Motor_Enable <= '1';
                    if( y_position < center_postion) then --up 
                        LED <= "1100";
                        Motor_code <= "101";  -- up/left
                    elsif( y_position > center_postion ) then --down 
                        LED <="1010";
                        Motor_code <= "111";  -- down/left
                    else 
                        LED <= "1000";
                        Motor_code <= "011"; --left
                    end if;
            elsif ( x_position > center_postion) then --right 
                    Motor_Enable <= '1';
                    if( y_position < center_postion) then --up 
                        LED <= "0101";
                        Motor_code <= "100"; --up/right
                    elsif( y_position > center_postion ) then --down 
                        LED <="0011";
                        Motor_code <= "110"; --down/right
                    else 
                        LED <= "0001";
                        Motor_code <= "010";
                    end if;
           elsif ( x_position = center_postion) then --x does't move
                    Motor_Enable <= '1';
                    if( y_position < center_postion) then --up 
                        LED <= "0100";
                        Motor_code <= "000";
                    elsif( y_position > center_postion ) then --down 
                        LED <="0010";
                        Motor_code <= "001";
                    else 
                        LED <= "0000";
                        Motor_Enable <= '0';
                    end if;
           else
                    Motor_Enable <= '0';
                    LED <= "0000";
           end if;
                      
                    
            
    end if;
   end if;
end process;



          

end Behavioral;
