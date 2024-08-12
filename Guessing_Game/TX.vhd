----------------------------------------------------------------------------------
-- Company: CSUN
-- Engineer: ANDRES FLORES
-- 
-- Create Date: 10/27/2023 07:46:21 PM
-- Design Name: 
-- Module Name: TX - Behavioral
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

entity TX is
 generic ( 
           baud_per_clk: integer := 1085 --125MHZ/115200
            );
  Port (CLK, rst: in std_logic;
        TX_start : in std_logic;
        TX_Data: in std_logic_vector( 7 downto 0);
        TX_serial: out std_logic;
        TX_Done: out std_logic
        );
end TX;

architecture Behavioral of TX is

type txstate is( tx_idle, tx_start_bit, tx_data_bit, tx_stop_bit);
signal tx_state: txstate;

signal tx_bit_index: integer := 0;
signal data_counter, bud_counter: integer:=0;
signal tx_data_reg: std_logic_vector(7 downto 0);
signal tx_done_reg: std_logic;

begin

process(clk) 
begin
    if( rising_edge(clk)) then
        case tx_state is 
            when tx_idle =>  --instial state everthing is reset
                data_counter <= 0;
                tx_bit_index <= 0;
                TX_Done <= '0';
                TX_serial <= '1';
                
                if(TX_start ='1') then -- once the data is ready the tx will be active
                    tx_data_reg <= TX_Data;
                    tx_state <= tx_start_bit;
                else 
                    tx_state <= tx_idle; --else back to idle state
                end if;
            when tx_start_bit => 
                TX_serial <= '0'; -- will send bit 0 to let the rx from the PC to let them know the data will be send
                if(bud_counter < baud_per_clk) then -- wait for one baud rate cycle
                    bud_counter <= bud_counter + 1;
                    tx_state <= tx_start_bit;
                else
                    bud_counter <= 0;
                    tx_state <= tx_data_bit;
                end if;
           when tx_data_bit => 
                tx_serial <= tx_data_reg( tx_bit_index); 
                --once in the data state will each bit in serial one bit per baud rate cycle  
                if(bud_counter < baud_per_clk) then
                    bud_counter <= bud_counter + 1;
                    tx_state <= tx_data_bit;
                else
                    bud_counter <= 0;
                    if( tx_bit_index < 7) then 
                        tx_bit_index <= tx_bit_index + 1;
                        tx_state <= tx_data_bit;
                    else    
                        tx_bit_index <= 0; 
                        tx_state <= tx_stop_bit;
                    end if;
                end if;
           when tx_stop_bit =>
                tx_serial <= '1'; -- once alll the data bits are send the stop bit will be send to let the RX thats it
                TX_Done <= '1';
                if(bud_counter < baud_per_clk) then --wait one baud rate cycle and go back to idle state
                    bud_counter <= bud_counter + 1;
                    tx_state <= tx_stop_bit;
                    
                else
                    bud_counter <= 0;
                    tx_done_reg <= '1';
                    tx_state <= tx_idle;                    
                end if;
           when others =>
                tx_state <= tx_idle;
     end case;
   end if;
end process;


               
               
                
        

end Behavioral;
