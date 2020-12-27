DOSSEG
	.model small
	.stack 100h
    .data
    ESC_KEY     equ     1Bh
    UP_KEY      equ     48h
    DOWN_KEY    equ     50h
    LEFT_KEY    equ     4bh
    RIGHT_KEY   equ     4dh
    F1_KEY      equ     3bh
    F2_KEY      equ     3ch
    F3_KEY      equ     3dh
    F4_KEY      equ     3eh
    F5_KEY      equ     3fh
    F6_KEY      equ     40h
    F7_KEY      equ     41h
    F8_KEY      equ     42h
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

	.code
start:
    mov ax,@data
    mov ds,ax                   ; ustaw segment danych
    mov ah, 09h             
    lea dx, [CLS]               ; wyczyszczenie ekranu
    int 21h
    mov ah, 2h              
    mov dh, 12                  ; usttawienie wiersza 
    mov dl, 40                  ; ustawienie kolumny
    int 10h
    loop1:
        xor ax, ax
        mov ah, 8h 			    ; funkcja odczytu znaku z klawiatury bez echa i zapisu do rejestru al
        int 21h				    ; przerwanie dos
        cmp al, ESC_KEY         ; porownanie wpisanego znaku z kodem klawisza ESC
        je koniec               ; skok na koniec jesli ESC
        cmp al, 00h             ; porównanie czy al = 0     
        jnz loop1               ; jeśli nie 0, skok do loop1
        xor ax, ax              ; zerowanie ax
        mov ah, 8h 			    ; funkcja odczytu znaku z klawiatury bez echa i zapisu do rejestru al
        int 21h				    ; przerwanie dos
        cmp al, UP_KEY          ; skok do up jeśli wcisnieto strzalke do gory
        je up
        cmp al, DOWN_KEY        ; skok do down jeśli wcisnieto strzalke w dol
        je down
        cmp al, LEFT_KEY        ; skok do left jeśli wcisnieto strzalke w lewo
        je left
        cmp al, RIGHT_KEY       ; skok do right jeśli wcisnieto strzalke w prawo
        je right
        cmp al, F1_KEY
        je F1
        cmp al, F2_KEY
        je F2
        cmp al, F3_KEY
        je F3
        cmp al, F4_KEY
        je F4
        cmp al, F5_KEY
        je F5
        cmp al, F6_KEY
        je F6
        cmp al, F7_KEY
        je F7
        cmp al, F8_KEY
        je F8
    jmp loop1                   ; jeśli wciśnięty klawisz inny niż enter skocz do etykiety petla
    
    koniec:
        mov	ax, 4c00h		    ; funkja zakończenia programu
        int	21h	

; rysowanie za pomocą kursora:
    up:
        call read 
        mov ah, 2h
        dec dh
        int 10h
        call draw
        jmp loop1
    down:
        call read
        mov ah, 2h
        inc dh
        int 10h
        call draw
        jmp loop1
    left:
        call read
        dec dl
        mov ah, 2h
        int 10h
        call draw
        jmp loop1
    right:
        call read
        inc dl
        mov ah, 2h
        int 10h
        call draw
        jmp loop1

; zmiana kolorów:
    F1:
        lea dx, [GREY]
        call set_color_dim
        jmp loop1
    F2:
        lea dx, [BLUE]
        call set_color_dim
        jmp loop1
    F3:
        lea dx, [GREEN]
        call set_color_dim
        jmp loop1
    F4:
        lea dx, [BLUE]
        call set_color_bright
        jmp loop1
    F5:
        lea dx, [RED]
        call set_color_dim
        jmp loop1
    F6:
        lea dx, [PINK]
        call set_color_bright
        jmp loop1
    F7:
        lea dx, [YELLOW]
        call set_color_dim
        jmp loop1
    F8:
        lea dx, [GREY]
        call set_color_bright
        jmp loop1

        
; procedura odczytu pozycji kursora
    read proc   
        mov ah, 03h             ; funkcja odczytu pozycji 
        int 10h                 ; wywołanie przerwania BIOS
        ret                     ; powrót
    read endp

; procedura ustawiania koloru tła
    set_color_bright proc
        mov ah, 09h             ; wpisz nr funkcji do al
        push dx                 ; odłóż kod koloru na stos  
        lea dx, [RESET_COL]     ; reset ustawienia kolorów
        int 21h                 ; wywołaj funkcje przez przerwanie DOS  
        lea dx, [BRIGHT_COL]    ; ustaw jasne kolory
        int 21h                 ; wywołaj funkcje przez przerwanie DOS
        pop dx                  ; ponbierz kod koloru ze stosu
        int 21h                 ; wywołaj funkcje przez przerwanie DOS
        ret                     ; powróc
    set_color_bright endp
    
    set_color_dim proc
        mov ah, 09h             ; wpisz nr funkcji do al
        push dx                 ; odłóż kod koloru na stos
        lea dx, [RESET_COL]     ; reset ustawienia kolorów
        int 21h                 ; wywołaj funkcje przez przerwanie DOS
        lea dx, [DIM_COL]       ; ustaw ciemny kolory
        int 21h                 ; wywołaj funkcje przez przerwanie DOS
        pop dx                  ; ponbierz kod koloru ze stosu
        int 21h                 ; wywołaj funkcje przez przerwanie DOS
        ret                     ; powróc
    set_color_dim endp

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