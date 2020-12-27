DOSSEG
	.model small
	.stack 100h
    .data
    ESC_KEY     equ     1Bh
    UP_KEY      equ     48h
    DOWN_KEY    equ     50h
    LEFT_KEY    equ     4bh
    RIGHT_KEY   equ     4dh
    RED         db      27, "[31m$"
    BLUE        db      27, "[34m$"
    YELLOW      db      27, "[33m$"
    GREEN       db      27, "[32m$"
    PINK        db      27, "[35m$"
    LBLUE       db      27, "[36m$"
    GREY        db      27, "[37m$"
    BRIGHT_COL  db      27, "[1m$"    
    DIM_COL     db      27, "[2m$"
    CLS         db      27, "[2J$"    
    RESET_COL   db      27, "[0m$"   

    text3        db " Bright Yellow on Black$"
 
	
	.code
start:
    mov ax,@data
    mov ds,ax               ; ustaw segment danych
    mov ah, 09h             
    lea dx, [CLS]           ; wyczyszczenie ekranu
    int 21h
    mov ah, 2h              
    mov dh, 12               ; usttawienie wiersza 
    mov dl, 40               ; ustawienie kolumny
    int 10h
    loop1:
        xor ax, ax
        mov ah, 8h 			; funkcja odczytu znaku z klawiatury bez echa i zapisu do rejestru al
        int 21h				; przerwanie dos
        cmp al, ESC_KEY     ; porownanie wpisanego znaku z kodem klawisza ESC
        je koniec           ; skok na koniec jesli ESC
        cmp al, 00h         ; porównanie czy al = 0     
        jnz loop1           ; jeśli nie 0, skok do loop1
        xor ax, ax          ; zerowanie ax
        mov ah, 8h 			; funkcja odczytu znaku z klawiatury bez echa i zapisu do rejestru al
        int 21h				; przerwanie dos
        cmp al, UP_KEY      ; skok do up jeśli wcisnieto strzalke do gory
        je up
        cmp al, DOWN_KEY    ; skok do down jeśli wcisnieto strzalke w dol
        je down
        cmp al, LEFT_KEY    ; skok do left jeśli wcisnieto strzalke w lewo
        je left
        cmp al, RIGHT_KEY   ; skok do right jeśli wcisnieto strzalke w prawo
        je right
    jmp loop1               ; jeśli wciśnięty klawisz inny niż enter skocz do etykiety petla

; rysowanie za pomocą kursora:
    up:
        call read 
        mov ah, 2h
        dec dh
        int 10h
        lea dx, [RED]
        call set_color
        call draw
        jmp loop1
    down:
        call read
        mov ah, 2h
        inc dh
        int 10h
        lea dx, [BLUE]
        call set_color
        call draw
        jmp loop1
    left:
        call read
        dec dl
        mov ah, 2h
        int 10h
        lea dx, [BRIGHT_COL]
        call set_color
        lea dx, [YELLOW]
        call set_color
        call draw
        lea dx, [RESET_COL]
        call set_color
        jmp loop1
    right:
        call read
        inc dl
        mov ah, 2h
        int 10h
        lea dx, [GREEN]
        call set_color
        call draw
        jmp loop1


    koniec:
        mov	ax, 4c00h		; funkja zakończenia programu
        int	21h	
        
; procedura odczytu pozycji kursora
    read proc   
        mov ah, 03h         ; funkcja odczytu pozycji 
        int 10h             ; wywołanie przerwania BIOS
        ret                 ; powrót
    read endp

; procedura ustawiania koloru tła
    set_color proc
        mov ah, 09h
        int 21h
        ret
    set_color endp

; procedura rysowania 
    draw proc
        xor dx, dx
        mov ah, 02h
        mov dl, 219         ; rysuj tło
        int 21h
        call read 
        mov ah, 2h
        dec dl
        int 10h
        ret
    draw endp

end start