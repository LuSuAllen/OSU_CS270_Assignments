TITLE Program 4  
; Author: Zijing Huang
; Course / Project ID: CS 271           Date: 10/28/2018
; Description: This program prompts a user for a number (n) in [1, 400].
; The program will display the first "n" composite numbers and display them to the users.

INCLUDE Irvine32.inc


.data
UPPER_LIMIT = 400
LOWER_LIMIT = 1
programName		 BYTE		"Composite Numbers by Zijing Huang", 0
num_space		 BYTE		"     ", 0
description		 BYTE		"How many Composite Numbers do you want to caculate?", 0
user_ask		 BYTE		"Enter your number [1, 400]: ", 0
message_1		 BYTE		"The first ", 0
message_2		 BYTE		" composite numbers are listed below: ", 0
error_prompt	 BYTE		"The number you typed is not between 1 to 400, please try again.", 0
ending_prompt	 BYTE		"Thanks for using this program, see you next time!", 0
userNum			 DWORD		?
startNum		 DWORD		4
compNum			 DWORD		9
store	  		 DWORD		?


.code
main PROC
 call		introduction
 call		directions
 call		getUserData
 call		validate
 call		UserInputMessage
 call		showComposites
;Farewell 
 call	    farewell
 exit	;	exit to operating system
main ENDP




introduction PROC
 mov		 edx, OFFSET programName		  
 call		 WriteString
 call		 CrLf
 call		 CrLf
 ret
introduction ENDP




directions PROC
 mov		 edx, OFFSET description
 call		 WriteString
 call		 CrLf
 call		 CrLf
 ret
directions ENDP




getUserData PROC
mov			edx, OFFSET user_ask
call		WriteString
call		ReadInt
mov			userNum, eax
ret
getUserData ENDP




validate PROC
	 reAsk:
		  cmp		 userNum, UPPER_LIMIT
		  jg		 notValid
		  cmp		 userNum, LOWER_LIMIT
		  jl		 notValid
		  jmp		 next_1
	 notValid:
		  mov		 edx, OFFSET error_prompt
		  call		 WriteString
		  call		 CrLf
		  mov		 edx, OFFSET user_ask
		  call		 WriteString
		  call		 ReadInt
		  mov		 userNum, eax
		  loop		 reAsk
	 next_1:
		  ret
validate ENDP




userInputMessage PROC
		  call		 CrLf
		  mov		 edx, OFFSET message_1
		  call		 WriteString
		  mov		 eax, userNum
		  call		 WriteDec
		  mov		 edx, OFFSET message_2
		  call		 WriteString
		  call		 CrLf

		  ret
userInputMessage ENDP




showComposites PROC
		  mov		 ecx, userNum
	 countLoop:
		  call		 isComposite
		  cmp		 compNum, 0
		  je		 formatting
		  jmp		 next_2
	 formatting:
		  mov		 store, eax
		  mov		 eax, 10
		  mov		 compNum, eax
		  mov		 eax, store	 
		  call		 CrLf
	 next_2:
		  dec		 compNum
		  loop		 countLoop

		  ret
showComposites ENDP




isComposite PROC
		  mov		 eax, startNum
		  mov		 ebx, 2
	 findComposite:
		  mov		 edx, 0
		  div		 ebx
		  cmp		 edx, 0
		  je		 compositeTrue
		  inc		 ecx
		  inc		 ebx
		  cmp		 ebx, startNum
		  je		 compositeFalse
		  mov		 eax, startNum
		  loop		 findComposite
	 compositeTrue:
		  mov		 eax, startNum
		  call		 WriteDec
		  mov		 edx, OFFSET num_space
		  call		 WriteString
		  jmp		 done
	 compositeFalse:
		  inc		 compNum
	 done:
		  inc		 startNum
		  ret
isComposite ENDP




farewell PROC
		  call		 CrLf
		  mov		 edx, OFFSET ending_prompt
		  call		 WriteString
		  call		 CrLf

		  ret
farewell ENDP

END main