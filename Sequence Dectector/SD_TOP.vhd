----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/25/2023 08:58:52 PM
-- Design Name: 
-- Module Name: SD_TOP - Behavioral
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


entity SD_TOP is

  Port ( 
        CLK: in std_logic;
        RESET: in std_logic;
        DATA_IN: in std_logic;
        DECTECTOR: out std_logic
  );
end SD_TOP;

architecture Behavioral of SD_TOP is


component seq_detection is   
    generic(
          enable : std_logic := '1'
          ); 
  Port ( 
        CLK: in std_logic;
        RESET: in std_logic;
        overlapping_enble: in std_logic;
        DATA_IN: in std_logic;
        DECTECTOR: out std_logic
  );
 end component;


begin

over: entity work.seq_detection port map( clk => clk, RESET => RESET, overlapping_enble => enable, DATA_IN=> DATA_IN, DECTECTOR => DECTECTOR);



end Behavioral;
