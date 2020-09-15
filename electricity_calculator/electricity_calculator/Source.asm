INCLUDE Irvine32.inc


receipt PROTO C, usage:SDWORD,total:SDWORD,etype:SDWORD
history PROTO C, usage:SDWORD,total:SDWORD,etype:SDWORD
convertDigit PROTO C, usage:SDWORD
panel PROTO C

.data

RESIDENTIALRATE BYTE "                       RESIDENTIAL RATE",0
F200R BYTE "For the first 200kWh (   1-200kWh   ) per month = 0.218 RM/kWh",0
F300R BYTE "For the next 100kWh  (  201-300kWh  ) per month = 0.334 RM/kWh",0
F600R BYTE "For the next 300kWh  (  301-600kWh  ) per month = 0.516 RM/kWh",0
F900R BYTE "For the next 300kWh  (  601-900kWh  ) per month = 0.546 RM/kWh",0
F901R BYTE "For the next kWh     (901kWh onwards) per month = 0.571 RM/kWh",0

COMMERCIALRATE BYTE "                       COMMERCIAL RATE",0
F200C BYTE "For the first 200kWh (   1-200kWh   ) per month = 0.318 RM/kWh",0
F300C BYTE "For the next 100kWh  (  201-300kWh  ) per month = 0.434 RM/kWh",0
F600C BYTE "For the next 300kWh  (  301-600kWh  ) per month = 0.616 RM/kWh",0
F900C BYTE "For the next 300kWh  (  601-900kWh  ) per month = 0.646 RM/kWh",0
F901C BYTE "For the next kWh     (901kWh onwards) per month = 0.721 RM/kWh",0


QUESTION1 BYTE "PLEASE ENTER YOUR USAGE OF ELECTRICITY                              : ",0
QUESTION2 BYTE "PLEASE ENTER YOUR ELECTRICITY TYPE (RESIDENTIAL : 1, COMMERCIAL : 2): ",0
QUESTION3 BYTE "1.CALCULATE ANOTHER BILL ",0
QUESTION7 BYTE "2.Print Receipt ",0
QUESTION4 BYTE "3.EXIT ",0
QUESTION5 BYTE "PLEASE ENTER YOUR SELECTION : ",0

line1 BYTE "===============================",0
line2 BYTE "-------------------------------",0
line3 BYTE "---------------------------------------------------------------",0


T_calculator BYTE "    ELECTRICITY CALCULATOR",0

Digit_Validation BYTE "Invalid Entry ! PLEASE ENTER ONLY DIGIT !",0
Entry_Validation BYTE "Invalid Entry ! PLEASE ENTER ONLY 1 - 3 !",0

DISPLAY_RESULT BYTE "      ELECTRICITY BILL",0
DISPLAY_TAX BYTE   "TAX(10%)         : RM ",0
DISPLAY_TOTAL BYTE "TOTAL AMOUNT     : RM ",0
DISPLAY_FEE BYTE   "SUB TOTAL        : RM ",0
DISPLAY_TYPE BYTE  "ELECTRICITY TYPE : ",0

TYPE1 BYTE "RESIDENTIAL",0
TYPE2 BYTE "COMMERCIAL",0

ZERO BYTE "0",0

ETYPE DWORD ?
SELECTION DWORD ?
DECPOINT BYTE ".",0
USAGE  DWORD ?
FUSAGE  DWORD ?
RESULT DWORD ?
T_RESULT DWORD ?
FRESULT DWORD ?
TAX DWORD ?
KWH DWORD ?
QUOTIENT DWORD ?
REMAIDER DWORD ?


.code

START PROC C
    
	CALL Crlf
	MOV EDX, OFFSET line1
	CALL WriteString
	CALL Crlf
	MOV EDX, OFFSET T_calculator
	CALL WriteString
	CALL Crlf
	MOV EDX, OFFSET line1
	CALL WriteString
	CALL Crlf

    MOV EDX, OFFSET QUESTION2
	CALL WriteString
	CALL ReadInt

	MOV ETYPE, EAX
	CMP ETYPE,1
	JE RESIDENTIAL
	CMP ETYPE,2
	JE COMMERCIAL
	JMP START

