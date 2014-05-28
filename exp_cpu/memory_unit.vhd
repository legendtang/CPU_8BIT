library ieee;
use ieee.std_logic_1164.all;
use work.exp_cpu_components.all;

entity memory_unit is
    port(
            reset       :   in std_logic;
            clk, t3     :   in std_logic;
            Mem_addr    :   in std_logic_vector(7 downto 0);
            Mem_Write   :   in std_logic;
            sel_memdata :   in std_logic;
            SR_data     :   in std_logic_vector(7 downto 0);
            result      :   in std_logic_vector(7 downto 0);
            rw          :   out std_logic;
            ob          :   inout std_logic_vector(7 downto 0);
            ar          :   out std_logic_vector(7 downto 0);
            data_read   :   buffer std_Logic_vector(7 downto 0);
            
            DR_data_out :   out std_logic_vector(7 downto 0)
        );
end memory_unit;

architecture behav of memory_unit is
begin
    ar <= Mem_addr;
    R_W_Memory_proc:process(reset, ob, SR_data, clk, t3, Mem_Write)
    begin
        if reset = '0' then
            rw <= '1';
            ob <= "ZZZZZZZZ";
        else
            if Mem_Write = '1' and t3 = '1' then
                ob <= SR_DATA;
                rw <= clk;
            else
                ob <= "ZZZZZZZZ";
                rw <= '1';
                data_read <= ob;
            end if;
        end if;
    end process;
    
    sele_DR_proc:process(sel_memdata, data_read, result)
    begin
        if sel_memdata = '1' then
            DR_data_out <= data_read;
        else
            DR_data_out <= result;
        end if;
    end process;
    
end behav;
