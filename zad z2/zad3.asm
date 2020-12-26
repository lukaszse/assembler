DOSSEG
	.model small
	.stack 100h
    .data
    ENTER_KEY equ 0Dh
	.code
start:
    mov ax,@data
    mov ds,ax               ; ustaw segment danych
    petla:
        mov ah, 1h 			; funkcja odczytu znaku z klawiatury z echem i zapisu do rejestru al
        int 21h				; przerwanie dos
        cmp al, ENTER_KEY
    jne petla

        mov	ax, 4c00h		; funkja zakończenia programu
        int	21h	
end start