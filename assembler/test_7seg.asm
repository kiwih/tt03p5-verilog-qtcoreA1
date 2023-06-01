; this program tests the 7seg output
; the segment patterns are located at out-of-bounds addr 21-31 (0-9)
; the value "21" is stored at out-of-bounds addr "20"
; this means you can load the value you want to display to ACC,
; then ADD 20, then LDAR to get the pattern you want
; we'll store a counter at address 16
0: LDA 16
1: ADD 20
2: LDAR
3: STA 19
4: LDA 16
5: ADDI 1
6: STA 16
7: CLR
8: JMP
16: DATA 0
;
20: DATA 210;
21: DATA 206;