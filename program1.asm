TITLE Program1     (program1.asm)
; Author: Zijing Huang
; Course / Project ID: CS271       Date:10/1/2018
; Description: Display the name and title of the program, then ask user for two numbers for sum, difference, product and quotient

INCLUDE Irvine32.inc

.data
	intro		BYTE	"Program 1 by Sean Reilly",0
	discrip 	BYTE	"This program will take 2 numbers that you enter and calcualte the sum, difference, product and quotient",0
	num1		DWORD	?	;Int #1 to be entered by user
	num2		DWORD	?	;Int #2 to be entered by user
	string1		BYTE	"Please enter the first number now: ",0
	string2		BYTE	"Please enter the second number now (less than or equal to the first): ",0
	sum			DWORD	?	;calcualtes sum of number 1 and number 2
	difference	DWORD	?	;calculates the difference of number 1 and number 2
	product		DWORD	?	;calculates the product of number 1 and number 2
	quotient	DWORD	?	;calculates the quotient of number 1 and number 2
	remainder	DWORD	?	;calculates the remainder of the quotient of number 1 and number 2
	caculation	BYTE	"The results are the following:  ",0
	numsum		BYTE	"The sum is: ",0
	numdif		BYTE	"The difference is: ",0
	numpro		BYTE	"The product is: ",0
	numquo		BYTE	"The quotient is: ",0
	numrem		BYTE	"The quotient has a remainder of: ",0
	ending		BYTE	"Okay bye!",0

.code
	main PROC

;the name and the title of program
	mov		edx, OFFSET	intro
	call	WriteString
	call	CrLf

;prompt
	mov		edx, OFFSET discrip
	call	WriteString
	call	CrLf

L1:

;enter 2 numbers
	mov		edx, OFFSET string1
	call	WriteString
	call	ReadInt
	mov		num1, eax
	call	CrLf
	mov		edx, OFFSET string2
	call	WriteString
	call	ReadInt
	mov		num2, eax
	call	CrLf

	cmp		eax, num1 ;extra credit
	jg		L1

;the sum of 2 num
	mov		eax, num1
	add		eax, num2 
	mov		sum, eax

;print the sum
	mov		edx, OFFSET numsum	
	call	WriteString
	mov		edx, OFFSET sum
	call	WriteInt
	call	CrLf

;the difference between 2 num
	mov		eax, num1
	mov		ebx, num2
	sub		eax, ebx
	mov		difference, eax

;print the difference
	mov		edx, OFFSET	numdif
	call	WriteString
	mov		edx, OFFSET difference
	call	WriteInt
	call	CrLf

;the production of 2 num
	mov		eax, num1 
	mov		ebx, num2
	mul		ebx
	mov		product, eax

;print the product
	mov		edx, OFFSET numpro
	call	WriteString
	mov		edx, OFFSET product
	call	WriteInt
	call	CrLf

;calculate the quotient and remainder
	
	mov		eax, num1
	mov		ebx, num2
	mov		edx, 0
	idiv	ebx
	mov		quotient, eax
	mov		remainder, edx
	
;print quotient
	mov		edx, OFFSET numquo
	call	WriteString
	mov		edx, OFFSET quotient
	call	WriteInt
	call	CrLf

;print remainder
	mov		edx, OFFSET numrem
	call	WriteString
	mov		edx, OFFSET remainder
	call	WriteInt
	call	CrLf

;print ending
	mov		edx, OFFSET ending
	call	WriteString
	call	CrLf

; exit to operating system
	exit

main ENDP

END main