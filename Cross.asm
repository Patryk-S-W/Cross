;TITLE	'DSM51-M01 SKRZY¯OWANIE'
;**************************************
;Program ustawia 8 kolejnych stanów œwiate³ na skrzy¿owaniu
;1 - przejazd samochodów poziomo (i przejœcie poziomo pieszych)
;2 - zmiana œwiate³ - ¿ó³te dla samochodów jad¹cych poziomo
;		    - zielone mrugaj¹ce dla pieszych
;3 - zmiana œwiate³ - czerwone dla samochodów jad¹cych poziomo
;		    - czerwone dla pieszych
;4 - zmiana œwiate³ - czerwone z ¿ó³tym dla samochodów w pionie
;5 - przejazd samochodów pionowo (i przejœcie pionowo pieszych)
;6 - zmiana œwiate³ - ¿ó³te dla samochodów jad¹cych pionowo
;		    - zielone mrugaj¹ce dla pieszych
;7 - zmiana œwiate³ - czerwone dla samochodów jad¹cych pionowo
;		    - czerwone dla pieszych
;8 - zmiana œwiate³ - czerwone z ¿ó³tym dla samochodów w poziomie

;**************************************
;Ustawienie uk³adu 8255
;PORT A - WYJŒCIE MOD 0 - œwiat³a dla pieszych
;przejœcie pionowo
;A0 -> czerwone
;A1 -> zielone
;przejœcie poziomo
;A2 -> czerwone
;A3 -> zielone

;PORT B - WYJŒCIE MOD 0 - œwiat³a dla samochodów
;przejazd pionowo
;B3 -> czerwone
;B4 -> ¿ó³te
;B5 -> zielone
;przejazd poziomo
;B0 -> czerwone
;B1 -> ¿ó³te
;B2 -> zielone

;PORT C - WYJŒCIE - nieu¿ywane

SET_8255	EQU	10000000B

;**************************************
	LJMP	START

;**************************************
	ORG	100H
	
	MOV	TH0,#0A6H			;odnowienie wartoœci licznika
	MOV	TL0,#00H
	DJNZ	R6,POWROT			;jeœli R6 jeszcze nie jest 0 to powrót
	MOV	R6,#14H
	MOV	A,R7				;wys³anie elementu tablicy pieszych
	MOV	DPTR,#PIESI
	MOVC	A,@A+DPTR
	MOVX	@R0,A
	MOV	A,R7				;wys³anie elementu tablicy smochodów
	MOV	DPTR,#AUTA
	MOVC	A,@A+DPTR
	MOVX	@R1,A
	INC	R7				;powiêkszenie r7 o 1 w celu wybrania kolejnej sekwencji
	CJNE	R7,#45,POWROT			; jeœli r7 wys³a³ ju¿ wszystko to powrót
	MOV	R7,#00h				;wyzeruj R7
POWROT:
	RETI
		ORG	100H

START:
	MOV	R0,#CS55D		;inicjalizacja 8255
	MOV	A,#SET_8255
	MOVX	@R0,A

	MOV	R0,#CS55A		;port A - œwiat³a dla pieszych
	MOV	R1,#CS55B		;port B - œwiat³a dla samochodów
	
	
	MOV	R0,#28H				;ustawienie rejestrów adresowych do komunikacji z 8255
	MOV	R1,#29H				;ustawienie rejestrów adresowych do komunikacji z 8255
	MOV	DPTR,#0FF2BH			;ustawienie rejestrów adresowych do komunikacji z 8255
	MOV	R7,#00H				;ustawienie pocz¹tkowej wartoœci R7
	MOV	R6,#01H				;ustawienie pêtli licznika
	MOV	A,#80H				;konfiguracja 8255
	MOVX	@DPTR,A
	MOV	A,#0FFH				;zgaszenie diod
	MOVX	@R0,A
	MOVX	@R1,A
	MOV	TH0,#0A6H			;ustawienie liczby pocz¹tkowej licznika
	MOV	TL0,#00H
	MOV	TMOD,#01H			;wybranie trybu licznika
	MOV	IE,#82H				;ustawienie przerwañ
	MOV	IP,#00H				;ustawienie priorytetów przerwañ
	MOV	TCON,#10H			;start licznika
	LJMP	$
