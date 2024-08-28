;;=============================================================================;;
;;                                                                             ;;
;;                          Assembly Text Editor                               ;;
;;                                                                             ;;
;;                                                                             ;;
;;                                                                             ;;
;;                            By:CHERNI BORHEN                   
;;                                                                             ;;
;;                                                                             ;;
;;=============================================================================;;













.stack 100h

.data  
    posX      db 1 dup(0)        ; dh = posX -> controls row
    posY      db 1 dup(0)        ; dl = posY -> controls column
    matrix    db 80*25 dup(' ')  ; 25 lines of 80 chars each.
    curr_line dw ?
    curr_char dw ?
    length dw ?
    color       db 3*15+15
    filename db "file.txt",0
    handler dw ?
    error_msg db "Error occurred during file operations.", 0Dh, 0Ah, '$'



    
start_menu_str dw '  ',0ah,0dh  

dw ' ',0ah,0dh
dw ' ',0ah,0dh
dw ' ',0ah,0dh
dw '                ====================================================',0ah,0dh
dw '               ||                                                  ||',0ah,0dh                                        
dw '               ||       *     Assembly Text Editor      *          ||',0ah,0dh
dw '               ||                                                  ||',0ah,0dh
dw '               ||--------------------------------------------------||',0ah,0dh
dw '               ||                                                  ||',0ah,0dh
dw '               ||                                                  ||',0ah,0dh
dw '               ||                                                  ||',0ah,0dh          
dw '               ||        Type in what you want, press ESC          ||',0ah,0dh
dw '               ||               To exit the program.               ||',0ah,0dh
dw '               ||                                                  ||',0ah,0dh
dw '               ||               Press Enter to start               ||',0ah,0dh 
dw '               ||                                                  ||',0ah,0dh
dw '               ||                                                  ||',0ah,0dh
dw '                ====================================================',0ah,0dh
dw '$',0ah,0dh


.code 


;INITIALIZE DATA SEGMENT.
    mov  ax,@data
    mov  ds,ax
  
    call main_menu              ;Print the main menu
    
start_prog:
    call clear_screen
    jmp program
    
program:    ; Initalize the variables

    mov  curr_line, offset matrix
    mov  curr_char, 0

start:
call read_char  


any_char:
    mov  ah, 9
    mov  bh, 0
    mov  bl, color                            
    mov  cx, 1           ; how many times display char.
    int  10h             ; display char in al.
    ;UPDATE CHAR IN MATRIX.    
    mov  si, curr_line   ; si points to the beginning of the line.
    add  si, curr_char   ; si points to the char in the line.
    mov  [ si ], al      ; the char is in the matrix.
    inc  length          ; count the number of chars



 
;RIGHT.
Right:
    inc  curr_char       ; update current char.
    mov  dl, posX
    mov  dh, posY
    inc  dl              ; posX ++
    mov  posX, dl
    jmp  prntCrs


;LEFT.
Left:
    dec  curr_char       ; update current char.
    mov  dl, posX
    mov  dh, posY
    dec  dl              ; posX --
    mov  posX, dl
    jmp  prntCrs


;UP.
Up: 
    sub  curr_line, 80   ; update current line.
    mov  dl, posX
    mov  dh, posY
    dec  dh              ; posY -- 
    mov  posY, dh
    jmp  prntCrs         ; print cursor


;DOWN.
Down:   
    add  curr_line, 80   ; update current line.
    mov  dl, posX
    mov  dh, posY
    inc  dh              ; posY ++
    mov  posY, dh
    jmp  prntCrs 


;ENTER.
NewLine:        
    mov si, curr_line
    add si, 79
    mov [si], 0dh
    add curr_line, 80
    mov curr_char, 0
    mov posX, 0
    mov dl, posX
    mov dh, posY
    inc dh
    mov posY, dh
    add length, 80
    jmp prntCrs


;HOME
moveToBeginning:
    mov curr_char, 0
    mov posX, 0
    mov dl, posX
    jmp prntCrs
    


backSpace:
    ;check if this is the first char in the line
    cmp curr_char, 0
    je  preventBackSpace

   ;UPDATE CHAR IN MATRIX.
    dec curr_char
    mov si, curr_line   ; si points to the beginning of the line.
    add si, curr_char   ; si points to the char in the line.
    mov [ si ], ' '     ; the char is in the matrix.
    dec length          ; count the number of chars
    dec posX
    mov dl, posX
   ;Move the cursor
    mov  ah, 2h
    int  10h
    ;Update the Screen    
    mov  al,' '
    mov  ah, 9
    mov  bh, 0
    mov  bl, 0000
    mov  cx, 1           ; how many times display char.
    int  10h             ; display char in al.
    jmp prntCrs


fin:
    int  20h
    
prntCrs:                 ; print cursor
    mov  ah, 2h
    int  10h
    jmp  start           ; Go back to the beginning

preventBackSpace:
    call read_char
    
clear_screen proc near
        mov ah,0             ;graphics mode
        mov al,3             ;
        int 10h        
        ret
clear_screen endp 

saveToFile:
;CREATE FILE.
  mov  ah, 3ch
  mov  cx, 0
  mov  dx, offset filename 
  int  21h     
  ;CHECK FOR ERROR
    jc   file_error

;PRESERVE FILE HANDLER RETURNED.
  mov  handler, ax

;WRITE STRING.
  mov  ah, 40h
  mov  bx, handler
  mov  cx, length  ;STRING LENGTH.
  mov  dx, offset matrix
  int  21h   
  ;CHECK FOR ERROR
    jc   file_error

;CLOSE FILE (OR DATA WILL BE LOST).
  mov  ah, 3eh
  mov  bx, handler
  int  21h
  jmp fin 
  
 file_error:
    ; Handle file errors here
    ; For example, print an error message or halt
    ; This is a placeholder; you may need to implement error reporting.
    mov  ah, 09h
    mov  dx, offset error_msg
    int  21h
    jmp fin
 

main_menu proc
    mov ah,09h
    mov dh,0
    mov dx, offset start_menu_str
    int 21h
    
    input:      ;wait for ENTER KEY.
        mov  ah, 0
        int  16h
        cmp  al, 27          ; ESC
        je   fin
        cmp  ax, 1C0Dh       ; ENTER.
        je   start_prog
        jmp input
    
main_menu endp

  

read_char proc
;CAPTURE KEY.
    mov  ah, 0
    int  16h
    cmp  al, 27          ; ESC
    je   fin
    cmp  ax, 4800h       ; UP.
    je   Up
    cmp  ax, 4B00h       ; LEFT.
    je   Left
    cmp  ax, 4D00H       ; RIGHT.
    je   Right
    cmp  ax, 5000h       ; DOWN.
    je   Down
    cmp  ax, 1C0Dh       ; ENTER.
    je   NewLine
    cmp  ax, 3F00h       ; F5.
    je   saveToFile
    cmp  ax, 0E08h       ; BackSpace.
    je   backSpace    
    jmp any_char
   
 read_char endp
    
 get_file_location_from_user proc
    ret
 get_file_location_from_user endp  
