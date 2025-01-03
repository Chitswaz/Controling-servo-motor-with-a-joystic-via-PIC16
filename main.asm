#include "p16f18446.inc"
RES_VECT  CODE    0x0000            ; processor reset vector
    GOTO    START                   ; go to beginning of program

MAIN_PROG CODE                      ; let linker place main program
 
START
 
 ;Memory registers used in the transformation of the ADC values to be used by PWM
 temp1 equ 0x20
 temp2 equ 0x21
 ;RA1 is a PWM pin Use PPS to set PWM6 to RA1
; __config 0x3FEF
    BANKSEL OSCCON1
    MOVLW   B'01100000'
    MOVWF   OSCCON1
    BANKSEL OSCFRQ
    MOVLW   B'000'
    MOVWF   OSCFRQ
 ;Disable PWM output pin
 banksel TRISC
 bsf TRISC,3 
 
 ;Clear PWMxCON reg
 banksel PWM6CON
 clrf PWM6CON
 
 ;Load T2PR with PWM Period value 
 banksel T2PR 
 ;movlw d'255'
 movlw d'156'
 movwf T2PR 
 
 ;Load PWMxDCH and PWMxDCL
 ;lsrf does right shift
 ;lslf does left shift
 ;255 left, 112 middle, 0 right
 ;18 left,46 middle,76 right
 banksel PWM6DCH 
 movlw b'00000100'
 movwf PWM6DCH
 banksel PWM6DCL 
 movlw b'10'
 movwf PWM6DCL
 
 ;Config timer
 banksel PIR4
 bcf PIR4,1
 
 ;Using Fosc/4
 banksel T2CLKCON
 movlw b'0001'
 movwf T2CLKCON
 
 ;Prescaler : 128  PostScaler : 14 Timer off
 banksel T2CON
 ;movlw b'01111101'
 movlw b'01010000'
 movwf T2CON
 
 ;;Start the timer
 bsf T2CON,7
 
 ;Wait for timer to overflow 
check 
 banksel PIR4
 btfss PIR4,1
 goto check
 
 banksel TRISC
 bcf TRISC,3  
 
 ;set desired pin pps control bit(Letting pwm out of the specified port)
 banksel RC3PPS 
 movlw b'001101'
 movwf RC3PPS 
 
 ;Load PWM6CON with appropriate reg
 banksel PWM6CON
 bsf PWM6CON,7
 bcf PWM6CON,4
 
    ;STEP 1: PORT CONFIGURATION
    banksel TRISA  
    bsf    TRISA,4 ; disble output driver in pin RA4
    banksel ANSELA
    bsf    ANSELA, 4; allow analog functions to operate correctly, all digital reads will be read as 0
    
   ;STEP 2: ADC MODULE CONFIGURATION
   ;ADC CONVERSION CLOCK, VOLTAGE REFERENCE, ADC INPUT CHANNEL SELECTION(PRECHARGE + ACQUISATION), TURN ON THE MODULE
    banksel ADCON0
    movlw   b'11010000'; ADC ON (ON==b7==1); continuous operation enabled (CONT==b6==1); FRC oscillator selected(CS==b4==1);Results left Adjusted for 8bit Resolution(FRM==b2==0); conversion disabled(GO==b0==0)
    movwf   ADCON0
    banksel ADREF   
    movlw   b'00000'; Negative voltage reference connected to AVss(ground) (NREF==b4==0), Vref+  connected to Vdd(5V) (PREF[1:0]==00)
    movwf   ADREF;
    banksel ADPCH   
    movlw   b'000100'; select  RA4/ANA4 as ADC input Channel (PCH[5:0]==000010
    movwf   ADPCH
    
    ;STEP 3: ADC INTERRUPT CONFIGURATION
    ;banksel PIR1
    ;bcf    PIR1,0 ;clear ADC interrupt flag(ADIF==b0==0)
    ;banksel PIE1
    ;bsf    PIE1, 0; ENABLE ADC interrupt(ADIE==B0==1)
    
    ;banksel INTCON
    ;movlw   b'11000000'; enable interrupts globally(GIE==b7==1); enable all peripheral interrupts(PIE==b6==1)
    ;movwf   INTCON
    
    banksel ADPRE   ;
    clrf    ADPREL
    clrf    ADPREH ;exclude precharge time in the data conversion cycle
    banksel ADACQ
    clrf    ADACQL
    clrf    ADACQH; exclude acquisation time from the data conversion cycle.
   
    banksel ADCON0
    bsf    ADCON0, 0 ; start conversion(GO==b0==1)
 
loop
;Wait for the interrupt to be triggered 
banksel ADRESH
 movfw ADRESH
 ;movlw d'127'
 banksel TRISC
 movwf temp1 
 lsrf temp1,1
 lsrf temp1,1
 ;lsrf temp1,1
 ;lsrf temp1,1
 movlw d'18'
 ;W register has the divised and added value
 addwf temp1,1
 movfw temp1
 movwf temp2
 lsrf temp1,1
 lsrf temp1,0
 banksel PWM6DCH
 movwf PWM6DCH
 banksel TRISC
 ;movlw d'90'
 ;movwf temp2
 SWAPF temp2,1
 lslf temp2,1 
 lslf temp2,1
 movfw temp2
 banksel PWM6DCL
 movwf PWM6DCL
 goto loop
End
