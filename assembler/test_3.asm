; this program tests all variable-data operands
; and different segments
0: LDA 15       ; load 10 from M[0+15]
1: ADDI 1       ; add 1 to 10
2: STA 0        ; set M[0+0 = 0] to 11
3: ADD 15       ; add M[0+15](10) to 11 = 21
4: STA 1        ; set M[0+1 = 1] to 21
5: SUB 13       ; sub M[0+13](4) from 21 = 17
6: STA 2        ; set M[0+2 = 2] to 17
7: CLR
8: SETSEG 1    ; set segment to 1
9: LUI 1      ; load 0x10 to ACC
10: JMP
13: DATA 4
14: DATA 15
15: DATA 10
; next segment
16: CLR
17: ADDI 1    ; add 1 to 0
18: STA 0     ; set M[16+0 = 16] to 1
19: SETSEG 0  ; set segment to 0
20: LDA 2     ; load from M[0+2] which is 17
21: AND 14    ; AND M[0+14](0xF) to 17(0b10001), should become 0b0001
22: STA 3      ; set M[0+3 = 3] to 1
23: SETSEG 1    
24: OR 14        ; OR M[16+14](14) to 1, should become 15
25: STA 1       ; set M[16+1 = 17] to 15
26: XOR 13      ; XOR M[16+13](255) with 15, should become f0
27: STA 2       ; set M[16+2 = 18] to f0
28: HLT;
29: DATA 255;
30: DATA 14;