RESIDENTIAL:
	
	;---------------------Display the Residential Rate
	CALL Crlf
	MOV EDX, OFFSET line3
	CALL WriteString
	CALL Crlf
	MOV EDX, OFFSET RESIDENTIALRATE
	CALL WriteString
	CALL Crlf
	MOV EDX, OFFSET line3
	CALL WriteString
	CALL Crlf
	MOV EDX, OFFSET F200R
	CALL WriteString
	CALL Crlf
	MOV EDX, OFFSET F300R
	CALL WriteString
	CALL Crlf
	MOV EDX, OFFSET F600R
	CALL WriteString
	CALL Crlf
	MOV EDX, OFFSET F900R
	CALL WriteString
	CALL Crlf
	MOV EDX, OFFSET F901R
	CALL WriteString
	CALL Crlf
	MOV EDX, OFFSET line3
	CALL WriteString
	CALL Crlf
	CALL Crlf


	;------------------------------prompt questions
	MOV EDX, OFFSET QUESTION1
	CALL WriteString
    MOV EDX, OFFSET USAGE
	MOV ECX,100
	call ReadString

	CALL Strlength  ;-----check the length of USAGE
	MOV ECX, EAX
	MOV ESI, 0

		;------------------------Only Digit Validation
L1:
	MOV EAX, USAGE[esi]
	CALL IsDigit
	JNZ notDigit
	INC ESI
	LOOP L1

	MOV EDX, OFFSET line1
	CALL WriteString
	CALL Crlf

	INVOKE convertDigit,OFFSET USAGE

	MOV USAGE,EAX
	MOV FUSAGE,EAX
	CMP USAGE, 200
	JLE R200KWH
	CMP USAGE,300
	JLE R300KWH
	CMP USAGE,600
	JLE R600KWH
	CMP USAGE,900
	JLE R900KWH
	CMP USAGE,900
	JG R901KWH
	JMP RESIDENTIAL


COMMERCIAL:

	;---------------------Display the Commercial Rate
	CALL Crlf
	MOV EDX, OFFSET line3
	CALL WriteString
	CALL Crlf
	MOV EDX, OFFSET COMMERCIALRATE
	CALL WriteString
	CALL Crlf
	MOV EDX, OFFSET line3
	CALL WriteString
	CALL Crlf
	MOV EDX, OFFSET F200C
	CALL WriteString
	CALL Crlf
	MOV EDX, OFFSET F300C
	CALL WriteString
	CALL Crlf
	MOV EDX, OFFSET F600C
	CALL WriteString
	CALL Crlf
	MOV EDX, OFFSET F900C
	CALL WriteString
	CALL Crlf
	MOV EDX, OFFSET F901C
	CALL WriteString
	CALL Crlf
	MOV EDX, OFFSET line3
	CALL WriteString
	CALL Crlf
	CALL Crlf

	;------------------------------prompt questions
	MOV EDX, OFFSET QUESTION1
	CALL WriteString
	mov EDX, OFFSET USAGE
	MOV ECX,100
	call ReadString

	CALL Strlength  ;-----check the length of USAGE
	MOV ECX, EAX
	MOV ESI, 0

		;------------------------Only Digit Validation
L2:
	MOV EAX, USAGE[esi]
	CALL IsDigit
	JNZ notDigit
	INC ESI
	LOOP L2

	MOV EDX, OFFSET line1
	CALL WriteString
	CALL Crlf
		        
 	INVOKE convertDigit,OFFSET USAGE

	MOV USAGE,EAX
	MOV FUSAGE,EAX
	CMP USAGE, 200
	JLE C200KWH
	CMP USAGE,300
	JLE C300KWH
	CMP USAGE,600
	JLE C600KWH
	CMP USAGE,900
	JLE C900KWH
	CMP USAGE,900
	JG C901KWH
	JMP COMMERCIAL

R200KWH:
	
	;--------------RESULT = USAGE * 0.218
	MOV EAX, USAGE
	MOV KWH, 2180
	MUL KWH
	MOV FRESULT,EAX
	MOV RESULT, 10000
	DIV RESULT
	MOV QUOTIENT, EAX
	MOV REMAIDER, EDX

	JMP DISPLAY

