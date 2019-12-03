TITLE Program 4 (main.asm)

;Author:		Blayne Porterfield
;Program:		Assembler Program 4
;Date:			11/11/2019
;Version:		1.0
;Description:	puts 20 positive integers into the array, displays ten on each row, searchs for user inputted numbers until negative number is inserted

INCLUDE irvine32.inc

.data
prompt1			BYTE		"Please enter integer #",0
prompt2			BYTE		":",0
errorPrompt		BYTE		"The integer is not valid.  Only non-negative values are accepted",0
searchPrompt	BYTE		"Please enter an integer to search for (a negative integer to exit): ",0
array			DWORD		20 DUP(?)
foundPrompt1	BYTE		"The integer ",0
foundPrompt2	BYTE		" was found in the list at position ",0
notFoundPrompt	BYTE		"The number you were looking for is not in the list",0
NUM_ELEMENTS	DWORD		20

.code
main			PROC
				
				call		Clrscr	
				mov			ecx, 0
				mov			eax, 0
				mov			ebx, 0
				push		NUM_ELEMENTS
				push		OFFSET array
				push		TYPE array
				call		getInput
				push		OFFSET array
				push		TYPE array
				call		printList
begSearch:													;displays search prompt and checks for negative number for exit
				mov			edx,OFFSET searchPrompt
				call		WriteString
				call		ReadInt
				cmp			eax, 0
				jl			quitSearch
				push		OFFSET array
				push		TYPE array
				push		NUM_ELEMENTS
				call		search
				jmp			begSearch


quitSearch:
				exit

main			ENDP
				



getInput		PROC							;uses OFFSET array, TYPE array, and NUM_ELEMENTS to getInput into the array from the user
				
				push		ebp
				mov			ebp, esp
				push		eax					;preserves registers
				push		ebx
				push		ecx
				push		edi
				push		edx
				mov			eax, 0
				mov			ebx, 0
				mov			ecx, DWORD PTR [ebp+16]
				lea			edi, array
BeginInput:		lea			edx, prompt1
				call		WriteString
				mov			eax, ebx
				add			eax, ecx
				sub			eax, ecx
				inc			eax
				mov			ebx, eax
				call		WriteDec
				lea			edx, prompt2
				call		WriteString
				call		ReadInt
				cmp			eax, 0
				jge			numGood

				lea			edx, errorPrompt				;error message for wrongly inputted integer
				call		writeString
				call		Crlf
				dec			ebx
				jmp			BeginInput

NumGood:		mov			DWORD PTR [edi], eax			;inputs number into array
				add			edi, DWORD PTR [ebp+8]
				loop		BeginInput
				pop			edx								;restore registers
				pop			edi
				pop			ecx
				pop			ebx
				pop			eax
				pop			ebp
				ret			12

getInput		ENDP




printList		PROC									;uses OFFSET array and TYPE array to print the array into two lists

				push		ebp
				mov			ebp, esp
				push		edi							;preserves registers
				push		ecx
				push		eax
				mov			edi, DWORD PTR [ebp+12]
				mov			ecx, 10

first10:		mov			eax, DWORD PTR [edi]
				call		WriteDec
				mov			al, ' '
				call		WriteChar
				add			edi, TYPE array
				loop		first10

				call		Crlf
				mov			ecx, 10

last10:			mov			eax,DWORD PTR [edi]
				call		WriteDec
				mov			al, ' '
				call		WriteChar
				add			edi, TYPE array
				loop		last10

				call		Crlf
				pop			eax							;preserve registers
				pop			ecx
				pop			edi
				pop			ebp
				ret			8


printList		ENDP




search			PROC								;uses TYPE array, OFFSET array, and NUM_ELEMENTS to search through the array for a number

				push		ebp
				mov			ebp,esp
				push		esi						;preserves registers
				push		eax
				push		ecx
				push		edx
				mov			esi, DWORD PTR [ebp+16]
				mov			ecx, DWORD PTR [ebp+8]

SearchLoop:
			

				cmp			DWORD PTR [esi], eax
				jne			KeepGoing
				lea			edx, foundPrompt1
				call		WriteString
				call		WriteDec
				lea			edx, foundPrompt2
				call		WriteString
				mov			eax, DWORD PTR [ebp+8]
				sub			eax, ecx
				inc			eax
				call		WriteDec
				call		Crlf
				jmp			finishUp

KeepGoing:
				add			esi, DWORD PTR [ebp+12]
				loop		SearchLoop
				lea			edx, notFoundPrompt
				call		WriteString
				call		Crlf

finishUp:		pop			edx									;restore registers
				pop			ecx
				pop			eax
				pop			esi
				pop			ebp
				ret			12

search			ENDP
				END			main
