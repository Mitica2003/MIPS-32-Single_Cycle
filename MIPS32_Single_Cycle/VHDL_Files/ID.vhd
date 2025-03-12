library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ID is
    Port(RD1 : out std_logic_vector(31 downto 0);
        RD2 : out std_logic_vector(31 downto 0);
        Ext_Imm : out std_logic_vector(31 downto 0);
        func : out std_logic_vector(5 downto 0);
        sa : out std_logic_vector(4 downto 0);
        WD : in std_logic_vector(31 downto 0);
        Instr : in std_logic_vector(25 downto 0);
        clk:in std_logic;
        en: in std_logic;
        regWrite: in std_logic;
        regDst: in std_logic;
        ExtOp: in std_logic);
end ID;

architecture Behavioral of ID is

type reg_file_type is array(0 to 31) of std_logic_vector(31 downto 0);
signal reg_file:reg_file_type:=(others=>X"00000000");
signal Write_Address:std_logic_vector(4 downto 0);
signal RA1: std_logic_vector(4 downto 0);
signal RA2: std_logic_vector(4 downto 0);
begin

    with regDst select 
        Write_Address <= Instr(20 downto 16) when '0',
                         Instr(15 downto 11) when '1',
                         (others => 'X') when others;
        
    func<=Instr(5 downto 0);
    sa<=Instr(10 downto 6);
    
    with ExtOp select Ext_Imm<=
        X"0000"&Instr(15 downto 0) when '0',
        Instr(15)& Instr(15)& Instr(15)& Instr(15)&
        Instr(15)& Instr(15)& Instr(15)& Instr(15)&
        Instr(15)& Instr(15)& Instr(15)& Instr(15)&
        Instr(15)& Instr(15)& Instr(15)& Instr(15)&
        Instr(15 downto 0) when '1',
        (others => 'X') when others;
         
    RA1 <= Instr(25 downto 21);
    RA2 <= Instr(20 downto 16);
    RD1 <= reg_file(conv_integer(RA1));
    RD2 <= reg_file(conv_integer(RA2));
       
    process(clk)
    begin
        if rising_edge(clk) then
            if en='1' and regWrite='1' then
                reg_file(conv_integer(Write_Address)) <= WD;
            end if;
        end if;   
    end process;

end Behavioral;