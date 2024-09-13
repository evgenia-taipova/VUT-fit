-- cpu.vhd: Simple 8-bit CPU (BrainLove interpreter)
-- Copyright (C) 2021 Brno University of Technology,
--                    Faculty of Information Technology
-- Author(s): Taipova Evgeniya xtaipo00
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

-- ----------------------------------------------------------------------------
--                        Entity declaration
-- ----------------------------------------------------------------------------
entity cpu is
 port (
   CLK   : in std_logic;  -- hodinovy signal
   RESET : in std_logic;  -- asynchronni reset procesoru
   EN    : in std_logic;  -- povoleni cinnosti procesoru
 
   -- synchronni pamet ROM
   CODE_ADDR : out std_logic_vector(11 downto 0); -- adresa do pameti
   CODE_DATA : in std_logic_vector(7 downto 0);   -- CODE_DATA <- rom[CODE_ADDR] pokud CODE_EN='1'
   CODE_EN   : out std_logic;                     -- povoleni cinnosti
   
   -- synchronni pamet RAM
   DATA_ADDR  : out std_logic_vector(9 downto 0); -- adresa do pameti
   DATA_WDATA : out std_logic_vector(7 downto 0); -- ram[DATA_ADDR] <- DATA_WDATA pokud DATA_EN='1'
   DATA_RDATA : in std_logic_vector(7 downto 0);  -- DATA_RDATA <- ram[DATA_ADDR] pokud DATA_EN='1'
   DATA_WREN  : out std_logic;                    -- cteni z pameti (DATA_WREN='0') / zapis do pameti (DATA_WREN='1')
   DATA_EN    : out std_logic;                    -- povoleni cinnosti
   
   -- vstupni port
   IN_DATA   : in std_logic_vector(7 downto 0);   -- IN_DATA obsahuje stisknuty znak klavesnice pokud IN_VLD='1' a IN_REQ='1'
   IN_VLD    : in std_logic;                      -- data platna pokud IN_VLD='1'
   IN_REQ    : out std_logic;                     -- pozadavek na vstup dat z klavesnice
   
   -- vystupni port
   OUT_DATA : out  std_logic_vector(7 downto 0);  -- zapisovana data
   OUT_BUSY : in std_logic;                       -- pokud OUT_BUSY='1', LCD je zaneprazdnen, nelze zapisovat,  OUT_WREN musi byt '0'
   OUT_WREN : out std_logic                       -- LCD <- OUT_DATA pokud OUT_WE='1' a OUT_BUSY='0'
 );
end cpu;


-- ----------------------------------------------------------------------------
--                      Architecture declaration
-- ----------------------------------------------------------------------------
architecture behavioral of cpu is
  signal sel : std_logic_vector(1 downto 0);

  type fsm_state is (
    idle_state, fetch_state, decode_state, inc_ptr_state, dec_ptr_state, 
    inc_state_first, inc_state_second, inc_state_third, dec_state_first, dec_state_second,
    dec_state_third,put_state, get_state, while_state_first, while_state_second, 
    while_state_final, end_state_first, end_state_second, end_state_third, 
   end_state_final, break_state_second,break_state_first, null_state, others_state
  );
  signal present_state, next_state : fsm_state; 

  signal PC_out : std_logic_vector(11 downto 0); 
  signal PC_inc, PC_dec : std_logic; 

  signal PTR_out : std_logic_vector(9 downto 0); 
  signal PTR_inc, PTR_dec : std_logic; 

  signal CNT_out : std_logic_vector(11 downto 0); 
  signal CNT_inc, CNT_dec : std_logic; 
 
  

begin

-- PC slouží jako programový čítač (ukazatel do paměti programu)
PC: process (CLK, RESET, PC_inc, PC_dec)
begin
  if (RESET = '1') then
    PC_out <= (others => '0');
  elsif rising_edge(CLK) then
    if (PC_inc = '1') then
      PC_out <= PC_out + 1;
    elsif PC_dec = '1' then
      PC_out <= PC_out - 1;
    end if;
  end if;
end process;

-- PTR slouží jako ukazatel do paměti dat.
PTR: process (CLK, RESET, PTR_inc, PTR_dec)
begin
  if (RESET = '1') then
    PTR_out <= (others => '0');
  elsif rising_edge(CLK) then
    if (PTR_inc = '1') then
      PTR_out <= PTR_out + 1;
    elsif (PTR_dec = '1') then
      PTR_out <= PTR_out - 1;
    end if;
  end if;
end process;

-- Určení začátku a konce příkazu while, čítání počtu závorek (CNT).
CNT: process (CLK, RESET, CNT_inc, CNT_dec)
begin
  if (RESET = '1') then
    CNT_out <= (others => '0');
  elsif rising_edge(CLK) then
    if (CNT_inc = '1') then
      CNT_out <= CNT_out + 1;
    elsif (CNT_dec = '1') then
      CNT_out <= CNT_out - 1;
    end if;
  end if;
