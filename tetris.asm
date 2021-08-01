Include Irvine16.inc
include soac16.inc
include macros.inc

.data
ESCKEY = 1Bh
Greeting BYTE "Press ESC to Quit",0
StatusLine BYTE "Left Button"
BYTE "Mouse Position",0
Blanks BYTE "             ",0
Xcoordinate WORD 0   
Ycoordinate WORD 0   
Xclick WORD 0     
YClick WORD 0
QP BYTE 99
Load1 byte "Loading...",0
temp1 WORD 0
pla byte "Enter Name of PLAYER : " , 0
;========================================

user BYTE 50 DUP (?)
File BYTE "FileData.txt",0

shape  db 0,0,0,0,0,0,0,0
Nshape db 14,33,14,34,14,35,14,36

counter db 0
temporary db ?
row db 0

sad dw 0
border db '*                          ****************', 0Dh,0ah	;board of game
       db '*                          *              *', 0Dh,0ah
       db '*                          *    SCORES    *', 0Dh,0ah
       db '*                          *              *', 0Dh,0ah
       db '*                          *              *', 0Dh,0ah
       db '*                          *              *', 0Dh,0ah
       db '*                          *              *', 0Dh,0ah
       db '*                          *              *', 0Dh,0ah
       db '*                          *              *', 0Dh,0ah
       db '*                          ****************', 0Dh,0ah
       db '*                          * pause: P     *', 0Dh,0ah
       db '*                          * Quit:  Q     *', 0Dh,0ah
       db '*                          *  NEXT SHAPE  *', 0Dh,0ah
       db '*                          *              *', 0Dh,0ah
       db '*                          *              *', 0Dh,0ah
       db '*                          *              *', 0Dh,0ah
       db '*                          *              *', 0Dh,0ah
       db '*                          *              *', 0Dh,0ah
       db '*******************************************', 0Dh,0ah, '$'

pause1 db 0 
random db ?         ;for random vales to select shape  
scores dw 0         ;to store scores
scancode db 0       ; scan code Varriable
hrs db 0            ;Delay1
mins db 0           ;Delay1
secs db  0          ;Delay1
string1 db "Tetris Game",0
string2 db "Game Over",0
 
shape1 db 1,11,1,12,2,12,2,13		;arrays to store shapes
shape2 db 0,12,1,11,1,12,2,11
shape3 db 0,12,0,13,1,11,1,12
shape4 db 0,11,1,11,1,12,2,12
shape5 db 0,11,0,12,0,13,0,14
shape6 db 1,12,2,12,3,12,4,12
shape7 db 1,11,1,12,1,13,0,13
shape8 db 1,12,2,12,3,12,3,13
shape9 db 1,11,0,11,0,12,0,13
shape10 db 0,12,0,13,1,13,2,13
shape11 db 0,11,1,11,1,12,1,13
shape12 db 0,13,1,13,2,13,2,13
shape13 db 0,11,0,12,0,13,1,13
shape14 db 0,13,0,12,1,12,2,12
shape15 db 0,12,1,11,1,12,1,13
shape16 db 0,12,1,12,1,13,2,12
shape17 db 0,12,1,12,1,11,2,12
shape18 db 0,11,0,12,0,13,1,12
shape19 db 0,11,0,12,1,11,1,12
;==============================================

game byte " !!!.......GAME.......!!!",0
project byte " ASSEMBLY PROJECT : ",0
project_name byte " TETRIS ",0
member byte " GROUP MEMBERS : ",0
member_1 byte " 1)- Saad Irfan ",0
member_2 byte " 2)- Junaid Muhammad ",0
submit byte " SUBMITTED TO : ",0
sir byte " SIR TEHSEEN KHAN ",0
temp word 0
;--------------------------------------------------------------------------------------------------------------------------------------------

.code       
                                        

main proc
mov ax,@data
mov ds,ax

	call video_mode_selection		;video selection mode

	call Madeby			;displaying content
	call delay1
	call delay1
	call clrscr
	mov ah,0
mov al,10h
int 10h

	call main2
GAME3::
call clrscr
mov ah,0
mov al,10h
int 10h
;-------------------------------------------------------------------------
			mov cx,lengthof pla       ;mov dx, offset project
	        dec cx
			mov si, 0						   ;call writestring
			mov dl, 7
			
