DOSSEG
	.model small
	.stack 100h
    .data
    ESC_KEY     equ     1Bh
    UP_KEY      equ     48h
    DOWN_KEY    equ     50h
    LEFT_KEY    equ     4bh
    RIGHT_KEY   equ     4dh
	
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
        jmp left
        cmp al, RIGHT_KEY   ; skok do right jeśli wcisnieto strzalke w prawo
        jmp right
    jmp loop1               ; jeśli wciśnięty klawisz inny niż enter skocz do etykiety petla

; wyswietlenie poszczególnych znaków
    up:
        mov dl, 'w'
        mov ah, 2h
        int 21h
        jmp loop1
    down:
        mov dl, 'z'
        mov ah, 2h
        int 21h
        jmp loop1
    left:
        mov dl, 'a'
        mov ah, 2h
        int 21h
        jmp loop1
    right:
        mov dl, 'd'
        mov ah, 2h
        int 21h
        jmp loop1

    koniec:
        mov	ax, 4c00h		; funkja zakończenia programu
        int	21h	
end start