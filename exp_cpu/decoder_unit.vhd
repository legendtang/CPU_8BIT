library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.exp_cpu_components.all;

entity decoder_unit is
    port (IR : in std_logic_vector (7 downto 0);
          SR : out std_logic_vector (1 downto 0);
          DR : out std_logic_vector (1 downto 0);
          op_code : out std_logic_vector (2 downto 0);
          zj_instruct : out std_logic; -- jrz
          cj_instruct : out std_logic; -- jrc
          lj_instruct : out std_logic; -- long jmp, aka jmpa
          DRWr : buffer std_logic;
          mem_write : out std_logic;
          dw_instruct : buffer std_logic;
          change_z : out std_logic;
          change_c : out std_logic;
          sel_memdata : out std_logic;
          r_sjmp_addr : out std_logic_vector (7 downto 0));
end decoder_unit;

architecture behav of decoder_unit is
begin

    sr <= IR (3 downto 2);
    dr <= IR (1 downto 0);

    sel_memdata <= 	IR(7) and IR(6) and (not IR(5));

    change_z <= (not IR(7)) and (not IR(6));
    change_c <= (not IR(7)) and (not IR(6));

    DRWr_proc : process (IR)
    begin
        if IR(7) = '0' then -- 算术指令，包括mvrr
           --if IR(6) = '1' then -- modifiable
              drwr <= '1';
           --else
           --   drwr <= '0';
           --end if;
        elsif IR(6) = '1' and IR(5)= '0' then
                drwr <= '1';
            else -- mvrd与ldrr
                drwr <= '0';
            end if;
    end process;

    sj_addr_proc : process (IR)
    begin
        if IR(3) = '1' then
            r_sjmp_addr <= "1111" & IR(3 downto 0);
        else
            r_sjmp_addr <= "0000" & IR(3 downto 0);
        end if;
    end process;

    m_instruct : process (IR)
    begin
        case IR(7 downto 4) is
           when "1000"|"1100" =>
              Mem_Write<= '0';
              DW_instruct <= '1';
           when "1110" => 
              Mem_Write <= '1';
              DW_instruct <= '0';
           when others =>
              Mem_Write <= '0';
              DW_instruct <= '0';
    end case;
    end process;

    ALUOP_CODE_PROC : process (IR)
    begin
        if IR (7) = '0' then
            op_code <= IR (6 downto 4);
        else
            op_code <= "111";
        end if;
    end process;

    instruct_proc : process (IR)
    begin
         case IR (7 downto 4) is
                when "1000" =>
		            zj_instruct <= '0';
		    		cj_instruct <= '0';
                    lj_instruct <= '1';
                --when "1001" =>
		        --    zj_instruct <= '0';
		    	--	cj_instruct <= '1';
                --    lj_instruct <= '0';
                when "1010" =>
		            zj_instruct <= '1';
		    		cj_instruct <= '0';
                    lj_instruct <= '0';
                when others =>
		            zj_instruct <= '0';
		    		cj_instruct <= '0';
                    lj_instruct <= '0';
                    null;
            end case;
    end process;
end behav;


