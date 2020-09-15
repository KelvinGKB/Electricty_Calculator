INCLUDE Irvine32.inc

authentication PROTO C, ID:SDWORD, PASSWORD:SDWORD
registerAcc PROTO C, ID:SDWORD, PASSWORD:SDWORD

MAX = 100
KEY = 168 ;-----whatever number

.data

QUESTION1 BYTE "Welcome to Electicity Calculator",0
QUESTION2 BYTE "1. Login Your Account",0
QUESTION3 BYTE "2. Register Account",0
QUESTION8 BYTE "3. Exit",0
line2 BYTE       "---------------------------------",0
line BYTE        "=================================",0
T_login BYTE     "             LOGIN",0
T_register BYTE  "            REGISTER",0
QUESTION5 BYTE "Select Your Choice : ",0
QUESTION6 BYTE "Please Enter Your ID       :",0
QUESTION7 BYTE "Please Enter Your Password :",0

ERRORW BYTE "PLease Only Enter Only 1 - 3 ! Try Again !",0


ETYPE DWORD ?
ID SDWORD MAX+1 DUP (?)
PASSWORD SDWORD MAX+1 DUP (?)


.code

ACCOUNT PROC C

	MOV EDX, OFFSET line
	CALL WriteString
	CALL Crlf
    MOV EDX, OFFSET QUESTION1
	CALL WriteString
	CALL Crlf
	MOV EDX, OFFSET line
	CALL WriteString
	CALL Crlf
	MOV EDX, OFFSET QUESTION2
	CALL WriteString
	CALL Crlf
	MOV EDX, OFFSET QUESTION3
	CALL WriteString
	CALL Crlf
	MOV EDX, OFFSET QUESTION8
	CALL WriteString
	CALL Crlf
	MOV EDX, OFFSET line2
	CALL WriteString
	CALL Crlf
	MOV EDX, OFFSET QUESTION5
	CALL WriteString
	CALL ReadInt
	MOV ETYPE, EAX
	CMP ETYPE,1
	JE LOGIN
	CMP ETYPE,2
	JE REGISTER
	CMP ETYPE,3
	JE ENDPROGRAM
	JMP ERROR

LOGIN : 

		CALL Crlf
		MOV EDX, OFFSET line
		CALL WriteString
		CALL Crlf

		MOV EDX, OFFSET T_login
		CALL WriteString
		CALL Crlf
		
		MOV EDX, OFFSET line
		CALL WriteString
		CALL Crlf

		MOV EDX, OFFSET QUESTION6
		CALL WriteString
		mov EDX, OFFSET ID  ;----move address of ID
		mov ECX, MAX   ;-----pre set a size for string 
		call ReadString
		;--CALL WriteString

		MOV EDX, OFFSET QUESTION7
		CALL WriteString
		mov EDX, OFFSET PASSWORD
		mov ECX, MAX
		call ReadString

		;-----------------------Encrption of Password
		CALL Strlength  ;-----check the length of password (Store EAX)
		MOV ECX, EAX    ;--length of ECX = Length of the String
		MOV ESI, 0
	L1:
		XOR PASSWORD[esi],KEY   ;------Exclusive OR on every single word of password with KEY (ONLY 1-0 or 0-1 = 1)
		INC ESI                 ;---increase pointer
		LOOP L1

		MOV EDX, OFFSET line
		CALL WriteString
		CALL Crlf

		INVOKE authentication,OFFSET ID,OFFSET PASSWORD  ;-- call authentication() C++ function

		MOV EDX, OFFSET line
		CALL WriteString
		CALL Crlf


REGISTER : 
    
		CALL Crlf
		MOV EDX, OFFSET line
		CALL WriteString
		CALL Crlf

		MOV EDX, OFFSET T_register
		CALL WriteString
		CALL Crlf
		
		MOV EDX, OFFSET line
		CALL WriteString
		CALL Crlf

		MOV EDX, OFFSET QUESTION6
		CALL WriteString
		mov EDX, OFFSET ID
		mov ECX, MAX
		call ReadString
		;--CALL WriteString

		MOV EDX, OFFSET QUESTION7
		CALL WriteString
		mov EDX, OFFSET PASSWORD
		mov ECX, MAX
		call ReadString

		;-----------------------Encrption of Password
		CALL Strlength  ;-----check the length of password (Store EAX)
		MOV ECX, EAX    ;--length of ECX = Length of the String
		mov ESI, 0
	L2:
		XOR PASSWORD[esi],KEY    ;------Exclusive OR on every single word of password with KEY (ONLY 1-0 or 0-1 = 1)
		INC ESI                  ;---increase pointer
		LOOP L2

		MOV EDX, OFFSET line
		CALL WriteString
		CALL Crlf

		;--CALL WriteString
		CALL Crlf

     	INVOKE registerAcc,OFFSET ID,OFFSET PASSWORD   ;----call registerAcc() in c++


ERROR :
	
	;-------------display validation error message

	CALL Crlf
	MOV EDX, OFFSET ERRORW   
	CALL WriteString
	CALL Crlf
	CALL Crlf
	JMP ACCOUNT

ENDPROGRAM:

	EXIT

ACCOUNT ENDP

END