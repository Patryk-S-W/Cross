;TITLE	'DSM51-M01 SKRZY�OWANIE'
;**************************************
;Program ustawia 8 kolejnych stan�w �wiate� na skrzy�owaniu
;1 - przejazd samochod�w poziomo (i przej�cie poziomo pieszych)
;2 - zmiana �wiate� - ��te dla samochod�w jad�cych poziomo
;		    - zielone mrugaj�ce dla pieszych
;3 - zmiana �wiate� - czerwone dla samochod�w jad�cych poziomo
;		    - czerwone dla pieszych
;4 - zmiana �wiate� - czerwone z ��tym dla samochod�w w pionie
;5 - przejazd samochod�w pionowo (i przej�cie pionowo pieszych)
;6 - zmiana �wiate� - ��te dla samochod�w jad�cych pionowo
;		    - zielone mrugaj�ce dla pieszych
;7 - zmiana �wiate� - czerwone dla samochod�w jad�cych pionowo
;		    - czerwone dla pieszych
;8 - zmiana �wiate� - czerwone z ��tym dla samochod�w w poziomie

;**************************************
;Ustawienie uk�adu 8255
;PORT A - WYJ�CIE MOD 0 - �wiat�a dla pieszych
;przej�cie pionowo
;A0 -> czerwone
;A1 -> zielone
;przej�cie poziomo
;A2 -> czerwone
;A3 -> zielone

;PORT B - WYJ�CIE MOD 0 - �wiat�a dla samochod�w
;przejazd pionowo
;B3 -> czerwone
;B4 -> ��te
;B5 -> zielone
;przejazd poziomo
;B0 -> czerwone
;B1 -> ��te
;B2 -> zielone

;PORT C - WYJ�CIE - nieu�ywane

SET_8255	EQU	10000000B

;**************************************
	LJMP	START

;**************************************
	ORG	100H
	
	MOV	TH0,#0A6H			;odnowienie warto�ci licznika
	MOV	TL0,#00H
	DJNZ	R6,POWROT			;je�li R6 jeszcze nie jest 0 to powr�t
	MOV	R6,#14H
	MOV	A,R7				;wys�anie elementu tablicy pieszych
	MOV	DPTR,#PIESI
	MOVC	A,@A+DPTR
	MOVX	@R0,A
	MOV	A,R7				;wys�anie elementu tablicy smochod�w
	MOV	DPTR,#AUTA
	MOVC	A,@A+DPTR
	MOVX	@R1,A
	INC	R7				;powi�kszenie r7 o 1 w celu wybrania kolejnej sekwencji
	CJNE	R7,#45,POWROT			; je�li r7 wys�a� ju� wszystko to powr�t
	MOV	R7,#00h				;wyzeruj R7
POWROT:
	RETI
		ORG	100H

START:
	MOV	R0,#CS55D		;inicjalizacja 8255
	MOV	A,#SET_8255
	MOVX	@R0,A

	MOV	R0,#CS55A		;port A - �wiat�a dla pieszych
	MOV	R1,#CS55B		;port B - �wiat�a dla samochod�w
	
	
	MOV	R0,#28H				;ustawienie rejestr�w adresowych do komunikacji z 8255
	MOV	R1,#29H				;ustawienie rejestr�w adresowych do komunikacji z 8255
	MOV	DPTR,#0FF2BH			;ustawienie rejestr�w adresowych do komunikacji z 8255
	MOV	R7,#00H				;ustawienie pocz�tkowej warto�ci R7
	MOV	R6,#01H				;ustawienie p�tli licznika
	MOV	A,#80H				;konfiguracja 8255
	MOVX	@DPTR,A
	MOV	A,#0FFH				;zgaszenie diod
	MOVX	@R0,A
	MOVX	@R1,A
	MOV	TH0,#0A6H			;ustawienie liczby pocz�tkowej licznika
	MOV	TL0,#00H
	MOV	TMOD,#01H			;wybranie trybu licznika
	MOV	IE,#82H				;ustawienie przerwa�
	MOV	IP,#00H				;ustawienie priorytet�w przerwa�
	MOV	TCON,#10H			;start licznika
	LJMP	$
