library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity iFetch is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           en : in STD_LOGIC;
           branch_address : in STD_LOGIC_VECTOR(31 downto 0);
           pc_src : in STD_LOGIC;         
           jump_address : in STD_LOGIC_VECTOR(31 downto 0);
           jump : in STD_LOGIC;
           pc : out STD_LOGIC_VECTOR(31 downto 0);
           instruction : out STD_LOGIC_VECTOR(31 downto 0));
end iFetch;

architecture Behavioral of IFetch is
type memROM is array(0 to 31) of STD_LOGIC_VECTOR(31 downto 0);
signal mem : memROM := ( B"010000_00000_00010_0000000000000100",     -- X"40020004" 00: lw $2, 4($0)    PC:0004   Salvam valoarea lui A în $2
                         B"010000_00000_00011_0000000000001000",     -- X"40030008" 01: lw $3, 8($0)    PC:0008   Salvam valoarea lui N în $3
                         B"000000_00000_00010_00101_00000_100000",   -- X"00022820" 02: add $5, $0, $2  PC:000C   Salvam locatia de unde incepe sirul de numere in $5(indexul sirului)
                         B"010000_00101_00110_0000000000000000",     -- X"40A60000" 03: lw $6, 0($5)    PC:0010   $6(nr1) = A(1)
                         B"010000_00101_00111_0000000000000100",     -- X"40A70004" 04: lw $7, 4($5)    PC:0014   $7(nr2) = A(2)
                         B"000000_00111_00110_00100_00000_010000",   -- X"00E62010" 05: sub $4, $7, $6  PC:0018   $4(ratia progresiei) = nr1 - nr2
                         B"100000_00101_00101_0000000000000100",     -- X"80A50004" 06: addi $5, $5, 4  PC:001C   Indexul sirului(index) merge la adresa urmatoare
                         B"100000_00000_00001_0000000000000010",     -- X"80010002" 07: addi $1, $0, 2  PC:0020   Initializam contorul buclei(i) cu 2
                         B"000100_00001_00011_0000000000001001",     -- X"10230009" 08: beq $1, $3, 9   PC:0024   Verificam daca i != N
                         B"010000_00101_00110_0000000000000000",     -- X"40A60000" 09: lw $6, 0($5)    PC:0028   $6(nr1) = A(index)
                         B"010000_00101_00111_0000000000000100",     -- X"40A70004" 10: lw $7, 4($5)    PC:002C   $7(nr2) = A(index+1)
                         B"000000_00111_00110_01000_00000_010000",   -- X"00E64010" 11: sub $8, $7, $6  PC:0030   $8(ratia din bucla) = nr1 - nr2
                         B"000010_01000_00100_0000000000000100",     -- X"09040004" 12: bne $8, $4, 4   PC:0034   Daca ratia din bucla e diferita de ratia progresiei, iesim din bucla
                         B"100000_00000_01010_0000000000000001",     -- X"800A0001" 13: addi $10, $0, 1 PC:0038   Valoarea rezultatului(registrul $10) o setam la 1(true)
                         B"100000_00101_00101_0000000000000100",     -- X"80A50004" 14: addi $5, $5, 4  PC:003C   Indexul sirului(index) merge la adresa urmatoare
                         B"100000_00001_00001_0000000000000001",     -- X"80210001" 15: addi $1, $1, 1  PC:0040   Se incrementeaza contorul i cu 1
                         B"101010_00000000000000000000001000",       -- X"A8000008" 16: j 8             PC:0044   Se sare la instructiunea 8 (reluarea buclei)
                         B"100000_00000_01010_0000000000000000",     -- X"800A0000" 17: addi $10, $0, 0 PC:0048   Se seteaza registrul $10 cu valoarea 0(false) daca s-a iesit din bucla prin BNE
                         B"001000_00000_01010_0000000000000000",     -- X"200A0000" 18: sw $10, 0($0)   PC:004C   Se scrie valoarea din registrul $10 la adresa 0
                         others => X"00000000");


signal d : STD_LOGIC_VECTOR(31 downto 0);
signal q : STD_LOGIC_VECTOR(31 downto 0) := X"00000000";
signal sum : STD_LOGIC_VECTOR(31 downto 0);
signal outMUX : STD_LOGIC_VECTOR(31 downto 0);

begin

    process(clk, rst)
    begin
        if rst = '1' then q <= (others => '0');
        elsif rising_edge(clk) then 
            if en = '1' then q <= d;
            end if;
        end if;     
    end process;
    
    pc <= q + X"00000004";  

    with pc_src SELECT 
        outMUX <= q + 4 when '0',
        branch_address when '1',
        (others => 'X') when others; 
    
    with jump SELECT
        d <= outMUX when '0',
        jump_address when '1',
        (others => 'X') when others; 

    instruction <= mem(conv_integer(q(6 downto 2)));
               
end Behavioral;
