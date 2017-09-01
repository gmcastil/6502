;;; The purpose of this file is to describe the set of instructions used in
;;; testing absolute addressing mode.  At this point, each instruction is hand
;;; assembled from this file and then placed into a ROM used by the testbench
;;; for testing absolute addressing mode.

        org     $8000
        lda     $9000           ; $9000 = $00

        ;; -- Add With Carry (ADC)

        ;; 1 + 1 = 2, returns C = 0, V = 0
        clc
        clv
        lda     #$01
        adc     $9001           ; $9001 = $01

        ;; 1 + (-1) = 0, returns C = 1, V = 0, N = 0, Z = 1
        clc
        clv
        lda     #$01
        adc     $9002           ; $9002 = $ff

        ;; 127 + 1 = 128, returns C = 0, V = 1, N = 1, Z = 0
        clc
        clv
        lda     #$7f
        adc     $9001           ; $9001 = $01

        ;; -128 + -1 = -129, returns C = 1, V = 1, N = 0, Z = 0
        clc
        clv
        lda     #$80
        adc     $9002           ; $9002 = $ff

        ;; -- And Accumulator with Memory (AND)

        ;; 0x55 & 0xaa = 0x00, returns Z = 1, N = 0
        lda     #$55
        and     $9003           ; $9003 = $aa

        ;; 0xff & 0xaa = 0xaa, returns Z = 0, N = 1
        lda     #$ff
        and     $9004           ; $9004 = $aa

        ;; 0x22 & 0x22 = 0x22, returns Z = 0, N = 0
        lda     #$22
        and     $9005           ; $9005 = $22

        ;; -- Shift Memory Left (ASL)

        ;; 0x55 << returns A = $aa, Z = 1, C = 0
        clc
        asl     $9006           ; $9006 = $ff

        ;; 0xaa << returns A = $fe, Z = 1, C = 1
        sec
        asl     $9006           ; $9006 = $fe

        ;; -- Test Memory Bits Against Accumulator (BIT)

        ;; $ff & $aa returns Z = 0, N = 1, V = 1
        lda     #$ff
        bit     $9007           ; $9007 = $aa

        ;; $ff & $00 returns Z = 1, N = 1, V = 0
        clv
        lda     #$00
        bit     $9007           ; $9007 = $aa

        ;; -- Compare Accumulator with Memory (CMP)

        ;; $00 - $aa returns Z = 0, N = 0, C = 0
        lda     #$00
        cmp     $9008           ; $9008 = $aa
        ;; $ff - $aa returns Z = 0, N = 0, C = 0
        lda     #$ff
        cmp     $9008
        ;; $80 - $aa returns Z = 0, N = 1, C = 0
        lda     #$80
        cmp     $9008

        ;; -- Compare Index Register X with Memory

        ;; $00 - $aa returns Z = 0, N = 0, C = 0
        ldx     #$00
        cpx     $9008           ; $9008 = $aa
        ;; $ff - $aa returns Z = 0, N = 0, C = 0
        ldx     #$ff
        cpx     $9008           ; $9008 = $aa
        ;; $80 - $aa returns Z = 0, N = 1, C = 0
        ldx     #$80
        cpx     $9008           ; $9008 = $aa

        ;; -- Compare Index Register X with Memory

        ;; $00 - $aa returns Z = 0, N = 0, C = 0
        ldy     #$00
        cpy     $9008           ; $9008 = $aa
        ;; $ff - $aa returns Z = 0, N = 0, C = 0
        ldy     #$ff
        cpy     $9008
        ;; $80 - $aa returns Z = 0, N = 1, C = 0
        ldy     #$80
        cpy     $9008

        ;; -- Decrement

        ;; $02 - $01 = $01, returns Z = 0, N = 0
        dec     $9009           ; $9009 = $02
        ;; $01 - $01 = $00, returns Z = 1, N = 0
        dec     $9009
        ;; $00 - $01 = $ff, returns Z = 0, N = 1
        dec     $9009

        ;; -- Exclusive-OR Accumulator with Memory

        ;; $55 XOR $55 = $00, returns Z = 1, N = 0
        lda     #$55
        eor     $900a           ; $900a = $55
        ;; $55 XOR $aa = $ff, returns Z = 0, N = 1
        lda     #$55
        eor     $900b           ; $900b = $aa

        ;; -- Increment

        ;; $fe + $01 = $ff, returns Z = 0, N = 1
        inc     $900c
        ;; $ff + $01 = $00, returns Z = 1, N = 0
        inc     $900c

        ;; -- Load Accumulator from Memory

        ;; Returns A = $00, Z = 1, N = 0
        lda     $900d           ; $900d = $00
        ;; Returns A = $ff, Z = 0, N = 1
        lda     $900e           ; $900e = $ff

        ;; -- Load Index Register X from Memory

        ;; Returns A = $00, Z = 1, N = 0
        ldx     $900f           ; $900f = $00
        ;; Returns A = $ff, Z = 0, N = 1
        ldx     $9010           ; $9010 = $ff

        ;; -- Load Index Register Y from Memory

        ;; Returns A = $00, Z = 1, N = 0
        ldy     $9011           ; $9011 = $00
        ;; Returns A = $ff, Z = 0, N = 1
        ldy     $9012           ; $9012 = $ff


        ;; -- Logical Shift Memory or Accumulator Right (LSR)

        ;; 0x55 >> returns $9013 = $2a, Z = 0, C = 1
        clc
        lsr     $9013           ; $9013 = $55

        ;; 0x01 >> returns $9014 = $00, Z = 1, C = 1
        clc
        lsr     $9014           ; $9014 = $01

        ;; -- OR Accumulator with Memory

        ;; $55 OR $55 = $55, returns Z = 0, N = 0
        lda     #$55
        or      $9015           ; $9015 = $55
        ;; $55 OR $aa = $ff, returns Z = 1, N = 1
        lda     #$55
        or      $9016           ; $9016 = $aa

        ;; -- Rotate Memory or Accumulator Left

        rol     $9017           ; $9017 = $55 -> $aa, returns C = 0, N = 1
        rol     $9018           ; $9018 = $aa -> $54, returns C = 1, N = 0

        ;; -- Rotate Memory or Accumulator Right

        ror     $9019           ; $9019 = $55 -> $2a, returns Z = 0, C = 1, N = 0
        ror     $901a           ; $901a = $aa -> $55, returns Z = 0, C = 0, N = 0
        ror     $901b           ; $901b = $01 -> $00, returns Z = 1, C = 1, N = 0

        ;; -- Subtract with Borrow from Accumulator
