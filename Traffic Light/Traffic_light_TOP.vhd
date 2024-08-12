----------------------------------------------------------------------------------
-- Company: CSUN
-- Engineer: Andres Flores
-- 
-- Create Date: 11/18/2023 02:01:55 PM
-- Design Name: Lab 9
-- Module Name: Traffic_light_TOP - Behavioral
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

entity Traffic_light_TOP is
  Port (CLK : in std_logic;
        reset: in std_logic;
        SA: in std_logic;
        SB: in std_logic;
        GA : out std_logic;
        YA : out std_logic;
        RA: out std_logic;
        GB : out std_logic;
        YB : out std_logic;
        RB: out std_logic;
        Xseven_segments : out std_logic_vector(7 downto 0)         
        );
end Traffic_light_TOP;



architecture Behavioral of Traffic_light_TOP is

signal Locked, reset_out, clk_out: std_logic;
signal button_stable_SA, button_stable_SB : std_logic;

component  Traffic_light_controller is
 Port (clk : in std_logic;
        reset: in std_logic;
        SA: in std_logic;
        SB: in std_logic;
        GA : out std_logic;
        YA : out std_logic;
        RA: out std_logic;
        GB : out std_logic;
        YB : out std_logic;
        RB: out std_logic;
        Xseven_segments : out std_logic_vector(7 downto 0)        
        );
 end component;

component System_Controller is
     Port (Clk, RST: in  std_logic;      
           Locked, reset_out, clk_out: out std_logic            
            );
end component;

component  Debouncer_Top is
Port ( clk: in std_logic; 
       Reset: in std_logic;
       SA, SB: in std_logic;
       button_stable_SA, button_stable_SB : out std_logic 
       );
end component;

begin

sys_controller: System_Controller port map( clk=> clk, RST => reset, Locked => LOCKED, reset_out => reset_out, clk_out => clk_out);
Debouncer:  Debouncer_Top port map ( clk=> clk_out, reset => reset_out, SA => SA, SB => SB, button_stable_SA => button_stable_SA, button_stable_SB => button_stable_SB);
controller: Traffic_light_controller port map ( CLK => clk_out, reset=>reset_out, SA => button_stable_SA, SB => button_stable_SB, GA => GA, YA => YA, RA=> RA, GB => GB, YB => YB, RB=> RB,Xseven_segments=>Xseven_segments );

end Behavioral;
