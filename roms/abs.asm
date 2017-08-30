
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
