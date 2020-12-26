DOSSEG
	.model small
	.stack 100h
    .data
    ENTER_KEY equ 0Dh
	
	.code
start:
    mov ax,@data
    mov ds,ax               ; ustaw segment danych
    mov cx, 10H             ; wpisanie do wartosci 16 (dec) do bx - max ilość znaków
    petla:
        cmp cx, 0
        jz koniec           ; skocz nfa koniec jeśli b=0
        mov ah, 8h 			; funkcja odczytu znaku z klawiatury bez echa i zapisu do rejestru al
        int 21h				; przerwanie dos
        push ax             ; na stos
        mov dl, '*'         ; wpisanie * do dl    
        mov ah, 02h         ; funkcja wyświetlenia znaku
        int 21h             ; wywołanie przerrwania
        dec cx              ; dekrementacja bx
        pop ax              ; ze stosu do ax
        cmp al, ENTER_KEY   ; porownanie wpisanego znaku z kodem klawisza ENTER
    jne petla               ; jeśli wciśnięty klawisz inny niż enter skocz do etykiety petla
    koniec:
        mov	ax, 4c00h		; funkja zakończenia programu
        int	21h	
end start