R300KWH:

	;--------------RESULT = 43.6 + (USAGE - 200 ) * 0.334
	SUB USAGE, 200
	MOV EAX, USAGE
	MOV KWH , 3340
	MUL KWH
	ADD EAX,436000
	MOV FRESULT,EAX
	MOV RESULT, 10000
	DIV RESULT
	MOV QUOTIENT, EAX
	MOV REMAIDER, EDX

	JMP DISPLAY

R600KWH:

	;--------------RESULT = 77 + (USAGE - 300 ) * 0.516
	SUB USAGE, 300
	MOV EAX, USAGE
	MOV KWH , 5160
	MUL KWH
	ADD EAX,770000
	MOV FRESULT,EAX
	MOV RESULT, 10000
	DIV RESULT
	MOV QUOTIENT, EAX
	MOV REMAIDER, EDX

	JMP DISPLAY

R900KWH:

	;--------------RESULT = 231.8 + (USAGE - 600 ) * 0.546
	SUB USAGE, 600
	MOV EAX, USAGE
	MOV KWH , 5460
	MUL KWH
	ADD EAX,2318000
	MOV FRESULT,EAX
	MOV RESULT, 10000
	DIV RESULT
	MOV QUOTIENT, EAX
	MOV REMAIDER, EDX

	JMP DISPLAY

R901KWH:

	;--------------RESULT = 395.6 + (USAGE - 900 ) * 0.571
	SUB USAGE, 900
	MOV EAX, USAGE
	MOV KWH , 5710
	MUL KWH
	ADD EAX,3956000
	MOV FRESULT,EAX
	MOV RESULT, 10000
	DIV RESULT
	MOV QUOTIENT, EAX
	MOV REMAIDER, EDX

	JMP DISPLAY

C200KWH:
	
	;--------------RESULT = USAGE * 0.318
	MOV EAX, USAGE
	MOV KWH, 3180
	MUL KWH
	MOV FRESULT,EAX
	MOV RESULT, 10000
	DIV RESULT
	MOV QUOTIENT, EAX
	MOV REMAIDER, EDX

	JMP DISPLAY

C300KWH:

	;--------------RESULT = 63.6 + (USAGE - 200 ) * 0.434
	SUB USAGE, 200
	MOV EAX, USAGE
	MOV KWH , 4340
	MUL KWH
	ADD EAX,636000
	MOV FRESULT,EAX
	MOV RESULT, 10000
	DIV RESULT
	MOV QUOTIENT, EAX
	MOV REMAIDER, EDX

	JMP DISPLAY

C600KWH:

	;--------------RESULT = 107 + (USAGE - 300 ) * 0.616
	SUB USAGE, 300
	MOV EAX, USAGE
	MOV KWH , 6160
	MUL KWH
	ADD EAX,1070000
	MOV FRESULT,EAX
	MOV RESULT, 10000
	DIV RESULT
	MOV QUOTIENT, EAX
	MOV REMAIDER, EDX

	JMP DISPLAY

C900KWH:

	;--------------RESULT = 291.8 + (USAGE - 600 ) * 0.646
	SUB USAGE, 600
	MOV EAX, USAGE
	MOV KWH , 6460
	MUL KWH
	ADD EAX,2918000
	MOV FRESULT,EAX
	MOV RESULT, 10000
	DIV RESULT
	MOV QUOTIENT, EAX
	MOV REMAIDER, EDX

	JMP DISPLAY

C901KWH:

	;--------------RESULT = 485.6 + (USAGE - 900 ) * 0.721
	SUB USAGE, 900
	MOV EAX, USAGE
	MOV KWH , 7210
	MUL KWH
	ADD EAX,4856000
	MOV FRESULT,EAX 
	MOV RESULT, 10000    ;--- EAX = EAX / RESULT
	DIV RESULT
	MOV QUOTIENT, EAX
	MOV REMAIDER, EDX

	JMP DISPLAY