lable_:
		mov ah,2                               ;gotoxy
		mov dh,5	                           ;row
		mov bh,0                               ;video page
		int 10h
		mov temp , cx
		mov ah, 9                              ;Function
		mov al, pla[si]                        ;Assign value
		mov bh, 0                              ;Vedio page
		mov bl, 0ah                            ;For Color
		mov cx, 1                              ;Loop
		int 10h                                ;interrupts
		inc dl 		                           ;inc col
		inc si                              ;show var
		mov cx, temp
		mov ax, 100
		call Delay
loop lable_
;------------------------------------------------------------------
invoke CreateFile, ADDR File
;------------------------------------------------------------------
mov si , offset user
mov cx , sizeof user
qwer:
mov ah , 10h
mov bl , 0ah
int 16h
cmp al , 0dh
je qwert
call writechar
mov [si], al
inc si
loop qwer
qwert:
;------------------------------------------------------------------
invoke WriteFile,ADDR File,ADDR user,SIZEOF user
.if QP==1
jmp GAME1
.endif
.if QP==2
jmp QUIT
.endif

	GAME1::
	call main3
	call clrscr
	mov ah,0
	mov al,10h
	int 10h
	call draw_border ;for border for first time

	call Delay1
       
        call select_shape 			;select random shape
 

gam:
     
	call move_shape_to_board 			;more shape charecter to board

	call draw_border
	
	call Delay1

	call disappear_shape

	

	call check_update_D			;check shape down coordinttes then move down shape if space availble

jmp gam

QUIT::
;-----------------------------------
mov ah,4ch
int 21h
main endp
;------------------------------------------------------------------------------------------------
;mouse codes

Wall1 PROC
	pusha
	mov ah,2
	mov bh,0
	int 10h
	mov ah,9
	mov bh,0
	mov bl,0Dh
	mov cx,1
	int 10h
	popa
ret
Wall1 ENDP

gotoxy2 PROC
	pusha
	mov ah,2
	mov bh,0
	int 10h
	popa
ret
gotoxy2 ENDP

main1 PROC
	mov dl,23
	mov ecx,31
	l1:
		mov al,178
		mov dh,6
		call Wall1
		push edx
		push ecx
		push eax
		mov ax,10
		call delay
		pop eax
		pop ecx
		pop edx
		inc dl
	LOOP l1
	mov dh,6
	mov ecx,18
	l2:
		mov dl,54
		call Wall1
		;call writechar
		push edx
		push ecx
		push eax
		mov ax,10
		call delay
		pop eax
		pop ecx
		pop edx
		inc dh
	LOOP l2
	mov dl,55
	mov ecx,31
	l3:
		mov dh,22
		call Wall1
		;call writechar
		push edx
		push ecx
		push eax
		mov ax,10
		call delay
		pop eax
		pop ecx
		pop edx
		dec dl
	LOOP l3
	mov dh,22
	mov ecx,18
	l4:
		mov dl,24
		call Wall1
		;call writechar
		push edx
		push ecx
		push eax
		mov ax,10
		call delay
		pop eax
		pop ecx
		pop edx
		dec dh
	LOOP l4

	mov dh,4
	mov dl,28
	call gotoxy2
	;mov eax,0Ch
	;call settextcolor
	mwrite"WELCOME TO TETRIS GAME"
	
	;mov eax,0F4h
	;call settextcolor
	
	mov dh,10
	mov dl,30
	call gotoxy2
	mwrite"|                |"
	mov dh,11
	mov dl,30
	call gotoxy2
	mwrite"|                |"
	mov dh,12
	mov dl,30
	call gotoxy
	mwrite"|                |"
	
	mov dh,17
	mov dl,33
	call gotoxy2
	mwrite"|          |"
	mov dh,18
	mov dl,33
	call gotoxy2
	mwrite"|          |"
	mov dh,19
	mov dl,33
	call gotoxy2
	mwrite"|          |"
	
	mov dl,30
	mov ecx,18
	L:
		mov al,'-'
		mov dh,9
		call Wall1
		mov dh,13
		call Wall1
		.if dl>32 && dl<45
		mov dh,16
		call Wall1
		mov dh,20
		call Wall1
		.endif
	INC dl
	LOOP L
	mov dh,11
	mov dl,36
	call gotoxy2
	;mov eax,0F9h
	;call settextcolor
	mwrite" PLAY "

	mov dh,18
	mov dl,36
	call gotoxy2
	;mov eax,0F9h
	;call settextcolor
	mwrite" EXIT "
	
