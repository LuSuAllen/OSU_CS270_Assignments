TITLE Program Program2     (program2.asm)

; Author: Zijing Huang	
; Course / Project ID: CS271    Date: 10/8/2018
; Description: Ask user name and greet. Ask for integer 1-46 for fibonacci terms and display the result.

INCLUDE Irvine32.inc

.data
;Inputs
	userName            BYTE      64 DUP(0)
	numTerms            DWORD     ?

;Data Holders
	currentFib			DWORD      ?

;Strings
	Introduction	    BYTE      "This is program2 by Zijing Huang from CS271",0
	userInstruction     BYTE      "Please enter your user name: ",0
	greeting            BYTE      "Greeting, ",0
	prompt1             BYTE      "Please the enter the number of Fibonacci terms to be displayed [integer from 1-46]: ",0
	prompt2             BYTE      "That was not valid. Please enter a integer again between 1 and 46: ",0
	quit                BYTE      "Alright, that is it.",0
	space               BYTE      "   ",0

.code
main PROC

;Introduction
     mov       edx, OFFSET Introduction	  
	 call	   WriteString
     call      CrLf

;userInstructions
     mov       edx, OFFSET userInstruction
     call      WriteString
     mov       edx, OFFSET userName                    
     mov       ecx, 64                              
     call      ReadString                              

;getUserData
     mov       edx, OFFSET greeting
     call      WriteString
     mov       edx, OFFSET userName
     call      WriteString
     call      CrLf
     mov       edx, OFFSET prompt1
     call      WriteString
     call      ReadInt
     mov       numTerms, eax
     
	 whileStart:                                       ;loop start
     cmp       eax, 46                                 ;compare the number with maximum 46
     jle       exitLoop								   ;if it's less than or equal to, continue
	 cmp	   eax, 1								   ;compare the number with minimum 1
	 jge	   exitLoop								   ;if it's greater than or equal to, continue
     mov       edx, OFFSET prompt2                     ;else, ask user to re-enter
     call      WriteString
     call      ReadInt
     mov       numTerms, eax
     jmp       whileStart                              ;re-check the number when user enter a number again
     exitLoop:

;displayFibs
     mov       eax, 1
     mov       ebx, 0
     mov       ecx, numTerms
     .IF       numTerms < 2
     call      WriteDec
     mov       edx, OFFSET space
     call      WriteString
     .ELSE
     call      WriteDec
     mov       edx, OFFSET space
     call      WriteString
     mov       eax, numTerms
     mov       ebx, 1
     sub       eax, ebx
     mov       ecx, eax
     mov       eax, 1
     mov       ebx, 0
     fibLoop:
     mov       currentFib, eax
     mov       eax, ebx
     mov       ebx, currentFib
     add       eax, ebx
     call      WriteDec
     mov       edx, OFFSET space
     call      WriteString
     loop      fibLoop
     .ENDIF
     call      CrLf

;farewell
     mov       edx, OFFSET quit
     call      WriteString
     call      CrLf
	exit	   ;exit to operating system
main ENDP

END main
