DOSSEG
.model small
.stack 100h

.data
a_cls        db 27, "[2J$"    ; Clear entire screen in currently set attributes
a_reset      db 27, "[0m$"    ; Reset attributes to standard (black on white)
a_blink      db 27, "[5m$"    ; Characters blink (blink doesn't work in all environments)
a_bright     db 27, "[1m$"    ; Bright colored characters
a_dim        db 27, "[2m$"    ; Dim colored characters
a_fg_black   db 27, "[30m$"   ; Foreground colors
a_fg_red     db 27, "[31m$"
a_fg_green   db 27, "[32m$"
a_fg_yellow  db 27, "[33m$"
a_fg_blue    db 27, "[34m$"
a_fg_magenta db 27, "[35m$"
a_fg_cyan    db 27, "[36m$"
a_fg_white   db 27, "[37m$"
a_bg_black   db 27, "[40m$"   ; Background colors
a_bg_red     db 27, "[41m$"
a_bg_green   db 27, "[42m$"
a_bg_yellow  db 27, "[43m$"
a_bg_blue    db 27, "[44m$"
a_bg_magenta db 27, "[45m$"
a_bg_cyan    db 27, "[46m$"
a_bg_white   db 27, "[47m$"

text1        db "Blinking Bright Yellow on Blue$"
text2        db " Back to Normal$" 
text3        db " Bright Yellow on Black$"
combined     db 27, "[0;5;2;31;42m Blinking Dim Red on Green$" 

.code
begin:  
    mov ax,@data
    mov ds,ax
    mov es,ax
    mov ah,09h
    lea dx,a_cls      ; clear screen
    int 21h           
    lea dx,a_bright   ; Bright colored characters
    int 21h
    lea dx,a_blink    ; make the characters blink (if supported)
    int 21h
    lea dx,a_fg_yellow; make the characters yellow
    int 21h
    lea dx,a_bg_blue  ; blue background for characters
    int 21h
    lea dx,text1      ; print text
    int 21h
    lea dx,a_reset    ; reset to defaults 
    int 21h
    lea dx,text2      ; print normal text 
    int 21h
    lea dx,a_bright   ; bright characters
    int 21h
    lea dx,a_fg_yellow; make the characters yellow
    int 21h
    lea dx,text3      ; print text
    int 21h
    lea dx,combined   ; print combined text
    int 21h
    lea dx,a_reset    ; reset to defaults before exiting back to DOS prompt
    int 21h
    .exit
end begin