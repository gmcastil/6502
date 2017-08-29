
        org     $8000
        lda     $9000           ; $9000 = #$00

        ;; -- Add With Carry (ADC)

        clc                     ; 1 + 1 = 2, returns C = 0, V = 0
        lda     #$01
        adc     $9001           ; $9001 = #$01

        clc                     ; 1 + (-1) = 0, returns C = 1
        lda     #$01
        adc     $9002           ; $9002 = #$ff

        clc                     ; 127 + 1 = 128, returns C = 0, V = 1
        lda     #$7f
        adc     $9001           ; $9001 = #$01

        clc                     ; -128 + -1 = -129, returns C = 1, V = 1
        lda     #$80
        adc     $9002           ; $9002 = #$ff
