----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/01/2023 08:01:03 PM
-- Design Name: 
-- Module Name: TOP_LEVEL_FSM - Behavioral
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



entity TOP_LEVEL_FSM is
    Port ( clk: in std_logic; 
           Reset: in std_logic;
           locked: out std_logic;
           button: in std_logic_vector ( 3 downto 0);
           LED: out std_logic_vector( 3 downto 0);
           XSEVEN_SEGMENTS: out std_logic_vector( 7 downto 0)
          );
end TOP_LEVEL_FSM;

architecture Behavioral of TOP_LEVEL_FSM is
signal button_stable: std_logic_vector( 3 downto 0) := (others => '0');
signal lock, correct_key: std_logic := '0';
signal reset_out, clk_out: std_logic:='0';
signal time_expired: std_logic:= '0';

component debouncer_Top is
    Port ( clk: in std_logic; 
       Reset: in std_logic;
       button: in std_logic_vector ( 3 downto 0);
       button_stable: out std_logic_vector( 3 downto 0) 
       );
end component;
component System_Controller is
    Port (Clk, RST: in  std_logic;      
           Locked, reset_out, clk_out: out std_logic            
            );
end component;
component seven_segments is     
    port (
    clk            : in  std_logic;
    enable         : in std_logic;
    reset          : in  std_logic;
    seven_segments : out std_logic_vector(7 downto 0);
    timer_expired  : out std_logic
    );
end component;

component Digital_lock is
      Port (clk : in std_logic;
        reset: in std_logic;
        button: in std_logic_vector( 3 downto 0);
        lock: out std_logic;
        state_led: out std_logic_vector(3 downto 0);
        Correct_key: out std_logic
        );
end component;

begin
sys_con: System_Controller port map(clk => clk, RST => reset, Locked => locked, reset_out => reset_out, clk_out => clk_out);
Debouncer: debouncer_Top port map (clk => clk_out, reset=> reset_out, button => button, button_stable =>button_stable); 
FSM: Digital_lock port map(clk => clk_out, reset=> reset_out, button=>button_stable, lock => lock, state_led => LED, correct_key => correct_key);
SSD: seven_segments port map(clk =>clk_out, enable => correct_key,  reset => reset_out, seven_segments =>XSEVEN_SEGMENTS, timer_expired => time_expired);



end Behavioral;
