instruction_set = {
    'LDA': '0000',
    'STA': '0001',
    'ADD': '0010',
    'SUB': '0011',
    'AND': '0100',
    'OR': '0101',
    'XOR': '0110',
    'ADDI': '1000',
    'LUI': '1001',
    'SETSEG': '1010',
    'CSR': '10110',
    'CSW': '10111',
    'JMP': '11110000',
    'JSR': '11110001',
    'HLT': '11111111',
    'BEQ': '1100',
    'BNE': '1101',
    'BRA': '1110',
    'SHL': '11110110',
    'SHR': '11110111',
    'ROL': '11111000',
    'ROR': '11111001',
    'LDAR': '11111010',
    'SETSEG_ACC': '11111011',
    'DEC': '11111100',
    'CLR': '11111101',
    'INV': '11111110',
    'DATA': 'DATA'
}

def assemble(program):
    assembled = [0]*256

    # Ensure the program is a list of lines
    if isinstance(program, str):
        program = program.splitlines()

    for line in program:
        # Remove trailing comments
        line = line.split(";")[0]

        address, instruction = line.split(":")
        address = int(address.strip())
        parts = instruction.strip().split()
        mnemonic = parts[0].upper()
        opcode = instruction_set.get(mnemonic, None)
        if opcode is None:
            raise Exception(f"Unknown instruction {mnemonic} at address {address}")
        elif opcode == 'DATA':
            assembled[address] = int(parts[1])
        else:
            if len(parts) > 1:
                if mnemonic in ['BEQ', 'BNE', 'BRA']:
                    operand = int(parts[1])
                    if operand < 0:
                        opcode += '1' + format(abs(operand), '03b')
                    else:
                        opcode += '0' + format(operand, '03b')
                else:
                    opcode += format(int(parts[1]), '04b')
            assembled[address] = int(opcode, 2)
    return assembled



def print_assembled(assembled):
    for i, instr in enumerate(assembled):
        print(f"{i:03}: {format(instr, '08b')}")

# program = """
# 0: LDA 3
# 1: ADD 4
# 2: STA 5
# 3: DATA 10
# 4: DATA 20
# 5: DATA 0
# """

# assembled = assemble(program)
# print_assembled(assembled)

import sys

# load the program provided as a command line argument
asm_program = []
with open(sys.argv[1]) as f:
    for line in f:
        asm_program.append(line.strip())

# delete comments (lines starting with ;)
asm_program = [line for line in asm_program if not line.startswith(';')]
# delete empty lines
asm_program = [line for line in asm_program if line]

# assemble the program
binary_program = assemble(asm_program)

# save the assembled program to a file with the same name as the input file but with .bin extension
with open(sys.argv[1].replace('.asm', '.bin'), 'w') as f:
    for addr, value in enumerate(binary_program):
        #print in format: hex_addr: bin_value \n
        f.write(f'{addr:02x}: {value:08b}\n')

# save the assembled program to a file with the same name as the input file but with .hex extension
with open(sys.argv[1].replace('.asm', '.hex'), 'w') as f:
    for addr, value in enumerate(binary_program):
        #print in format: hex_addr: hex_value \n
        f.write(f'{addr:02x}: {value:02x}\n')

# save the assembled program to a file with the same name as the input file but with .v extension
with open(sys.argv[1].replace('.asm', '.scanchain.v'), 'w') as f:
    for addr, value in enumerate(binary_program):
        if(value != 0):
            f.write(f'scan_chain[SCAN_MEM0_INDEX + {addr}*8 +: 8] = 8\'b{value:08b};\n')