DISPLAY:
    
	Call Crlf
	MOV EDX, OFFSET line1
	CALL WriteString
	Call Crlf

	MOV EDX, OFFSET DISPLAY_RESULT
	CALL WriteString
	Call Crlf

	MOV EDX, OFFSET line1
	CALL WriteString
	Call Crlf

	MOV EDX, OFFSET DISPLAY_TYPE
	CALL WriteString
	MOV EAX,ETYPE
	.IF EAX == 1
	MOV EDX, OFFSET TYPE1
	CALL WriteString
	Call Crlf
	.ELSE
	MOV EDX, OFFSET TYPE2
	CALL WriteString
	Call Crlf
	.ENDIF

	;--------DISPLAY QUOTIENT
	MOV EDX, OFFSET DISPLAY_FEE
	CALL WriteString
	MOV EAX, QUOTIENT
	CALL WriteDec

	;--------DISPLAY DECIMAL POINT
	MOV EDX, OFFSET DECPOINT
	CALL WriteString

	;--------DISPLAY REMAIDER
	MOV EAX, REMAIDER
	.IF(EAX < 1000)
	 MOV EDX, OFFSET ZERO
	 CALL WriteString
	.ENDIF
	CALL WriteDec
	CALL Crlf

TAXCALCULATION:

	;--------Calculate TAX
	xor eax, eax
	xor edx, edx
	MOV EAX, FRESULT
	MOV TAX,10
	DIV TAX
	MOV T_RESULT, EAX ;-----4360 (Result 10% = TAX)
	MOV TAX,10000
	DIV TAX
	MOV QUOTIENT, EAX
	MOV REMAIDER, EDX

	;--------DISPLAY QUOTIENT
	MOV EDX, OFFSET DISPLAY_TAX
	CALL WriteString
	MOV EAX, QUOTIENT
	CALL WriteDec

	;--------DISPLAY DECIMAL POINT
	MOV EDX, OFFSET DECPOINT
	CALL WriteString

	;--------DISPLAY REMAIDER
	MOV EAX, REMAIDER
	.IF(EAX < 1000)
	 MOV EDX, OFFSET ZERO
	 CALL WriteString
	.ENDIF
	CALL WriteDec
	CALL Crlf

	
ADDTAX:

	;----------Add TAX
	xor eax, eax
	xor edx, edx
	MOV EAX, T_RESULT  ;------ Result 10%
	ADD EAX, FRESULT ;------ RESULT x 1.10 %
	MOV TAX,10000
	DIV TAX
	MOV QUOTIENT, EAX
	MOV REMAIDER, EDX
	
	MOV EDX, OFFSET line2
	CALL WriteString
	CALL Crlf

	;--------DISPLAY QUOTIENT
	MOV EDX, OFFSET DISPLAY_TOTAL
	CALL WriteString
	MOV EAX, QUOTIENT
	CALL WriteDec

	;--------DISPLAY DECIMAL POINT
	MOV EDX, OFFSET DECPOINT
	CALL WriteString

	;--------DISPLAY REMAIDER
	MOV EAX, REMAIDER
	.IF(EAX < 10)
	 MOV EDX, OFFSET ZERO
	 CALL WriteString
	.ENDIF
	CALL WriteDec
	CALL Crlf

	INVOKE history,FUSAGE, FRESULT,ETYPE

 
ENDMENU : 
	
	MOV EDX, OFFSET line1
	CALL WriteString
	CALL Crlf
	MOV EDX, OFFSET QUESTION3
	CALL WriteString
	CALL Crlf
	MOV EDX, OFFSET QUESTION7
	CALL WriteString
	CALL Crlf
	MOV EDX, OFFSET QUESTION4
	CALL WriteString
	CALL Crlf
	MOV EDX, OFFSET line2
	CALL WriteString
	CALL Crlf
	MOV EDX, OFFSET QUESTION5
	CALL WriteString
	CALL ReadInt
	MOV EDX, OFFSET line1
	CALL WriteString
	CALL Crlf
	CALL Crlf
	MOV SELECTION, EAX
	CMP SELECTION,1
	JE START
	CMP SELECTION,2
	JE PRINT
	CMP SELECTION,3
	JE BACKPANEL
	MOV EDX, OFFSET Entry_Validation
	CALL WriteString
	Call Crlf
	JMP ENDMENU

PRINT:
	
	INVOKE receipt,FUSAGE, FRESULT, ETYPE

BACKPANEL:

	INVOKE panel

notDigit:

	Call Crlf
	MOV EDX, OFFSET Digit_Validation
	CALL WriteString
	Call Crlf

	CMP ETYPE,1
	JE RESIDENTIAL
	CMP ETYPE,2
	JE COMMERCIAL
	

ENDPROGRAM:

		 EXIT

START ENDP

END