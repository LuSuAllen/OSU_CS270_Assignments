TITLE Programming 6 Option A    (program6a.asm)

; Author: Zijing Huang
; Course / Project ID: CS 271           Date: 11/25/2018
; Description: Ask users for numbers of random numbers they want to generate then display them in sorted order with median.

INCLUDE Irvine32.inc



;constant value
userInput = 10								;The number of userInput



;Macros
displayString  MACRO	string              ;Based on Lecture 26
     push      edx                          ;Save edx register
     mov       edx, OFFSET string
     call      WriteString
     pop       edx                          ;Restore edx
ENDM



getString      MACRO	var, string         ;Based on Lecture 26
     push      ecx
     push      edx
     displayString	string                  ;Ask the user to enter a string
     mov       edx, OFFSET var              ;place to store it
     mov       ecx, (SIZEOF var) - 1                                        
     call      ReadString
     pop       edx
     pop       ecx
ENDM



.data
;Inputs
array               DWORD     userInput DUP(?)
input               BYTE      20 DUP(?)
inputLength         DWORD     0
number              DWORD     ?
count               DWORD     0
sum                 DWORD     0

;Strings
programIntro        BYTE      "PROGRAMMING ASSIGNMENT 6: Designing low-level I/O procedures",0
authorIntro		    BYTE      "Written by: Zijing Huang", 0
endingString	    BYTE      "Thanks for playing!", 0
userInstruction1	BYTE	  "Please provide 10 unsigned decimal integers. Each number needs to be small enough to fit inside a 32 bit register. ", 0
userInstruction2	BYTE	  "After you have finished inputting the raw numbers I will display a list of the integers, their sum, and their average value. ", 0
userInstruction3    BYTE      "Please enter an unsigned number: ", 0
notAInt             BYTE      "That's either not an integer or not unsigned. Please try again: ",0
resultSum			BYTE      "The sum of your numbers is: ",0
resultAvg			BYTE	  "The average of your numbers is: ",0
comma               BYTE      ", ",0
enteredNumbers      BYTE      "You entered the following numbers: ",0

.code
main PROC
     call      Introduction                  ;Introduce program

     mov       ecx, userInput                ;Counter to get 10 numbers
     GetVars:
     push      OFFSET array                  ;Push the array onto the stack
     push      count                         ;Push the current count onto the stack
     call      ReadVal                       ;Call the ReadVal procedure
     inc       count               
     loop      GetVars
         
     call      CrLf 
     
     displayString	enteredNumbers         
     push      OFFSET array                  ;push the array onto the stack
     push      userInput                     ;push the size of the array onto the stack
     call      WriteVal
     
     call CrLf     

     push	   OFFSET array                  ;Push the array into the stack
     push	   userInput                     ;Push the size of the array into the stack
     push	   sum
     call      calculateSum                  ;Calculate the sum

     push      sum                           ;Push the sum into the stack
     push      userInput                     ;Push the size of the array into the stack
     call      calculateAverage              ;Calculate the average

     call      CrLf
     call      programExit
     exit
main ENDP



introduction PROC
     displayString	programIntro
     call      CrLf
     displayString	authorIntro
     call      CrLf
	 displayString	userInstruction1
	 call	   Crlf
	 displayString	userInstruction2
	 call	   Crlf
     ret
introduction ENDP



ReadVal PROC
     pushad
     mov       ebp, esp
     top:
     mov       eax, [ebp+36]                 ;set eax to the current counter
     inc	   eax                       
     call      WriteDec
	 displayString comma
     getString input, userInstruction3
     jmp       validate                      ;go to validate the numbers

     redo:                                   ;if somewhere in validation broke, jump here
     getString input, notAInt

     validate:
     mov       inputLength, eax
     mov       ecx, eax
     mov       esi, OFFSET input
     mov       edi, OFFSET number

     reloop:                                
     lodsb
     cmp       al,48                         
     jl        notUnsignedInt                ;if it's less than 48, it's not an integer
     cmp       al,57
     jg        notUnsignedInt                ;if it's greater then 57, it's not an integer
     loop      reloop
     jmp       isUnsignedInt

     notUnsignedInt:                                 
     jmp       redo                          ;Grab another number

     isUnsignedInt:
     mov       edx, OFFSET input
     mov       ecx, inputLength
     call      ParseDecimal32                    
     .IF CARRY?                              ;ParseDecimal32 will set the carry flag if it's bigger than allowable size
     jmp       redo                          ;and if it is, go grab another number
     .ENDIF
     mov       edx, [ebp+40]                 ;move into edx the array
     mov       ebx, [ebp+36]                 ;move into ebx the current count
     imul      ebx, 4                        ;multiply the count by size of dword to see where to place it
     mov       [edx+ebx], eax                ;put the value into the array

     endIt:
     popad
     ret       8
ReadVal ENDP



WriteVal PROC
     push      ebp
     mov       ebp, esp
     mov       edi, [ebp+12]
     mov       ecx, [ebp+8]

     theLoop:
     mov       eax, [edi]
     call      WriteDec
     cmp       ecx, 1                        ;if ecx is = to 1, then no comma needed after the number
     je        noComma                       
     displayString comma
     add       edi, 4
     noComma:
     loop      theLoop

     pop       ebp
     ret       8
WriteVal ENDP



calculateSum PROC
     push      ebp
     mov       ebp, esp
     mov       edi, [ebp+16]
     mov       ecx, [ebp+12]
     mov       ebx, [ebp+8]

     theLoop:
     mov       eax, [edi]          ;move the number into eax
     add       ebx, eax            ;add eax to the sum
     add       edi, 4              ;move on to the next one
     loop      theLoop
     
     displayString	resultSum
     mov       eax, ebx
     call      WriteDec
     call      CrLf
     mov       sum, ebx
     pop       ebp
     ret       12
calculateSum ENDP



calculateAverage PROC
     push      ebp
     mov       ebp, esp
     mov       eax, [ebp+12]
     mov       ebx, [ebp+8]
     mov       edx, 0              ;setting up division

     idiv      ebx                 ;doing the division

     displayString	resultAvg

     call      WriteDec

     pop ebp
     ret 8
calculateAverage ENDP



programExit PROC
     displayString	endingString
     call      CrLf
     ret
programExit ENDP

END main