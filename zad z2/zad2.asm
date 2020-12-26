DOSSEG
	.model small
	.stack 100h
	.code
start:

	mov ah, 08h 		; funkcja odczytu znaku z klawiatury bez echa i zapis do rejestru al
	int 21h				; przerwanie dos
    inc al              ; inkrementacja al  
    mov dl, al          ; zapisanie zawartosci al do dl
    mov ah, 2h          ; funkcja wypisania znaku
    int 21h             ; wywyłanie przerwania DOS
	mov	ax, 4c00h		; funkja zakończenia programu
	int	21h             ; wywołanie przerwania dos

end start