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
	
	.code
start:
    mov ax,@data
    mov ds,ax               ; ustaw segment danych
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

; procedura odczytu pozycji kursora
    read proc   
        mov ah, 03h         ; funkcja odczytu pozycji 
        int 10h             ; wywołanie przerwania BIOS
        ret                 ; powrót
    read endp

; procedura rysowania gwiazdki
    star proc
        mov ah, 09h
        xor dx, dx
        lea dx, [RED]       ; ustaw kolor czerwony
        int 21h
        xor dx, dx
        mov ah, 02h
        mov dl, '*'         ; wypisz gwiazdke
        int 21h
        ret
    star endp

; rysowanie gwiazdkek za pomocą kursora:
    up:
        call read 
        mov ah, 2h
        dec dh
        int 10h
        dec dl
        int 10h
        call star
        jmp loop1
    down:
        call read
        mov ah, 2h
        inc dh
        int 10h
        dec dl
        int 10h
        call star
        jmp loop1
    left:
        call read
        sub dl, 2h
        mov ah, 2h
        int 10h
        call star
        jmp loop1
    right:
        call read
        call star
        jmp loop1

    koniec:
        mov	ax, 4c00h		; funkja zakończenia programu
        int	21h	
end start