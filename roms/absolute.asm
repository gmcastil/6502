;;; The purpose of this file is to describe the set of instructions used in
;;; testing absolute addressing mode.  At this point, each instruction is hand
;;; assembled from this file and then placed into a ROM used by the testbench
;;; for testing absolute addressing mode.

        .org     $8000
8000:   lda     $9000           ; $9000 = $00

        ;; -- Add With Carry (ADC)

        ;; 1 + 1 = 2, returns C = 0, V = 0
8003:   clc
8004:   clv
8005:   lda     #$01
8007:   adc     $9001           ; $9001 = $01

        ;; 1 + (-1) = 0, returns C = 1, V = 0, N = 0, Z = 1
800a:   clc
800b:   clv
800c:   lda     #$01
800e:   adc     $9002           ; $9002 = $ff

        ;; 127 + 1 = 128, returns C = 0, V = 1, N = 1, Z = 0
17:     clc
18:     clv
19:     lda     #$7f
21:     adc     $9001           ; $9001 = $01

        ;; -128 + -1 = -129, returns C = 1, V = 1, N = 0, Z = 0
24:     clc
25:     clv
26:     lda     #$80
28:     adc     $9002           ; $9002 = $ff

        ;; -- And Accumulator with Memory (AND)

        ;; 0x55 & 0xaa = 0x00, returns Z = 1, N = 0
31:     lda     #$55
33:     and     $9003           ; $9003 = $aa

        ;; 0xff & 0xaa = 0xaa, returns Z = 0, N = 1
36:     lda     #$ff
38:     and     $9004           ; $9004 = $aa

        ;; 0x22 & 0x22 = 0x22, returns Z = 0, N = 0
41:     lda     #$22
43:     and     $9005           ; $9005 = $22

        ;; -- Shift Memory Left (ASL)

        ;; 0x55 << returns A = $aa, Z = 1, C = 0
46:     clc
47:     asl     $9006           ; $9006 = $ff

        ;; 0xaa << returns A = $fe, Z = 1, C = 1
50:     sec
51:     asl     $9006           ; $9006 = $fe

        ;; -- Test Memory Bits Against Accumulator (BIT)

        ;; $ff & $aa returns Z = 0, N = 1, V = 1
54:     lda     #$ff
56:     bit     $9007           ; $9007 = $aa

        ;; $ff & $00 returns Z = 1, N = 1, V = 0
59:     clv
60:     lda     #$00
62:     bit     $9007           ; $9007 = $aa

        ;; -- Compare Accumulator with Memory (CMP)

        ;; $00 - $aa returns Z = 0, N = 0, C = 0
65:     lda     #$00
67:     cmp     $9008           ; $9008 = $aa
        ;; $ff - $aa returns Z = 0, N = 0, C = 0
70:     lda     #$ff
72:     cmp     $9008
        ;; $80 - $aa returns Z = 0, N = 1, C = 0
75:     lda     #$80
77:     cmp     $9008

        ;; -- Compare Index Register X with Memory

        ;; $00 - $aa returns Z = 0, N = 0, C = 0
80:     ldx     #$00
82:     cpx     $9008           ; $9008 = $aa
        ;; $ff - $aa returns Z = 0, N = 0, C = 0
85:     ldx     #$ff
87:     cpx     $9008           ; $9008 = $aa
        ;; $80 - $aa returns Z = 0, N = 1, C = 0
90:     ldx     #$80
92:     cpx     $9008           ; $9008 = $aa

        ;; -- Compare Index Register X with Memory

        ;; $00 - $aa returns Z = 0, N = 0, C = 0
95:     ldy     #$00
97:     cpy     $9008           ; $9008 = $aa
        ;; $ff - $aa returns Z = 0, N = 0, C = 0
100:    ldy     #$ff
102:    cpy     $9008
        ;; $80 - $aa returns Z = 0, N = 1, C = 0
105:    ldy     #$80
107:    cpy     $9008

        ;; -- Decrement

        ;; $02 - $01 = $01, returns Z = 0, N = 0
110:    dec     $9009           ; $9009 = $02
        ;; $01 - $01 = $00, returns Z = 1, N = 0
113:    dec     $9009
        ;; $00 - $01 = $ff, returns Z = 0, N = 1
116:    dec     $9009

        ;; -- Exclusive-OR Accumulator with Memory

        ;; $55 XOR $55 = $00, returns Z = 1, N = 0
119:    lda     #$55         ;
121:    eor     $900a           ; $900a = $55
        ;; $55 XOR $aa = $ff, returns Z = 0, N = 1
124:    lda     #$55
126:    eor     $900b           ; $900b = $aa

        ;; -- Increment

        ;; $fe + $01 = $ff, returns Z = 0, N = 1
129:    inc     $900c
        ;; $ff + $01 = $00, returns Z = 1, N = 0
132:    inc     $900c           ; $900c = $fe

        ;; -- Load Accumulator from Memory

        ;; Returns A = $00, Z = 1, N = 0
135:    lda     $900d           ; $900d = $00
        ;; Returns A = $ff, Z = 0, N = 1
138:    lda     $900e           ; $900e = $ff

        ;; -- Load Index Register X from Memory

        ;; Returns A = $00, Z = 1, N = 0
141:    ldx     $900f           ; $900f = $00
        ;; Returns A = $ff, Z = 0, N = 1
144:    ldx     $9010           ; $9010 = $ff

        ;; -- Load Index Register Y from Memory

        ;; Returns A = $00, Z = 1, N = 0
147:    ldy     $9011           ; $9011 = $00
        ;; Returns A = $ff, Z = 0, N = 1
150:    ldy     $9012           ; $9012 = $ff


        ;; -- Logical Shift Memory or Accumulator Right (LSR)

        ;; 0x55 >> returns $9013 = $2a, Z = 0, C = 1
153:    clc
154:    lsr     $9013           ; $9013 = $55

        ;; 0x01 >> returns $9014 = $00, Z = 1, C = 1
157:    clc
158:    lsr     $9014           ; $9014 = $01

        ;; -- OR Accumulator with Memory

        ;; $55 OR $55 = $55, returns Z = 0, N = 0
161:    lda     #$55
163:    ora     $9015           ; $9015 = $55
        ;; $55 OR $aa = $ff, returns Z = 1, N = 1
166:    lda     #$55
168:    ora     $9016           ; $9016 = $aa

        ;; -- Rotate Memory or Accumulator Left

171:    rol     $9017           ; $9017 = $55 -> $aa, returns C = 0, N = 1
174:    rol     $9018           ; $9018 = $aa -> $54, returns C = 1, N = 0

        ;; -- Rotate Memory or Accumulator Right

177:    ror     $9019           ; $9019 = $55 -> $2a, returns Z = 0, C = 1, N = 0
180:    ror     $901a           ; $901a = $aa -> $55, returns Z = 0, C = 0, N = 0
183:    ror     $901b           ; $901b = $01 -> $00, returns Z = 1, C = 1, N = 0

        ;; -- Subtract with Borrow from Accumulator