ret
main1 ENDP
main2 PROC
;==================================
call get_value
ret
main2 ENDP
;================================
get_value proc
call main1
Call HideCursor11
Call ShowMousePointer
L1: 
Call ShowMousePosition
Call LeftButtonClick    
mov ah,11h
int 16h
jz l2
mov ah,10h
int 16h
cmp al,ESCKEY
je Quit1
L2: jmp L1
Quit1: Call HideMousePointer
Call ShowCursor11
Call ClrScr
Call waitmsg
;================================
ret
get_value endp

;================================
GetMousePosition PROC
push ax
mov ax,3
int 33h
pop ax
ret
GetMousePosition ENDP
;===============================
HideCursor11 PROC
mov ah,3
int 10h
or ch,30h
mov ah,1
int 10h
ret
HideCursor11 ENDP
;===============================
ShowCursor11 PROC
mov ah,3
int 10 
mov ah,1
mov cx,0607h
int 10h
ret
ShowCursor11 ENDP
;===============================
HideMousePointer PROC
push ax
mov ax,2
int 33h
pop ax
ret
HideMousePointer ENDP
;==============================
ShowMousePointer PROC
push ax
mov ax,1
int 33h
pop ax
ret
ShowMousePointer ENDP
;===============================
LeftButtonClick PROC
pusha
mov ah,0
mov al,5
mov bx,0
int 33h
;-----------------------------------
and ax,1
.if ax==1
.IF ( cx>244 && cx<380 ) && (dx>135 && dx<185)
mov QP,1
jmp GAME3
.endif

.IF ( cx>266 && cX<357 ) && (dx>234 && dx<280)
mov QP,2
jmp QUIT
ret
.endif
.endif
cmp cx,Xclick
jne lbc1
cmp bx,Yclick
je lbc_exit
LBC1:
mov Xclick,cx
mov Yclick,dx
mov dh,24
mov dl,15
call gotoxy
push dx
mov dx, OFFSET Blanks
;Call WriteString
pop dx
Call Gotoxy
mov ax,Xcoordinate
;Call Writedec
mov dl,20
call gotoxy
mov ax,ycoordinate
;call writedec
lbc_exit:
popa
ret
leftButtonClick ENDP
;=================================
SETMousePosition PRoc
mov ax,4
int 33h
ret

SetMousePosition ENDP
;=================================
ShowMousePosition PROC

pusha
Call GetMousePosition
cmp cx,xcoordinate
jne smp1
cmp dx,ycoordinate
je smp_exit
smp1: mov xcoordinate,cx
mov ycoordinate,dx
mov dh,24
mov dl,60
Call gotoxy
push dx
mov dx, OFFSET Blanks
;Call WriteString
pop dx
Call gotoxy
mov ax, xcoordinate
;Call WriteDec
mov dl,65
call gotoxy
mov ax,ycoordinate
;Call WriteDec
smp_exit:
popa
ret
ShowMousePosition ENDP
;=====================================;
;Loading functions


gotoxy1 PROC
	pusha
	mov ah,2
	mov bh,0
	int 10h
	popa
ret
gotoxy1 ENDP

Wall PROC
	pusha
	mov ah,2
	mov bh,0
	int 10h
	mov ah,9
	mov bh,0
	mov bl,0Dh
	mov cx,1
	int 10h
	popa
ret
Wall ENDP

str_function proc 
			mov cx,lengthof Load1                      ;mov dx, offset tic
			dec cx
			mov si, 0                           ;call writestring       
			mov dl, 25
l2:
		mov temp1, cx
		mov ah,2   								;gotoxy
		mov dh,8								;row
		mov bh,0    							;video page
		int 10h
		mov ah, 9                              ; Function
		mov al, Load1[si]                        ; Assign value
		mov bh, 0                              ; Vedio page
		mov bl, 0Ah                           ; For Color
		mov cx, 1                              ; Loop
		int 10h                                ; interrupts
		inc dl 									;inc col
		inc si    							;show var
		mov cx,temp1
loop l2
ret 
str_function endp


main3 PROC
	call str_function

	mov dl,25
	mov ecx,30
	L:
		mov dh,10
		mov al,'-'
		call Wall
		mov dh,12
		mov al,'-'
		call Wall
		inc dl
	LOOP L
	mov ecx,30
	mov dl,25
	mov al,178
	L1:
		mov al,178
		mov dh,11
		call Wall
		push edx
		push ecx
		mov ax,150
		call delay
		pop ecx
		pop edx
	INC dl
	LOOP L1
	
