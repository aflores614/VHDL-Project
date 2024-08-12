library ieee;
use ieee.std_logic_1164.all;

use ieee.std_logic_unsigned.all;
entity pwm is

  port (
    clk : in std_logic;
    reset : in std_logic;     
    duty_cycle : in std_logic_vector(3  downto 0);
    pwm_out : out std_logic
  );
end pwm;

architecture behavior of pwm is
 
--signal counter : std_logic_vector( 2 downto 0) := (others => '0'); 
signal counter : integer:=0;
signal PWM_counter : std_logic_vector( 2 downto 0) := (others => '0'); 
signal speed: integer:=0; 
begin 
process(CLK)
begin
     if(rising_edge (CLK)) then
        if( reset = '1') then
            counter <= 0;
            pwm_out <= '0';
        else    
        if(duty_cycle(3) = '1') then
            case(duty_cycle(2 downto 0)) is 
          when "000" => 
                speed <= 0;  
            when "001" => 
                speed <= 500000; 
            when "010" => 
                speed <= 1000000; 
            when "011" => 
                speed <= 1500000;  
            when "100" => 
                speed <= 2000000;  
            when "101" => 
                speed <= 3000000; 
            when "110" => 
                speed <= 3500000; 
            when "111" => 
                speed <= 5000000; 
            when others => 
                speed <= 0;  
            end case; 
         else
             case(duty_cycle(2 downto 0)) is 
            when "000" => 
                speed <= 5000000;  
            when "001" => 
                speed <= 3500000; 
            when "010" => 
                speed <= 3000000; 
            when "011" => 
                speed <= 2500000;  
            when "100" => 
                speed <= 2000000;  
            when "101" => 
                speed <= 1500000; 
            when "110" => 
                speed <= 1000000; 
            when "111" => 
                speed <= 500000; 
            when others => 
                speed <= 0;  
            end case; 
         end if;
             
                
                      
            if(counter < 5000000) then                             
                if (counter < speed ) then
                    pwm_out <= '1';  
                else 
                    pwm_out <= '0';                   
                end if;
                counter <= counter + 1;                    
             else 
                counter <= 0;
                
             end if;
              
                
        end if;
    end if;
end process;     
                      
            

         

end architecture;
