;;; The purpose of this file is to describe the set of instructions used in
;;; testing absolute addressing mode.  At this point, each instruction is hand
;;; assembled from this file and then placed into a ROM used by the testbench
;;; for testing absolute addressing mode.

        org     $8000
        lda     $9000           ; $9000 = #$00

        ;; -- Add With Carry (ADC)

        ;; 1 + 1 = 2, returns C = 0, V = 0
        clc
        clv
        lda     #$01
        adc     $9001           ; $9001 = #$01

        ;; 1 + (-1) = 0, returns C = 1, V = 0, N = 0, Z = 1
        clc
        clv
        lda     #$01
        adc     $9002           ; $9002 = #$ff

        ;; 127 + 1 = 128, returns C = 0, V = 1, N = 1, Z = 0
        clc
        clv
        lda     #$7f
        adc     $9001           ; $9001 = #$01

        ;; -128 + -1 = -129, returns C = 1, V = 1, N = 0, Z = 0
        clc
        clv
        lda     #$80
        adc     $9002           ; $9002 = #$ff

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
