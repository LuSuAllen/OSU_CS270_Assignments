TITLE Program 3  
; Author: Zijing Huang
; Course / Project ID: CS 271           Date: 10/22/2018
; Description: This program asks users their name, greets them,
; then asks them to enter negative numbers between -100 and -1.
; If they write a number that's out of bounds,
; the program jumps to display the sum and the average of the numbers
; or a special message if they entered no negative numbers.



INCLUDE Irvine32.inc

.data
	nameTitle           BYTE      "This is an assembly program created by Zijing Huang (Allen)",0
	programName         BYTE      "Negative Integer Accumulator",0
	nameUser            BYTE      "What is your name? ",0
	greeting            BYTE      "Greeting, ",0
	userName            BYTE      30 DUP(0)
	userNum             DWORD     ?
	counter             DWORD     ?
	numCount            DWORD     ?	
	sum                 DWORD     0
	average             DWORD     0
	firstPrompt         BYTE      "Enter a negative number in [-100, -1]",0
	secondPrompt        BYTE      "When you are finished, enter any non-negative number.",0
	thirdPrompt         BYTE      "Input number: ",0
	enterprompt1        BYTE      "You entered ",0
	enterprompt2        BYTE      " negative numbers.",0
	sumresult           BYTE      "The sum of the total valid numbers is: ",0
	avgresult           BYTE      "The average of total the valid numbers is: ",0
	errormessage        BYTE      "There is no valid number (negative) entered.",0
	ending              BYTE      "Thank you for using this program. See you next time, ",0


;Constants to compare the user input
	MAX = -1
	MIN = -100


.code

main PROC

introduction:
     mov		edx, OFFSET programName
     call		WriteString
     call		crlf

     mov		edx, OFFSET nameTitle
     call		WriteString
     call	    crlf
	
     mov		edx, OFFSET nameUser
     call		WriteString
     call		crlf

     mov		edx, OFFSET userName
     mov		ecx, SIZEOF userName     
     call		ReadString
     mov		counter, eax

     mov		edx, OFFSET greeting
     call		WriteString
     mov		edx, OFFSET userName
     call		WriteString
     call		crlf

userInstructions:

     mov  edx, OFFSET firstPrompt
     call WriteString
     call crlf

     mov  edx, OFFSET secondPrompt
     call WriteString
     call crlf

getData:
     mov       eax, numCount
     add       eax, 1               ;keeps track of the numbers entered. If no vaild numbers, will subtract 1 from it and check if the zero flag was set
     mov       numCount, eax
     mov       edx, OFFSET thirdPrompt
     call	   WriteString
     call      ReadInt
     mov       userNum, eax

     ;compare that number with the constants
     cmp       eax, MAX
     jg        numAddition
     cmp       eax, MIN
     jl        numAddition
     add       eax, sum
     mov       sum,eax
     loop      getData        ;keeps going until they enter a number that is out of bounds


numAddition:
     mov       eax, numCount
     sub       eax, 1
     jz        farewell1           ;jumps to display the special message if no negative numbers are entered
     mov       eax, sum

     mov       edx, OFFSET enterprompt1
     call WriteString
     mov       eax, numCount
     sub       eax, 1
     call WriteDec
     mov       edx, OFFSET enterprompt2
     call WriteString
     call crlf

     mov       edx,OFFSET sumresult
     call      WriteString
     mov       eax,sum
     call      WriteInt
     call      crlf

     mov       edx,OFFSET avgresult
     call      WriteString
     mov       eax,0
     mov       eax,sum
     cdq
     mov       ebx,numCount
     sub       ebx,1
     idiv      ebx            ;Doing integer division
     mov       average,eax
     call      WriteInt
     call      crlf
     jmp       farewell2


farewell1:
     mov       edx,OFFSET errormessage
     call	   WriteString
     call	   crlf

farewell2:
     mov       edx,OFFSET ending
     call	   WriteString
     mov       edx,OFFSET userName
     call	   WriteString
     call	   crlf

exit
main      ENDP
End       main