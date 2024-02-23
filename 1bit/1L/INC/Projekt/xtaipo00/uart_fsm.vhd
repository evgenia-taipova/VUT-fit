-- uart_fsm.vhd: UART controller - finite state machine
-- Author(s): Taipova Evgeniya (xtaipo00)
--
library ieee;
use ieee.std_logic_1164.all;

-------------------------------------------------
entity UART_FSM is
port(
   CLK         :  in std_logic;
   RST         :  in std_logic;
   DIN         : 	in std_logic;
   CLK_CNT     :  in std_logic_vector(4 downto 0);
   BIT_CNT     :  in std_logic_vector(3 downto 0);
   EN_RD       :  out std_logic;
   EN_CNT      :  out std_logic;
   DOUT_VLD    :  out std_logic
   );
end entity UART_FSM;

-------------------------------------------------
architecture behavioral of UART_FSM is
type SM_FSM is (state_idle, state_start, state_r_data, state_stop, state_v_data);
signal SM : SM_FSM := state_idle; 

begin
EN_RD <= '1' when SM = state_r_data else '0';
EN_CNT <= '1' when SM = state_start or SM = state_r_data or SM = state_v_data or SM = state_stop else '0';
DOUT_VLD <= '1' when SM = state_v_data else '0';
         
process (CLK) begin
   if RISING_EDGE(CLK) then
      if RST = '0' then
     
         case SM is
            when state_idle =>
               if DIN = '0' then 
                  SM <= state_start;
               end if;

            when state_start =>
               if CLK_CNT = "00111" then
                  if DIN = '0' then
                  SM <= state_r_data; 
                  end if;
               end if;

            when state_r_data =>
               if BIT_CNT ="0111" and CLK_CNT = "01111" then
                  SM <= state_stop;
               end if;

            when state_stop =>
               if CLK_CNT = "11000" then
                  if DIN = '1' then
                     SM <= state_v_data;
                  end if;
               end if;
                
            when state_v_data =>           
               SM <= state_idle;
           
            when others => 
               SM <= state_idle;

         end case;

      else
         SM <= state_idle;
      
      end if;
   end if;
end process;
        
end behavioral;