PIESI:
		DB	0F9H			;1 - PRZEJ�CIE POZIOMO - ZIELONE, PRZEJ�CIE PIONOWO - CZERWONE
		DB	0F9H			;1 - PRZEJ�CIE POZIOMO - ZIELONE, PRZEJ�CIE PIONOWO - CZERWONE
		DB	0F9H			;1 - PRZEJ�CIE POZIOMO - ZIELONE, PRZEJ�CIE PIONOWO - CZERWONE
		DB	0F9H			;1 - PRZEJ�CIE POZIOMO - ZIELONE, PRZEJ�CIE PIONOWO - CZERWONE
		DB	0F9H			;1 - PRZEJ�CIE POZIOMO - ZIELONE, PRZEJ�CIE PIONOWO - CZERWONE
		DB	0F9H			;1 - PRZEJ�CIE POZIOMO - ZIELONE, PRZEJ�CIE PIONOWO - CZERWONE
		DB	0F9H			;1 - PRZEJ�CIE POZIOMO - ZIELONE, PRZEJ�CIE PIONOWO - CZERWONE
		DB	0F9H			;1 - PRZEJ�CIE POZIOMO - ZIELONE, PRZEJ�CIE PIONOWO - CZERWONE
		DB	0F9H			;1 - PRZEJ�CIE POZIOMO - ZIELONE, PRZEJ�CIE PIONOWO - CZERWONE
		DB	0F9H			;1 - PRZEJ�CIE POZIOMO - ZIELONE, PRZEJ�CIE PIONOWO - CZERWONE
		DB	0FBH			;2 - PRZEJ�CIE POZIOMO - ZIELONE MRUGA, PRZEJ�CIE PIONOWO - CZERWONE
		DB	0F9H
		DB	0FBH
		DB	0F9H
		DB	0FBH
		DB	0F9H
		DB	0FAH			;3 - WSZYSCY PIESI - CZERWONE
		DB	0FAH			;3 - WSZYSCY PIESI - CZERWONE
		DB	0FAH			;3 - WSZYSCY PIESI - CZERWONE
		DB	0FAH			;3 - WSZYSCY PIESI - CZERWONE
		DB	0FAH			;4 - WSZYSCY PIESI - CZERWONE
		DB	0FAH			;4 - WSZYSCY PIESI - CZERWONE
		DB	0F6H			;5 - PRZEJ�CIE POZIOMO - CZERWONE, PRZEJ�CIE PIONOWO - ZIELONE
		DB	0F6H			;5 - PRZEJ�CIE POZIOMO - CZERWONE, PRZEJ�CIE PIONOWO - ZIELONE
		DB	0F6H			;5 - PRZEJ�CIE POZIOMO - CZERWONE, PRZEJ�CIE PIONOWO - ZIELONE
		DB	0F6H			;5 - PRZEJ�CIE POZIOMO - CZERWONE, PRZEJ�CIE PIONOWO - ZIELONE
		DB	0F6H			;5 - PRZEJ�CIE POZIOMO - CZERWONE, PRZEJ�CIE PIONOWO - ZIELONE
		DB	0F6H			;5 - PRZEJ�CIE POZIOMO - CZERWONE, PRZEJ�CIE PIONOWO - ZIELONE
		DB	0F6H			;5 - PRZEJ�CIE POZIOMO - CZERWONE, PRZEJ�CIE PIONOWO - ZIELONE
		DB	0F6H			;5 - PRZEJ�CIE POZIOMO - CZERWONE, PRZEJ�CIE PIONOWO - ZIELONE
		DB	0F6H			;5 - PRZEJ�CIE POZIOMO - CZERWONE, PRZEJ�CIE PIONOWO - ZIELONE
		DB	0F6H			;5 - PRZEJ�CIE POZIOMO - CZERWONE, PRZEJ�CIE PIONOWO - ZIELONE
		DB	0FEH			;6 - PRZEJ�CIE POZIOMO - CZERWONE, PRZEJ�CIE PIONOWO - ZIELONE MRUGA
		DB	0F6H
		DB	0FEH
		DB	0F6H
		DB	0FEH
		DB	0F6H
		DB	0FAH			;7 - WSZYSCY PIESI - CZERWONE
		DB	0FAH			;7 - WSZYSCY PIESI - CZERWONE
		DB	0FAH			;7 - WSZYSCY PIESI - CZERWONE
		DB	0FAH			;7 - WSZYSCY PIESI - CZERWONE
		DB	0FAH			;7 - WSZYSCY PIESI - CZERWONE
		DB	0FAH			;8 - WSZYSCY PIESI - CZERWONE
		DB	0FAH			;8 - WSZYSCY PIESI - CZERWONE