ret
main3 ENDP

;=====================================
;-----------------------move_shape_to_board proc----------------------

move_shape_to_board proc   ;move cordinates of shape to board

mov bx,offset border
mov si,offset shape
mov di,0
mov dl,0
outer:
         mov cl,[si]	
	 mov bx,offset border
	 mov ch,0
		loopx:
                	add bx,45 
                loop loopx
	inc si
        mov ax,0
	mov al,[si]	
	mov di,ax
	mov al,79
	mov [di+bx],al
	inc si
	inc dl
cmp dl,4
jne outer
ret
move_shape_to_board endp


move_next_shape_to_board proc   ;move cordinates of shape to board

mov bx,offset border
mov si,offset Nshape
mov di,0
mov dl,0
outer:
         mov cl,[si]	
	 mov bx,offset border
	 mov ch,0
		loopx:
                	add bx,45 
                loop loopx
	inc si
        mov ax,0
	mov al,[si]	
	mov di,ax
	mov al,79
	mov [di+bx],al
	inc si
	inc dl
cmp dl,4
jne outer
ret
move_next_shape_to_board endp




;-------------------disappear_shape proc-------------
 
disappear_shape proc            ;remove previous shape

mov bx,offset border
mov si,offset shape
mov di,0
mov dl,0
outer1:
         mov cl,[si]	
	 mov bx,offset border
	 mov ch,0
		loopy:
                	add bx,45 
                loop loopy
	inc si
        mov ax,0
	mov al,[si]	
	mov di,ax
	mov al,20h
	mov [di+bx],al
	inc si
	inc dl
cmp dl,4
jne outer1
ret	

disappear_shape endp


disappear_next_shape proc            ;remove previous shape

mov bx,offset border
mov si,offset Nshape
mov di,0
mov dl,0
outer1:
         mov cl,[si]	
	 mov bx,offset border
	 mov ch,0
		loopy:
                	add bx,45 
                loop loopy
	inc si
        mov ax,0
	mov al,[si]	
	mov di,ax
	mov al,20h
	mov [di+bx],al
	inc si
	inc dl
cmp dl,4
jne outer1
ret	

disappear_next_shape endp




;----------;to make row disappear----------------------
disappear_row  proc   ;to make row disappear 



mov bx,810
add bx,0
mov dl,0

outerg:
	mov al,0
	mov si,1
	sub bx,45
	mov sad,bx 

	inc dl
	    loo:
            mov cl,border[bx+si]
		    inc si 
		    cmp cl,20h
		    jne adding
		    haha:
	    cmp si,27
	    jne loo
	
	cmp al,26
	je disappearing

cmp dl,16
jne outerg

jmp gaeb_row_exit

disappearing:
	mov bx,sad
	mov cx,26
	mov si,1
	E:
		mov al,20h
		mov border[bx+si],al
		inc si

	loop E

call below_row 

cmp dl,16
jne outerg

jmp gaeb_row_exit



adding:
	inc al
	jmp haha  

gaeb_row_exit:
ret 

disappear_row endp              

;-------------------------




below_row proc			;move row one step row below
mov bx ,sad


loop1:
 sub bx,45

 mov si,1
 mov di,46
 mov counter,26
 mov cl,20h
  loop2:
    mov al,border[bx+si]
    mov border[bx+si],cl
    mov border[bx+di],al
     inc di
     inc si
     dec counter
  cmp counter,0
  jne loop2
  
  
cmp bx,0
jne loop1
below_row endp 




;------------------check_update_L proc---------------------------

check_update_L proc              ;check one row below if there is space then move coordinates of shape one column left

call disappear_shape 
mov bx,offset border
mov si,offset shape
mov di,0
mov dl,0
outerL:
         mov cl,[si]	
	 mov bx,offset border
	 mov ch,0
		lopL:
                	add bx,45 
                loop lopL
	inc si
        mov ax,0
	mov al,[si]
	dec al	
	mov di,ax
	mov al,[di+bx]
	cmp al,20h
	jne X
	inc si
	inc dl
cmp dl,4
jne outerL
	mov cx,4
	mov al,1
	mov si,1
       
F1:
	   sub shape[si],al
	   add si,2
	loop F1
	
	call move_shape_to_board 
	call draw_border 
	mov scancode,0
jmp check_exit
X:
call move_shape_to_board
call draw_border
mov scancode,0
check_exit:

ret	
check_update_L endp



