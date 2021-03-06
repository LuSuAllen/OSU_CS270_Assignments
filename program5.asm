TITLE Programming Assignment 5    (assignment5.asm)

; Author: Zijing Huang
; Course / Project ID: CS 271           Date: 11/11/2018
; Description: Ask users for numbers of random numbers they want to generate then display them in sorted order with median.

INCLUDE Irvine32.inc

;constant value
min  =   10
max  =   200
lo   =   100
hi   =   999

.data
;Inputs
array               DWORD     max       DUP(?)
numElements         DWORD     ?
ecxHolder           DWORD     ?
median              DWORD     ?
counter             DWORD     ?

;Strings
programIntro        BYTE      "Greetings! This is Random Integers Generater powered by Zijing Huang",0
programExit         BYTE      "This is the end of the program, thank you for using.",0
userInstruction     BYTE      "Enter the number of random integers to display (10-200): ",0
outOfRange          BYTE      "Your input is not valid. Please try again",0
tripleSpace         BYTE      "   ",0
unsortedString      BYTE      "The random numbers are: ",0
sortedString        BYTE      "After being sorted: ",0
medianString        BYTE      "The median is: ",0

.code
main PROC
     call      Randomize                     ;Seed the random numbers
     call      introduction                  ;Call the intro

     push      numElements
     call      getUserData

     push      OFFSET array
     push      numElements
     call      fillArray                     ;Call fillArray after the preconditions are pushed onto stack

     mov       edx, OFFSET unsortedString
     call      WriteString
     call      CrLf
     push      OFFSET array
     push      numElements
     push      counter
     call      displayList                   ;Call displayList after the preconditions are pushed onto stack

     push      OFFSET array
     push      numElements
     call      sortList                      ;Call sortList after the preconditions are pushed onto the stack

     push      OFFSET array
     push      numElements
     call      displayMedian                 ;Call displayMedian after the preconditions are pushed onto the stack

     mov       edx, OFFSET sortedString
     call      WriteString
     call      CrLf
     push      OFFSET array
     push      numElements
     push      counter
     call      displayList                   ;Call displayList after the preconditions are pushed onto the stack

     call      farewell
	 exit
main ENDP



introduction PROC
     mov       edx, OFFSET programIntro 
     call      WriteString
     call      CrLf
     ret
introduction ENDP



getUserData PROC
     push      ebp
     mov       ebp, esp
     mov       edi, [ebp+8]                                 ;numElements into edi
     mov       edx, OFFSET userInstruction
     call      WriteString
     call      ReadInt
     .IF eax > max                                          ;If the input is greater than the max value
     mov       edx, OFFSET outOfRange
     call      WriteString
     call      CrLf
     call      getUserData
     .ENDIF
     .IF eax < min                                          ;If the input is less than the min value
     mov       edx, OFFSET outOfRange
     call      WriteString
     call      CrLf
     call      getUserData
     .ENDIF
     mov       numElements, eax

     pop       ebp
     ret       4
getUserData ENDP



fillArray PROC
     push      ebp
     mov       ebp, esp
     mov       edi, [ebp+12]                 ;address of array in edi
     mov       ecx, [ebp+8]                  ;address of numElements in ecx         
     generateInt:
     mov       eax, 900
     call      RandomRange
     add       eax, lo                       ;Since we did 0-899 random number, add 100 to make it 100-999
     mov       [edi], eax                    ;Put it into the array
     add       edi, 4                        ;Move to the next item in the array
     loop	   generateInt

     pop       ebp
     ret       8
fillArray ENDP



displayList PROC
     push      ebp
     mov       ebp, esp
     mov       edi, [ebp+16]                 ;address of array in edi
     mov       ecx, [ebp+12]                 ;address of numElements in ecx
     mov       ebx, [ebp+8]                  ;number of integers on line counter
     display:
     inc       ebx                           ;increase counter
     cmp       ebx, 10                       ;check the number of integers output to the current line
     jle       currLine                      ;if it's less than 10, jump to currLine
     mov       ebx, 1                        ;otherwise, reset the counter
     call      CrLf                          ;new line

     currLine:
     mov       eax, [edi]                    
     call      WriteDec
     mov       edx, OFFSET tripleSpace
     call      WriteString
     add       edi, 4                        ;Move to the next value in the array
     loop display

     call      CrLf

     pop       ebp
     ret       16
displayList ENDP



displayMedian PROC
     push      ebp
     mov       ebp, esp
     mov       edi, [ebp+12]
     mov       ecx, [ebp+8]

     test      ecx, 1
     .IF zero?                                    ;if it's an even number
     mov       edx, 0                             ;setup division
     mov       eax, ecx                           
     mov       ebx, 2
     idiv      ebx                                ;divide the array into 2
     mov       ecx, eax                           
     mov       eax, [edi + 4 * ecx]               ;grab one of the middle numbers
     dec       ecx
     mov       ebx, [edi + 4 * ecx]               ;grab the other
     add       eax, ebx                           ;add them together
     mov       edx, 0
     mov       ebx, 2
     idiv      ebx                                ;get the average
     shr       ebx, 1                             
     .IF       edx >= ebx                         ;check if we need to round up 
     inc       eax
     .ENDIF
     .ELSE                                        ;if it's an odd number
     mov       edx, 0         
     mov       eax, ecx
     mov       ebx, 2
     idiv      ebx                                ;find the index of the middle value
     mov       ecx, eax
     mov       eax, [edi + 4 * ecx]               ;set eax to the middle value
     .ENDIF
     mov       edx, OFFSET medianString
     call      WriteString
     call      WriteDec
     call      CrLf


     pop       ebp
     ret       8
displayMedian ENDP



sortList PROC
     push      ebp
     mov       ebp, esp
     mov       ecx, [ebp+8]
     dec       ecx

     L1:
     mov       edi, [ebp+12]
     mov       ecxHolder, ecx

     L2: 
     mov       eax, [edi]
     cmp       [edi+4], eax                       ;compare the 2 values together
     jg        L3                                 ;if the number at the higher index is less, then jump to L3
     xchg      eax, [edi+4]                       ;otherwise swap the numbers
     mov       [edi], eax
     
     L3:
     add       edi, 4                             ;move on to the next one
     loop      L2                                 ;jump back up to L2 and check again
     
     mov       ecx, ecxHolder
     loop      L1                                 ;jump to the top of the loop to make sure to go through the array n-1 times. 
     
     L4:      
     pop       ebp
     ret       8
sortList ENDP



farewell PROC
     mov       edx, OFFSET programExit 
     call      WriteString
     call      CrLf
     ret
farewell ENDP

END main