AUTA:
		DB	0DEH			;1 - SAMOCHODY POZIOMO - ZIELONE, SAMOCHODY PIONOWO - CZERWONE
		DB	0DEH			;1 - SAMOCHODY POZIOMO - ZIELONE, SAMOCHODY PIONOWO - CZERWONE
		DB	0DEH			;1 - SAMOCHODY POZIOMO - ZIELONE, SAMOCHODY PIONOWO - CZERWONE
		DB	0DEH			;1 - SAMOCHODY POZIOMO - ZIELONE, SAMOCHODY PIONOWO - CZERWONE
		DB	0DEH			;1 - SAMOCHODY POZIOMO - ZIELONE, SAMOCHODY PIONOWO - CZERWONE
		DB	0DEH			;1 - SAMOCHODY POZIOMO - ZIELONE, SAMOCHODY PIONOWO - CZERWONE
		DB	0DEH			;1 - SAMOCHODY POZIOMO - ZIELONE, SAMOCHODY PIONOWO - CZERWONE
		DB	0DEH			;1 - SAMOCHODY POZIOMO - ZIELONE, SAMOCHODY PIONOWO - CZERWONE
		DB	0DEH			;1 - SAMOCHODY POZIOMO - ZIELONE, SAMOCHODY PIONOWO - CZERWONE
		DB	0DEH			;1 - SAMOCHODY POZIOMO - ZIELONE, SAMOCHODY PIONOWO - CZERWONE
		DB	0EEH			;2 - SAMOCHODY POZIOMO - �ӣTE, SAMOCHODY PIONOWO - CZERWONE
		DB	0EEH
		DB	0EEH
		DB	0EEH
		DB	0EEH
		DB	0EEH
		DB	0F6H			;3 - SAMOCHODY POZIOMO - CZERWONE, SAMOCHODY PIONOWO - CZERWONE
		DB	0F6H			;3 - SAMOCHODY POZIOMO - CZERWONE, SAMOCHODY PIONOWO - CZERWONE
		DB	0F6H			;3 - SAMOCHODY POZIOMO - CZERWONE, SAMOCHODY PIONOWO - CZERWONE
		DB	0F6H			;3 - SAMOCHODY POZIOMO - CZERWONE, SAMOCHODY PIONOWO - CZERWONE
		DB	0F4H			;4 - SAMOCHODY POZIOMO - CZERWONE, SAMOCHODY PIONOWO - CZERWONE/�ӣTE
		DB	0F4H			;4 - SAMOCHODY POZIOMO - CZERWONE, SAMOCHODY PIONOWO - CZERWONE/�ӣTE
		DB	0F3H			;5 - SAMOCHODY POZIOMO - CZERWONE, SAMOCHODY PIONOWO - ZIELONE
		DB	0F3H			;5 - SAMOCHODY POZIOMO - CZERWONE, SAMOCHODY PIONOWO - ZIELONE
		DB	0F3H			;5 - SAMOCHODY POZIOMO - CZERWONE, SAMOCHODY PIONOWO - ZIELONE
		DB	0F3H			;5 - SAMOCHODY POZIOMO - CZERWONE, SAMOCHODY PIONOWO - ZIELONE
		DB	0F3H			;5 - SAMOCHODY POZIOMO - CZERWONE, SAMOCHODY PIONOWO - ZIELONE
		DB	0F3H			;5 - SAMOCHODY POZIOMO - CZERWONE, SAMOCHODY PIONOWO - ZIELONE
		DB	0F3H			;5 - SAMOCHODY POZIOMO - CZERWONE, SAMOCHODY PIONOWO - ZIELONE
		DB	0F3H			;5 - SAMOCHODY POZIOMO - CZERWONE, SAMOCHODY PIONOWO - ZIELONE
		DB	0F3H			;5 - SAMOCHODY POZIOMO - CZERWONE, SAMOCHODY PIONOWO - ZIELONE
		DB	0F3H			;5 - SAMOCHODY POZIOMO - CZERWONE, SAMOCHODY PIONOWO - ZIELONE
		DB	0F5H			;6 - SAMOCHODY POZIOMO - CZERWONE, SAMOCHODY PIONOWO - �ӣTE
		DB	0F5H
		DB	0F5H
		DB	0F5H
		DB	0F5H
		DB	0F5H
		DB	0F6H			;7 - SAMOCHODY POZIOMO - CZERWONE, SAMOCHODY PIONOWO - CZEROWNE
		DB	0F6H			;7 - SAMOCHODY POZIOMO - CZERWONE, SAMOCHODY PIONOWO - CZEROWNE
		DB	0F6H			;7 - SAMOCHODY POZIOMO - CZERWONE, SAMOCHODY PIONOWO - CZEROWNE
		DB	0F6H			;7 - SAMOCHODY POZIOMO - CZERWONE, SAMOCHODY PIONOWO - CZEROWNE
		DB	0F6H			;8 - SAMOCHODY POZIOMO - CZERWONE/�ӣTE, SAMOCHODY PIONOWO - CZERWONE
		DB	0F6H			;8 - SAMOCHODY POZIOMO - CZERWONE/�ӣTE, SAMOCHODY PIONOWO - CZERWONE