;------------------check_update_R proc---------------------------
check_update_R proc              ;check one row below if there is space then move coordinates of shape one column right
call disappear_shape 
mov bx,offset border
mov si,offset shape
mov di,0
mov dl,0
outerR:
         mov cl,[si]	
	 mov bx,offset border
	 mov ch,0
		lopR:
                	add bx,45 
                loop lopR
	inc si
        mov ax,0
	mov al,[si]
        inc ax	
	mov di,ax
	mov al,[di+bx]
	cmp al,20h
	jne X
	inc si
	inc dl
cmp dl,4
jne outerR
	mov cx,4
	mov al,1
	mov si,1
        F:
	   add shape[si],al
	   add si,2
	loop F
	call move_shape_to_board 
	call draw_border 
	mov scancode,0 
jmp check_exit
X:

call move_shape_to_board
call draw_border
mov scancode,0
check_exit:

ret	
check_update_R endp





;------------------check_update_D proc---------------------------

check_update_D proc              ;check one row below if there is space then move coordinates of shape one row below
mov scancode,0 
call disappear_shape
mov bx,offset border
mov si,offset shape
mov di,0
mov dl,0
outerD:
         mov cl,[si]
	 inc cl	
	 mov bx,offset border
	 mov ch,0
		lopD:
                	add bx,45 
                loop lopD
	inc si
        mov ax,0
	mov al,[si]	
	mov di,ax
	mov al,[di+bx]
	cmp al,20h
	jne Down
	inc si
	inc dl
cmp dl,4
jne outerD
        
	mov cx,4
	mov al,1
	mov si,0
        D:
	   add shape[si],al
	   add si,2
	loop D
	inc scores
        call scores_print
	 call move_shape_to_board 
	call draw_border
         
jmp check_exit
Down:

call move_shape_to_board
call draw_border
call disappear_row
cmp shape[0],0
je endgame
cmp shape[0],1
je endgame
call select_shape
jmp check_exit
endgame:
	call gameover


check_exit:
ret	
check_update_D endp



;------------------Scan-CODE---------------------------

scan_code proc		;scan keys
	mov ah,6	;check input buffer
	mov dl,0FFh	
	int 21h
	




		mov scancode,al



		cmp scancode,71h	;Quite
		je total_exit
	
			cmp scancode,70h	;pause1
			je pause1_g
		

	cmp scancode,4Bh
je    left_dec
	cmp scancode,4Dh
je right_inc
	cmp scancode,50h
je down_inc

jmp scan_exit
left_dec:
	call check_update_L
jmp scan_exit
		
right_inc:
	call check_update_R
jmp scan_exit

down_inc:
	call check_update_D 
	jmp scan_exit

total_exit:
	mov ah,4ch
	int 21h
pause1_g:

	call halt
	jmp scan_exit
		
scan_exit:

ret
scan_code endp

Print_character proc ;**************Print character**********************

;---characterprint---

	mov ah,09h
	mov bh,0	;PAGE NUBMER
	mov bl,03	;colour
	mov al,'O' ; "A"
	mov cx,1
	int 10h

ret
print_character endp
;*********************************************************


;********Video mode(Activation of Graphics mode)**********
video_mode_selection proc 


	mov ah,0	
	mov al,12h
	int 10h

; Now, we are in 640 x 480(col/row) 		( pixels any smallest piont in screen )
; 12h 80x25 640x480 16 colors VGA+ 1			  639=79  ,at 399row =24row
; 25 rows(0 to 24)and80 columns (0 to 79).(for characters) 


;------------------Pixel---------------
	
ret
video_mode_selection endp
;************************************************************
;************************************DRAW  Border start****************************************
draw_border proc

;-------clearing the screen---------
	mov al,03
	mov ah,0
	int 10h

;drawing border      
mov si,0
mov cx,855

	display_border:
		mov ah,02h
		mov dl ,border[si]  
		
		int 21h
		inc si
	loop display_border

ret
draw_border endp

;*****************Border END**************************     
              	



;*********** Delay1 proc***********************												 
Delay1 PROC
         
mov ah,2Ch
int 21h

mov hrs,ch
mov mins,cl
mov secs,dh

mov bl,secs
cmp bl,59
	jE minus

	jmp nominus

minus:
	mov bl,0

jmp timeDelay1
nominus:
	mov bl,secs
	add bl,1

timeDelay1:
	mov temporary,bl
	call scan_code
	mov bl,temporary
	mov ah,2Ch
	int 21h
	mov hrs,ch
	mov mins,cl
	mov secs,dh
	cmp bl,secs
