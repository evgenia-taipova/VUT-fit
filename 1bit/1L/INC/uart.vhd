-- uart.vhd: UART controller - receiving part
-- Author(s):  Taipova Evgeniya (xtaipo00)
--
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

-------------------------------------------------
entity UART_RX is
port(	
    CLK		 : 	    in std_logic;
	RST		 : 	    in std_logic;
	DIN		 : 	    in std_logic;
	DOUT	 : 	    out std_logic_vector(7 downto 0);
	DOUT_VLD : 		out std_logic
);
end UART_RX;  

-------------------------------------------------
architecture behavioral of UART_RX is
signal en_rd 	 :  std_logic;
signal en_cnt	 :  std_logic;
signal d_vld 	 :  std_logic;
signal clk_cnt 	 :  std_logic_vector(4 downto 0);
signal bit_cnt 	 :  std_logic_vector(3 downto 0) := "0000";
signal s_register  :  std_logic_vector(7 downto 0) := X"00";

begin
	DOUT_VLD <= d_vld;
 
	FSM: entity work.UART_FSM(behavioral)
    port map (
        CLK 	    => CLK,
        RST 	    => RST,
        DIN 	    => DIN,
        CLK_CNT     => clk_cnt,
        BIT_CNT    	=> bit_cnt,
		EN_RD       => en_rd,
		EN_CNT 		=> en_cnt,
		DOUT_VLD 	=> d_vld
	);

 process(CLK) begin 
	if 	RISING_EDGE(CLK) then

		if en_cnt = '0' then
			clk_cnt <= "00000";
		 else
			clk_cnt <= clk_cnt+"1";
		end if;

		if en_rd = '1' then  
			if clk_cnt >="01111" then
				clk_cnt <= "00000";
				s_register(6) <= s_register(7);
				s_register(5) <= s_register(6);
				s_register(4) <= s_register(5);
				s_register(3) <= s_register(4);
				s_register(2) <= s_register(3);
				s_register(1) <= s_register(2);
				s_register(0) <= s_register(1);
				s_register(7) <= DIN;
				bit_cnt <= bit_cnt+"1";
			end if;
		else 
			bit_cnt <= "0000";
		end if;

	end if;
 end process;

DOUT <= s_register;

end behavioral;