;**************************************
;kolejne powt�rzenie wszystkich stan�w �wiate� na skrzy�owaniu
LOOP:
	MOV	R7,#8		;8 stan�w �wiate� na skrzy�owaniu
	MOV	R2,#1		;stan pierwszy

;**************************************
;ustawienie kolejnego stanu �wiate�
STAN:
	MOV	A,R2		;�wiat�a dla samochod�w
	ACALL	SET_AUTO	;dla stanu numer (R2)
	MOVX	@R1,A

	MOV	A,R2		;�wiat�a dla pieszych
	ACALL	SET_PEOPLE	;dla stanu numer (R2)
	MOVX	@R0,A
	MOV	R3,A		;zapami�taj status pieszych
	
	MOV	A,R2		;mruganie �wiate� dla pieszych
	ACALL	SET_BLINK	;dla stanu numer (R2)
	MOV	R4,A		;zapami�taj status mrugania

	MOV	A,R2		;czas �wiate� w stanie numer (R2)
	ACALL	SET_TIME	;N * 0.5 sek
	MOV	R5,A		;zapami�taj czas

	MOV	A,R2		;text na wy�wietlacz LCD
	ACALL	SET_TEXT	;dla stanu numer (R2)
	LCALL	LCD_CLR
	LCALL	WRITE_TEXT

;**************************************
;odliczanie czasu jednego stanu z dok�adno�ci� 0.5 sek
;mruganie �wiate� dla pieszych je�li to konieczne
;z cz�stotliwo�ci� 1Hz
BLINK:
	MOV	A,#5		
	LCALL	DELAY_100MS

	MOV	A,R3		;mruganie �wiate� dla pieszych
	XRL	A,R4		;-zmiana stanu na przeciwne
	MOV	R3,A		;dla wybranych �wiate�
	MOVX	@R0,A

	DJNZ	R5,BLINK	;czas = R5 * 0.5 sek

	INC	R2		;kolejny stan
	DJNZ	R7,STAN

	SJMP	LOOP		;rozpocznij od pierwszego stanu

;**************************************
;dane do zapalenia �wiate� dla samochod�w w 8 kolejnych stanach
SET_AUTO:
	MOVC	A,@A+PC
	RET
	DB	11110011B,11110101B,11110110B,11100110B
	DB	11011110B,11101110B,11110110B,11110100B
	
;**************************************
;dane do zapalenia �wiate� dla pieszych w 8 kolejnych stanach
SET_PEOPLE:
	MOVC	A,@A+PC
	RET
	DB	11110110B,11110110B,11111010B,11111010B
	DB	11111001B,11111001B,11111010B,11111010B

;**************************************
;dane do mrugania �wiate� dla pieszych w 8 kolejnych stanach
;1-mruganie odpowiedniego �wiat�a
SET_BLINK:
	MOVC	A,@A+PC
	RET
	DB	00000000B,00001000B,00000000B,00000000B
	DB	00000000B,00000010B,00000000B,00000000B

;**************************************
;czas kolejnych stan�w wyra�ony w 0.5 sek
SET_TIME:
	MOVC	A,@A+PC
	RET
	DB	15,8,4,4,15,8,4,4

;**************************************
;pobranie adresu tekstu dla kolejnego stanu
SET_TEXT:
	RL	A
	PUSH	ACC
	ACALL	SET_TXT
	MOV	DPL,A

	POP	ACC
	DEC	A
	ACALL	SET_TXT
	MOV	DPH,A
	RET


;**************************************
;teksty opisuj�ce stan na skrzy�owaniu w kolejnych stanach
TEXT1:
	DB	'PRZEJAZD POZIOMO',0

TEXT2:
	DB	'ZMIANA SWIATEL  '
	DB	'ZOLTE ',0

TEXT3:
	DB	'ZMIANA SWIATEL  '
	DB	'CZERWONE',0

TEXT4:
	DB	'ZMIANA SWIATEL  '
	DB	'CZERWONE ZOLTE',0

TEXT5:
	DB	'PRZEJAZD PIONOWO',0
;**************************************
SET_TXT:
	MOVC	A,@A+PC
	RET

	DW	TEXT1,TEXT2,TEXT3,TEXT4
	DW	TEXT5,TEXT2,TEXT3,TEXT4

;**************************************
;END