jE t
loop timeDelay1

t:
	mov ah,2Ch
	int 21h

	mov hrs,ch
	mov mins,cl
	mov secs,dh
	cmp bl,secs
	jE Delay1complete
loop t

Delay1complete:

RET
Delay1 ENDP
;********************************************************  
  




;-------------------scores_print proc--------------------------

scores_print proc

mov ax, scores
	mov si,213
  mov cx,0

  mov dx,0

  mov bx,10d

  	loop1:
    	mov dx,0	;ax: Quotient

    	div bx	        
	
    	push dx		;dx: Remainder

    	inc cx
    	cmp ax,0	;if ax!=0 then

    	jnz loop1	;Loop will be repeated

  	loop2:
    	mov ah,02
    	pop dx
	add dl,48
	mov border[si],dl
        inc si
    	;add dl,48
    	;int 21h

    	dec cx

    	cmp cx,0	;if cx!=0 then
    	jnz loop2	;Loop will be repeated

ret
scores_print endp









;--------------------select_shape proc-------------------------

select_shape proc

call disappear_next_shape
mov si,1
mov cx,4
mov al,22
loo1:
  sub Nshape[si],al
  add si,2
loop loo1

mov si,0
mov cx,4
mov al,14
looo2:
  sub Nshape[si],al
  add si,2
loop looo2


mov cx,8
mov si,0
mov ax,0
lo:
  mov al,Nshape[si]
  mov shape[si],al
  inc si
loop lo


mov ah,2Ch ;getting random values

int  21h
mov ax,0 
mov al,dh
mov bl,19
div bl
mov  random,ah
inc random    
   
cmp random,1
je L1
cmp random,2
je L2
cmp random,3
je L3
cmp random,4
je L4
cmp random,5
je L5
cmp random,6
je L6
cmp random,7
je L7
cmp random,8
je L8
cmp random,9
je L9
cmp random,10
je L10
cmp random,11
je L11
cmp random,12
je L12
cmp random,13
je L13
cmp random,14
je L14
cmp random,15
je L15
cmp random,16
je L16
cmp random,17
je L17
cmp random,18
je L18
cmp random,19
je L19


;for copying the shapes values to Nshape variabe

L1:
mov cx,8
mov si,0
	copy1:

		mov al,shape1[si]
		mov Nshape[si],al
		inc si
	loop copy1
jmp exit_select_shape


L2:
mov cx,8
mov si,0
	copy2:

		mov al,shape2[si]
		mov Nshape[si],al
		inc si
	loop copy2
jmp exit_select_shape

L3:
mov cx,8
mov si,0
	copy3:

		mov al,shape3[si]
		mov Nshape[si],al
		inc si
	loop copy3
jmp exit_select_shape

L4:
mov cx,8
mov si,0
	copy4:

		mov al,shape4[si]
		mov Nshape[si],al
		inc si
	loop copy4
jmp exit_select_shape

L5:
mov cx,8
mov si,0
	copy5:

		mov al,shape5[si]
		mov Nshape[si],al
		inc si
	loop copy5
jmp exit_select_shape

L6:
mov cx,8
mov si,0
	copy6:

		mov al,shape6[si]
		mov Nshape[si],al
		inc si
	loop copy6
jmp exit_select_shape

L7:
mov cx,8
mov si,0
	copy7:

		mov al,shape7[si]
		mov shape[si],al
		inc si
	loop copy7
jmp exit_select_shape

L8:
mov cx,8
mov si,0
	copy8:

		mov al,shape8[si]
		mov Nshape[si],al
		inc si
	loop copy8
jmp exit_select_shape

L9:
mov cx,8
mov si,0
	copy9:

		mov al,shape9[si]
		mov Nshape[si],al
		inc si
	loop copy9
jmp exit_select_shape

L10:
mov cx,8
mov si,0
	copy10:

		mov al,shape10[si]
		mov Nshape[si],al
		inc si
	loop copy10
jmp exit_select_shape

L11:
mov cx,8
mov si,0
	copy11:

		mov al,shape11[si]
		mov Nshape[si],al
		inc si
	loop copy11
jmp exit_select_shape

L12:
mov cx,8
mov si,0
	copy12:

		mov al,shape12[si]
		mov Nshape[si],al
		inc si
	loop copy12
jmp exit_select_shape

