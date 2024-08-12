----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/28/2023 12:31:03 PM
-- Design Name: 
-- Module Name: Keypad_decode - Behavioral
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
USE ieee.numeric_std.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Keypad_decode is
    Port ( CLK : in STD_LOGIC;
           KEY : in STD_LOGIC_VECTOR (15 downto 0);
           key_char : out STD_LOGIC_VECTOR (7 downto 0));
end Keypad_decode;

architecture Behavioral of Keypad_decode is


begin
process(clk)
begin
    if(rising_edge(clk)) then
        case(KEY) is  --ASCII value
            when  x"0001" =>
                   key_char <= std_logic_vector(to_unsigned( 70 ,8)); --F
            when  x"0002" =>
                   key_char <=  std_logic_vector(to_unsigned( 69 , 8)); --E
            when  x"0004" =>
                   key_char <= std_logic_vector(to_unsigned( 68 , 8)); --D
            when  x"0008" =>
                   key_char <=  std_logic_vector(to_unsigned( 67 , 8)); --C
                   
                   
            when  x"0010" =>
                   key_char <= std_logic_vector(to_unsigned(  66 , 8)); --B
            when  x"0020" =>
                   key_char <=  std_logic_vector(to_unsigned(  65 , 8)); --A
             when  x"0040" =>
                    key_char <=  std_logic_vector(to_unsigned(  57 , 8));  --9
            when  x"0080" =>
                   key_char <= std_logic_vector(to_unsigned(  56 , 8)); -- 8    
                   
                                  
            when  x"0100" => 
                    key_char <= std_logic_vector(to_unsigned(  55 , 8)); --7             
                        
            when  x"0200" =>
                   key_char <=  std_logic_vector(to_unsigned(  54 , 8));  --6
            when  x"0400" =>
                   key_char <=  std_logic_vector(to_unsigned(  53 , 8)); --5
            when  x"0800" =>
                   key_char <=  std_logic_vector(to_unsigned(  52 , 8));  --4
                   
                   
            when  x"1000" =>
                   key_char <=  std_logic_vector(to_unsigned(  51  , 8));  --3
            when  x"2000" =>
                   key_char <=  std_logic_vector(to_unsigned(  50 , 8)); --2
            when  x"4000" =>
                   key_char <=  std_logic_vector(to_unsigned(  49 , 8));  --1
            when  x"8000" =>
                   key_char <=  std_logic_vector(to_unsigned(  48 , 8));  --0
                   
                   
            when others => 
                key_char <= std_logic_vector(to_unsigned(  0, 8));  --null
           end case;
     end if;
 end process;
             
end Behavioral;