PIESI:
		DB	0F9H			;1 - PRZEJŒCIE POZIOMO - ZIELONE, PRZEJŒCIE PIONOWO - CZERWONE
		DB	0F9H			;1 - PRZEJŒCIE POZIOMO - ZIELONE, PRZEJŒCIE PIONOWO - CZERWONE
		DB	0F9H			;1 - PRZEJŒCIE POZIOMO - ZIELONE, PRZEJŒCIE PIONOWO - CZERWONE
		DB	0F9H			;1 - PRZEJŒCIE POZIOMO - ZIELONE, PRZEJŒCIE PIONOWO - CZERWONE
		DB	0F9H			;1 - PRZEJŒCIE POZIOMO - ZIELONE, PRZEJŒCIE PIONOWO - CZERWONE
		DB	0F9H			;1 - PRZEJŒCIE POZIOMO - ZIELONE, PRZEJŒCIE PIONOWO - CZERWONE
		DB	0F9H			;1 - PRZEJŒCIE POZIOMO - ZIELONE, PRZEJŒCIE PIONOWO - CZERWONE
		DB	0F9H			;1 - PRZEJŒCIE POZIOMO - ZIELONE, PRZEJŒCIE PIONOWO - CZERWONE
		DB	0F9H			;1 - PRZEJŒCIE POZIOMO - ZIELONE, PRZEJŒCIE PIONOWO - CZERWONE
		DB	0F9H			;1 - PRZEJŒCIE POZIOMO - ZIELONE, PRZEJŒCIE PIONOWO - CZERWONE
		DB	0FBH			;2 - PRZEJŒCIE POZIOMO - ZIELONE MRUGA, PRZEJŒCIE PIONOWO - CZERWONE
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
		DB	0F6H			;5 - PRZEJŒCIE POZIOMO - CZERWONE, PRZEJŒCIE PIONOWO - ZIELONE
		DB	0F6H			;5 - PRZEJŒCIE POZIOMO - CZERWONE, PRZEJŒCIE PIONOWO - ZIELONE
		DB	0F6H			;5 - PRZEJŒCIE POZIOMO - CZERWONE, PRZEJŒCIE PIONOWO - ZIELONE
		DB	0F6H			;5 - PRZEJŒCIE POZIOMO - CZERWONE, PRZEJŒCIE PIONOWO - ZIELONE
		DB	0F6H			;5 - PRZEJŒCIE POZIOMO - CZERWONE, PRZEJŒCIE PIONOWO - ZIELONE
		DB	0F6H			;5 - PRZEJŒCIE POZIOMO - CZERWONE, PRZEJŒCIE PIONOWO - ZIELONE
		DB	0F6H			;5 - PRZEJŒCIE POZIOMO - CZERWONE, PRZEJŒCIE PIONOWO - ZIELONE
		DB	0F6H			;5 - PRZEJŒCIE POZIOMO - CZERWONE, PRZEJŒCIE PIONOWO - ZIELONE
		DB	0F6H			;5 - PRZEJŒCIE POZIOMO - CZERWONE, PRZEJŒCIE PIONOWO - ZIELONE
		DB	0F6H			;5 - PRZEJŒCIE POZIOMO - CZERWONE, PRZEJŒCIE PIONOWO - ZIELONE
		DB	0FEH			;6 - PRZEJŒCIE POZIOMO - CZERWONE, PRZEJŒCIE PIONOWO - ZIELONE MRUGA
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
		DB	0EEH			;2 - SAMOCHODY POZIOMO - ¯Ó£TE, SAMOCHODY PIONOWO - CZERWONE
		DB	0EEH
		DB	0EEH
		DB	0EEH
		DB	0EEH
		DB	0EEH
		DB	0F6H			;3 - SAMOCHODY POZIOMO - CZERWONE, SAMOCHODY PIONOWO - CZERWONE
		DB	0F6H			;3 - SAMOCHODY POZIOMO - CZERWONE, SAMOCHODY PIONOWO - CZERWONE
		DB	0F6H			;3 - SAMOCHODY POZIOMO - CZERWONE, SAMOCHODY PIONOWO - CZERWONE
		DB	0F6H			;3 - SAMOCHODY POZIOMO - CZERWONE, SAMOCHODY PIONOWO - CZERWONE
		DB	0F4H			;4 - SAMOCHODY POZIOMO - CZERWONE, SAMOCHODY PIONOWO - CZERWONE/¯Ó£TE
		DB	0F4H			;4 - SAMOCHODY POZIOMO - CZERWONE, SAMOCHODY PIONOWO - CZERWONE/¯Ó£TE
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
		DB	0F5H			;6 - SAMOCHODY POZIOMO - CZERWONE, SAMOCHODY PIONOWO - ¯Ó£TE
		DB	0F5H
		DB	0F5H
		DB	0F5H
		DB	0F5H
		DB	0F5H
		DB	0F6H			;7 - SAMOCHODY POZIOMO - CZERWONE, SAMOCHODY PIONOWO - CZEROWNE
		DB	0F6H			;7 - SAMOCHODY POZIOMO - CZERWONE, SAMOCHODY PIONOWO - CZEROWNE
		DB	0F6H			;7 - SAMOCHODY POZIOMO - CZERWONE, SAMOCHODY PIONOWO - CZEROWNE
		DB	0F6H			;7 - SAMOCHODY POZIOMO - CZERWONE, SAMOCHODY PIONOWO - CZEROWNE
		DB	0F6H			;8 - SAMOCHODY POZIOMO - CZERWONE/¯Ó£TE, SAMOCHODY PIONOWO - CZERWONE
		DB	0F6H			;8 - SAMOCHODY POZIOMO - CZERWONE/¯Ó£TE, SAMOCHODY PIONOWO - CZERWONE