L13:
mov cx,8
mov si,0
	copy13:

		mov al,shape13[si]
		mov Nshape[si],al
		inc si
	loop copy13
jmp exit_select_shape

L14:
mov cx,8
mov si,0
	copy14:

		mov al,shape14[si]
		mov Nshape[si],al
		inc si
	loop copy14
jmp exit_select_shape

L15:
mov cx,8
mov si,0
	
	copy15:

		mov al,shape15[si]
		mov Nshape[si],al
		inc si
	loop copy15
jmp exit_select_shape

L16:
mov cx,8
mov si,0
	
	copy16:

		mov al,shape16[si]
		mov Nshape[si],al
		inc si
	loop copy16
jmp exit_select_shape


L17:
mov cx,8
mov si,0
	copy17:

		mov al,shape17[si]
		mov Nshape[si],al
		inc si
	loop copy17
jmp exit_select_shape

L18:
mov cx,8
mov si,0
	copy18:
		mov al,shape18[si]
		mov shape[si],al
		inc si
	loop copy18
jmp exit_select_shape

L19:
mov cx,8
mov si,0

	copy19:
		mov al,shape19[si]
		mov Nshape[si],al
		inc si
	loop copy19

exit_select_shape:


mov si,1
mov cx,4
mov al,22
loo:
  add Nshape[si],al
  add si,2
loop loo

mov si,0
mov cx,4
mov al,14
looo:
  add Nshape[si],al
  add si,2
loop looo




call move_next_shape_to_board

ret 
select_shape endp

;***************halt proc**************************
halt proc

	chaker:
	mov ah,01
	int 21h

	cmp al,1
	jne con
	
	
	

con:
call Delay1

ret
halt endp
;------------------Madeby-------------

Madeby proc
COMMENT @	mov ah, 2
	mov dl, 30
	mov dh, 7
	mov bh, 0
    int 10h
	
	mov dx, OFFSET string3
	call WriteString

	mov ah, 2
	mov dl, 30
	mov dh, 8
	mov bh, 0
    int 10h
	
	mov dx, OFFSET string4
	call WriteString	

	mov ah, 2
	mov dl, 30
	mov dh, 9
	mov bh, 0
    int 10h
	
	mov dx, OFFSET string5
	call WriteString	
	
	mov ah, 2
	mov dl, 30
	mov dh, 10
	mov bh, 0
    int 10h
	
	mov dx, OFFSET string6
	call WriteString
	@
	
	mov cx,lengthof game                     ;mov dx, offset game
	        dec cx
			mov si, 0						   ;call writestring
			mov dl, 25
			mov temp , 0
lable_1:
		mov temp ,cx
		mov ah, 9                              ;Function
		mov al, game[si]                        ;Assign value
		mov bh, 0                              ;Vedio page
		mov bl, 02h                           ;For Color
		mov cx, 1                              ;Loop
		int 10h                                ;interrupts
		mov ah,2                               ;gotoxy
		mov dh,1	                           ;row
		mov bh,0                               ;video page
		int 10h
		inc dl 		                           ;inc col
		inc si                              ;show var
		mov cx,temp
		mov ax, 100
		;call Delay
loop lable_1
;------------------------------------------------------------------
			mov cx,lengthof project                     ;mov dx, offset tac
	        dec cx
			mov si, 0						   ;call writestring
			mov dl, 10
lable_2:
		mov temp,cx
		mov ah, 9                              ;Function
		mov al, project[si]                        ;Assign value
		mov bh, 0                              ;Vedio page
		mov bl, 07h                            ;For Color
		mov cx, 1                              ;Loop
		int 10h                                ;interrupts
		mov ah,2                               ;gotoxy
		mov dh,4	                           ;row
		mov bh,0                               ;video page
		int 10h
		inc dl 		                           ;inc col
		inc si                              ;show var
		mov cx,temp
		mov ax, 100
		;call Delay
loop lable_2
;------------------------------------------------------------------
			mov cx,lengthof project_name       ;mov dx, offset project
	        dec cx
			mov si, 0						   ;call writestring
			mov dl, 20
lable_3:
		mov temp , cx
		mov ah, 9                              ;Function
		mov al, project_name[si]                        ;Assign value
		mov bh, 0                              ;Vedio page
		mov bl, 07h                            ;For Color
		mov cx, 1                              ;Loop
		int 10h                                ;interrupts
		mov ah,2                               ;gotoxy
		mov dh,6	                           ;row
		mov bh,0                               ;video page
		int 10h
		inc dl 		                           ;inc col
		inc si                              ;show var
		mov cx, temp
		mov ax, 100
		;call Delay
