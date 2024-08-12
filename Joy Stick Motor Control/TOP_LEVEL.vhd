----------------------------------------------------------------------------------
-- Company: CSUN
-- Engineer: ANDRES FLORES
-- 
-- Create Date: 11/13/2023 07:20:36 PM
-- Design Name: 
-- Module Name: TOP_LEVEL - Behavioral
-- Project Name: MOTOR Drive
-- Target Devices: ZYBO 7
-- Tool Versions: 
-- Description:Able to control to two DC motor with one joy stick 
-- The x-axis on the joy stick will contol one motor and the y-axis the other one 
--Using PWM to contol the speed of the motor
 
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

entity TOP_LEVEL is
  Port (CLK: in std_logic;
        reset: in std_logic;
        miso: in std_logic;
        mosi: out std_logic;
        sclk: buffer std_logic;
        cs_n: out std_logic ;
        Locked: out std_logic;             
        LED : out   std_logic_vector( 3 downto 0);
        EN1, EN2: out std_logic;
        DIR1, DIR2: out std_logic
        );  
end TOP_LEVEL;

architecture Behavioral of TOP_LEVEL is

signal rst, clk_out: std_logic:='0';
signal x_position, y_position: STD_LOGIC_VECTOR(3 DOWNTO 0):=(others => '0');
signal center_button,trigger_button: std_logic := '0';
signal  TX_Done: std_logic:='0';
signal motor_enable : std_logic :='0';
signal motor_code: std_logic_vector( 2 downto 0);
signal PWM_V, PWM_H: std_logic :='0';
component  pmod_joystick IS
 
  PORT(
    clk             : IN     STD_LOGIC;                     --system clock
    reset_n         : IN     STD_LOGIC;                     --active low reset
    miso            : IN     STD_LOGIC;                     --SPI master in, slave out
    mosi            : OUT    STD_LOGIC;                     --SPI master out, slave in
    sclk            : BUFFER STD_LOGIC;                     --SPI clock
    cs_n            : OUT    STD_LOGIC;                     --pmod chip select
    x_position      : OUT    STD_LOGIC_VECTOR(3 DOWNTO 0);  --joystick x-axis position
    y_position      : OUT    STD_LOGIC_VECTOR(3 DOWNTO 0);  --joystick y-axis position
    trigger_button  : OUT    STD_LOGIC;                     --trigger button status
    center_button   : OUT    STD_LOGIC);                    --center button status
end component;

component  System_Controller is
     
     Port (Clk, RST: in  std_logic;      
           Locked, reset_out, clk_out: out std_logic            
            );

end component;

component  JOY_decode is
  Port (CLK: in std_logic;
        RESET : in std_logic; 
        x_position      : in    STD_LOGIC_VECTOR(3 DOWNTO 0);  --joystick x-axis position
        y_position      : in    STD_LOGIC_VECTOR(3 DOWNTO 0); 
        LED             : out std_logic_vector( 3 downto 0);
        Motor_Enable    : out std_logic;
        Motor_code      : out std_logic_vector ( 2 downto 0);        
        trigger_button: in std_logic
   );
end component;

component  Motor_control is
      Port (clk: in std_logic;
            reset: in std_logic;
            enable: in std_logic;                       
            EN1_PWM: in std_logic;
            EN2_PWM: in std_logic;
            Motor_code: in std_logic_vector( 2 downto 0);
            EN1, EN2: out std_logic;
            DIR1, DIR2: out std_logic
             );
end component ;

component  pwm is
  
  port (
    clk : in std_logic;
    reset : in std_logic;     
    duty_cycle : in std_logic_vector(3  downto 0);
    pwm_out : out std_logic
  );
end component;



begin

Sys_con: System_Controller port map(clk => clk, RST => Reset, LOCKED => LOCKED, reset_out => rst, clk_out=> clk_out);
JOY: pmod_joystick port map (clk => clk_out, reset_n => not rst, miso => miso, mosi => mosi, sclk => sclk, cs_n => cs_n, x_position => x_position, y_position => y_position , trigger_button => trigger_button, center_button => center_button);
decode: JOY_decode port map (Clk => clk_out, reset => rst, x_position => x_position, y_position => y_position, LED => LED, trigger_button => trigger_button, motor_code => motor_code, motor_enable => motor_enable);
motor_con: Motor_control port map( clk => clk_out, reset => rst, enable => motor_enable, motor_code => motor_code,EN1_PWM =>PWM_V,EN2_PWM =>PWM_H,  EN1 => EN1, EN2=> EN2, DIR1 => DIR1, DIR2 => DIR2);
pwm_y: pwm port map (clk => clk_out, reset => rst, duty_cycle => y_position, pwm_out => PWM_V);
pwm_x: pwm port map (clk => clk_out, reset => rst, duty_cycle => x_position, pwm_out => PWM_H);
end Behavioral;