;**************************************
;kolejne powtórzenie wszystkich stanów œwiate³ na skrzy¿owaniu
LOOP:
	MOV	R7,#8		;8 stanów œwiate³ na skrzy¿owaniu
	MOV	R2,#1		;stan pierwszy

;**************************************
;ustawienie kolejnego stanu œwiate³
STAN:
	MOV	A,R2		;œwiat³a dla samochodów
	ACALL	SET_AUTO	;dla stanu numer (R2)
	MOVX	@R1,A

	MOV	A,R2		;œwiat³a dla pieszych
	ACALL	SET_PEOPLE	;dla stanu numer (R2)
	MOVX	@R0,A
	MOV	R3,A		;zapamiêtaj status pieszych
	
	MOV	A,R2		;mruganie œwiate³ dla pieszych
	ACALL	SET_BLINK	;dla stanu numer (R2)
	MOV	R4,A		;zapamiêtaj status mrugania

	MOV	A,R2		;czas œwiate³ w stanie numer (R2)
	ACALL	SET_TIME	;N * 0.5 sek
	MOV	R5,A		;zapamiêtaj czas

	MOV	A,R2		;text na wyœwietlacz LCD
	ACALL	SET_TEXT	;dla stanu numer (R2)
	LCALL	LCD_CLR
	LCALL	WRITE_TEXT

;**************************************
;odliczanie czasu jednego stanu z dok³adnoœci¹ 0.5 sek
;mruganie œwiate³ dla pieszych jeœli to konieczne
;z czêstotliwoœci¹ 1Hz
BLINK:
	MOV	A,#5		
	LCALL	DELAY_100MS

	MOV	A,R3		;mruganie œwiate³ dla pieszych
	XRL	A,R4		;-zmiana stanu na przeciwne
	MOV	R3,A		;dla wybranych œwiate³
	MOVX	@R0,A

	DJNZ	R5,BLINK	;czas = R5 * 0.5 sek

	INC	R2		;kolejny stan
	DJNZ	R7,STAN

	SJMP	LOOP		;rozpocznij od pierwszego stanu

;**************************************
;dane do zapalenia œwiate³ dla samochodów w 8 kolejnych stanach
SET_AUTO:
	MOVC	A,@A+PC
	RET
	DB	11110011B,11110101B,11110110B,11100110B
	DB	11011110B,11101110B,11110110B,11110100B
	
;**************************************
;dane do zapalenia œwiate³ dla pieszych w 8 kolejnych stanach
SET_PEOPLE:
	MOVC	A,@A+PC
	RET
	DB	11110110B,11110110B,11111010B,11111010B
	DB	11111001B,11111001B,11111010B,11111010B

;**************************************
;dane do mrugania œwiate³ dla pieszych w 8 kolejnych stanach
;1-mruganie odpowiedniego œwiat³a
SET_BLINK:
	MOVC	A,@A+PC
	RET
	DB	00000000B,00001000B,00000000B,00000000B
	DB	00000000B,00000010B,00000000B,00000000B

;**************************************
;czas kolejnych stanów wyra¿ony w 0.5 sek
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
;teksty opisuj¹ce stan na skrzy¿owaniu w kolejnych stanach
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