loop lable_3
;------------------------------------------------------------------
			mov cx,lengthof member                    ;mov dx, offset tac
	        dec cx
			mov si, 0						   ;call writestring
			mov dl, 10
lable_4:
		mov temp,cx
		mov ah, 9                              ;Function
		mov al, member[si]                        ;Assign value
		mov bh, 0                              ;Vedio page
		mov bl, 04h                           ;For Color
		mov cx, 1                              ;Loop
		int 10h                                ;interrupts
		mov ah,2                               ;gotoxy
		mov dh,8	                           ;row
		mov bh,0                               ;video page
		int 10h
		inc dl 		                           ;inc col
		inc si                              ;show var
		mov cx, temp
		mov ax, 100
		;call Delay
loop lable_4
;------------------------------------------------------------------
			mov cx,lengthof member_1                    ;mov dx, offset tac
	        dec cx
			mov si, 0						   ;call writestring
			mov dl, 20
lable_5:
		mov temp , cx
		mov ah, 9                              ;Function
		mov al, member_1[si]                        ;Assign value
		mov bh, 0                              ;Vedio page
		mov bl, 04h                            ;For Color
		mov cx, 1                              ;Loop
		int 10h                                ;interrupts
		mov ah,2                               ;gotoxy
		mov dh,10	                           ;row
		mov bh,0                               ;video page
		int 10h
		inc dl 		                           ;inc col
		inc si                              ;show var
		mov cx,temp
		mov ax, 100
		;call Delay
loop lable_5
;------------------------------------------------------------------
			mov cx,lengthof member_2                     ;mov dx, offset tac
	        dec cx
			mov si, 0						   ;call writestring
			mov dl, 20
lable_6:
		mov temp , cx
		mov ah, 9                              ;Function
		mov al, member_2[si]                        ;Assign value
		mov bh, 0                              ;Vedio page
		mov bl, 04h                            ;For Color
		mov cx, 1                              ;Loop
		int 10h                                ;interrupts
		mov ah,2                               ;gotoxy
		mov dh,11	                           ;row
		mov bh,0                               ;video page
		int 10h
		inc dl 		                           ;inc col
		inc si                              ;show var
		mov cx , temp
		mov ax, 100
		;call Delay
loop lable_6
;------------------------------------------------------------------

;--------------------------------------------------------------
			mov cx,lengthof submit                     ;mov dx, offset tac
	        dec cx
			mov si, 0						   ;call writestring
			mov dl, 10
lable_8:
		mov temp,cx
		mov ah, 9                              ;Function
		mov al, submit[si]                        ;Assign value
		mov bh, 0                              ;Vedio page
		mov bl, 09h                            ;For Color
		mov cx, 1                              ;Loop
		int 10h                                ;interrupts
		mov ah,2                               ;gotoxy
		mov dh,14	                           ;row
		mov bh,0                               ;video page
		int 10h
		inc dl 		                           ;inc col
		inc si                              ;show var
		mov cx,temp
		mov ax, 100
		;call Delay
loop lable_8
;-------------------------------------------------------------
			mov cx,lengthof sir                     ;mov dx, offset tac
	        dec cx
			mov si, 0						   ;call writestring
			mov dl, 20
lable_9:
		mov temp , cx
		mov ah, 9                              ;Function
		mov al, sir[si]                        ;Assign value
		mov bh, 0                              ;Vedio page
		mov bl, 09h                            ;For Color
		mov cx, 1                              ;Loop
		int 10h                                ;interrupts
		mov ah,2                               ;gotoxy
		mov dh,16	                           ;row
		mov bh,0                               ;video page
		int 10h
		inc dl 		                           ;inc col
		inc si                              ;show var
		mov cx , temp
		mov ax, 100
		;call Delay
loop lable_9
;-----------------------------------------------------------------	
	
	
ret
Madeby endp

gameover proc
	mov al,03
	mov ah,0
	int 10h


	mov cx,9
	mov al, 25    	; col
	mov si,0
loop1: 
        ;mov dh,10
        ;mov dl,al
	;int 10h  ; row column already set
	
        mov dl ,string2[si]
        mov ah,02h  
	int 21h
	
	inc al	
	inc si
loop loop1
        call Delay1
	call Delay1
	call Delay1
	mov ah,4ch
	int 21
gameover endp
end main