end process;

-- Multiplexor MX k volbě hodnoty zapsané do paměti dat.
MX: process (CLK, RESET, sel)
	begin
		if (RESET = '1') then
			DATA_WDATA  <= (others => '0');
		elsif rising_edge(CLK) then
			case sel is
				when "00"  => DATA_WDATA <= IN_DATA;
				when "01"  => DATA_WDATA <= DATA_RDATA + 1;
				when "10"  => DATA_WDATA <= DATA_RDATA - 1;
       when others => DATA_WDATA <= (others => '0');
			end case;
		end if;
	end process;

FSM_present: process (CLK, RESET, EN)
begin
  if RESET = '1' then
    present_state <= idle_state;
  elsif (rising_edge(CLK) and EN = '1') then
      present_state <= next_state;
  end if;
end process;

DATA_ADDR <= PTR_out;
CODE_ADDR <= PC_out;
OUT_DATA <= DATA_RDATA;


FSM: process (present_state, OUT_BUSY, IN_VLD, CODE_DATA, CNT_out, DATA_RDATA)
begin
  PC_inc    <= '0';
  PC_dec    <= '0';
  PTR_inc   <= '0';
  PTR_dec   <= '0';
  CNT_inc   <= '0';
  CNT_dec   <= '0';
  sel       <= "00";
  IN_REQ    <= '0';
  OUT_WREN  <= '0';
  CODE_EN   <= '0';
  DATA_EN   <= '0';
  DATA_WREN <= '0';

  case present_state is

      -- výchozí stav
    when idle_state =>
      next_state <= fetch_state;
 
    when fetch_state =>
      CODE_EN <= '1'; 
      next_state <= decode_state;

    when decode_state =>
      case CODE_DATA is
        when X"3E"   => next_state <=  inc_ptr_state;     --  >     inkrementace hodnoty ukazatele
        when X"3C"   => next_state <=  dec_ptr_state;     --  <     dekrementace hodnoty ukazatele
        when X"2B"   => next_state <=  inc_state_first;   --  +     inkrementace hodnoty aktuální buňky
        when X"2D"   => next_state <=  dec_state_first;   --  -     dekrementace hodnoty aktuální buňky
        when X"2E"   => next_state <=  put_state;         --  .     vytiskni hodnotu aktuální buňky
        when X"2C"   => next_state <=  get_state;         --  ,     načti hodnotu a ulož ji do aktuální buňky
        when X"5B"   => next_state <=  while_state_first; --  [     začátek cyklu while
        when X"5D"   => next_state <=  end_state_first;   --  ]     konec cyklu while
        when X"7E"   => next_state <=  break_state_first; --  ~     ukončí právě prováděnou smyčku while
        when X"00"   => next_state <=  null_state;        --  null  zastav vykonávání programu
        when others  => next_state <=  others_state;      --  ostatní
      end case;
      
      --  inkrementace hodnoty ukazatele  >
    when inc_ptr_state =>
      next_state <= fetch_state;
        -- PTR ← PTR + 1
      PTR_inc <= '1'; 
        -- PC ← PC + 1
      PC_inc <= '1';  
      
      --  dekrementace hodnoty ukazatele  <
    when dec_ptr_state =>
      next_state <= fetch_state;
        -- PTR ← PTR - 1
      PTR_dec <= '1';
        -- PC ← PC - 1
      PC_inc <= '1'; 
     
     -- inkrementace hodnoty aktuální bunky  +
    when inc_state_first =>
        -- DATA RDATA ← ram[PTR]
      DATA_EN <= '1';
      next_state <= inc_state_second;

    when inc_state_second =>
        -- DATA_WDATA = DATA RDATA + 1,
      sel <= "01"; 
      next_state <= inc_state_third;

    when inc_state_third =>
        -- ram[PTR] = DATA_WDATA
      DATA_EN <= '1';
      DATA_WREN <= '1';
        -- PC ← PC + 1
      PC_inc <= '1'; 
      next_state <= fetch_state;

      -- dekrementace hodnoty aktuální bunky  -
    when dec_state_first =>
        -- DATA RDATA ← ram[PTR]
      DATA_EN <= '1';
      next_state <= dec_state_second;

    when dec_state_second =>
        -- DATA_WDATA = DATA RDATA - 1,
      sel <= "10"; 
      next_state <= dec_state_third;
   
    when dec_state_third =>
        -- ram[PTR] = DATA_WDATA
      DATA_EN <= '1';
      DATA_WREN <= '1';
        -- PC ← PC + 1
      PC_inc <= '1'; 
      next_state <= fetch_state;

      --  vytiskni hodnotu aktuální bunky  .
    when put_state =>
        -- while (OUT BUSY) {}
      if (OUT_BUSY = '1') then
          -- OUT DATA ← ram[PTR]
        DATA_EN <= '1';
        next_state <= put_state;
      else
          -- OUT_DATA = DATA_RDATA
        OUT_WREN <= '1'; 
          -- PC ← PC + 1
        PC_inc <= '1'; 
        next_state <= fetch_state;
      end if;

      -- načti hodnotu a ulož ji do aktuální bunky
    when get_state =>
        --IN REQ ← 1
      IN_REQ <= '1';
        -- while (!IN VLD) {}
      if IN_VLD /='1' then
          -- DATA_WDATA = IN_DATA
        sel <= "00"; 
        next_state <= get_state;
      else
          -- ram[PTR] ← DATA_WDATA
        DATA_EN <= '1';
        DATA_WREN <= '1';
          -- PC ← PC + 1
        PC_inc <= '1'; 
        next_state <= fetch_state;
      end if;

      -- začátek cyklu while [  
    when while_state_first =>
        --PC ← PC + 1
      PC_inc <= '1'; 
        -- DATA_RDATA = ram[PTR]
      DATA_EN <= '1';
        --if (DATA_RDATA == 0)
      if (DATA_RDATA = "00000000") then 
          --CNT ← 1
        CNT_inc <= '1'; 
          -- CODE_DATA = rom[CODE_ADDR]
        CODE_EN <= '1'; 
        next_state <= while_state_second; 
        -- if (DATA_RDATA != 0)
      else 
        next_state <= fetch_state;
      end if;

    when while_state_second =>
        -- while (CNT != 0)
      if (CNT_out /= "00000000") then 
          -- if (c == ’[’)
        if CODE_DATA = X"5B" then 
            -- CNT ← CNT + 1
          CNT_inc <= '1';
          -- elsif (c == ’]’)
        elsif CODE_DATA = X"5D" then
            -- CNT ← CNT - 1
          CNT_dec <= '1';
        end if;
          -- PC ← PC + 1
        PC_inc <= '1'; 
        next_state <= while_state_final;
      else 
        next_state <= fetch_state;
      end if;

    when while_state_final =>
        -- CODE_DATA = ROM[CODE_ADDR]
      CODE_EN <= '1'; 
      next_state <= while_state_second;

      -- konec cyklu while ]
    when end_state_first =>
      -- DATA_RDATA = ram[PTR]
      DATA_EN <= '1';
        -- if (ram[PTR] == 0)
      if (DATA_RDATA =  "00000000") then
          -- PC ← PC + 1
        PC_inc <= '1'; 
        next_state <= fetch_state;
      else 
          -- CNT ← 1
        CNT_inc <= '1'; 
          -- PC ← PC - 1
        PC_dec <= '1'; 
        next_state <= end_state_final;
      end if;

    when end_state_second =>
        -- while (CNT != 0)
      if (CNT_out /=  "00000000") then 
          -- if (c == ’]’)
        if CODE_DATA = X"5D" then 
            --  CNT ← CNT + 1
          CNT_inc <= '1';
          -- elsif (c == ’[’)
        elsif CODE_DATA = X"5B" then 
            -- CNT ← CNT - 1
         CNT_dec <= '1';
        end if;
        next_state <= end_state_third;
      else
        next_state <= fetch_state;
      end if;
    
    when end_state_third =>
        -- if (CNT == 0)
			if (CNT_out =  "00000000") then 
          -- PC ← PC + 1
				PC_inc <= '1'; 
			else 
          -- PC ← PC - 1
				PC_dec <= '1'; 
			end if;
      next_state <= end_state_final;

    when end_state_final =>
        -- CODE_DATA = ROM[CODE_ADDR]
      CODE_EN <= '1'; 
      next_state <= end_state_second;

      -- break
    when break_state_first =>
        --CNT ← 1, , PC ← PC + 1
      CNT_inc <= '1';
      PC_inc <= '1'; 
        -- while (CNT != 0)
      if (CNT_out /= "00000000") then 
          -- if (c == ’[’)
        if CODE_DATA = X"5B" then
            -- CNT ← CNT + 1 
          CNT_inc <= '1'; 
          -- elsif (c == ’]’)
        elsif CODE_DATA = X"5D" then 
            --CNT ← CNT - 1
          CNT_dec <= '1'; 
        end if;
          -- PC ← PC + 1
        PC_inc <= '1';
        next_state <= break_state_second;
      else 
      next_state <= fetch_state;
      end if;

    when break_state_second =>
        -- CODE_DATA = rom[CODE_ADDR]
      CODE_EN <= '1'; 
      next_state <= break_state_first;
    
      -- null
    when null_state => 
        next_state <= null_state;
  
      -- ostatni
    when others_state =>
        -- PC ← PC + 1
        PC_inc <= '1'; 
        next_state <= fetch_state;
   
    when others => null;

  end case;

end process;
end behavioral;
 
