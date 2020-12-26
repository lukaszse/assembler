DOSSEG
	.model small
	.stack 100h
	
	.code
start:

	mov ah, 1h 			; funkcja odczytu znaku z klawiatury z echem i zapisu do rejestru al
	int 21h				; przerwanie dos

	mov	ax, 4c00h		; funkja zakończenia programu
	int	21h	

end start