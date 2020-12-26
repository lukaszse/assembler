program segment
org 100h
assume cs:program

start:

    mov cx, 03h                                    ; wpisanie wartości 3 do rejestru cx (ilosc linijek do wyswietlenia)

    petla_zew:

            push cx                                 ; wpisanie wartosci cx na stos
            
            xor cx, cx
            mov cx, word ptr ds:[iloscSpacji]       ; wpisanie zawartosci rejestru bx do cx (ilość spacji do wyswietlenia)
            cmp cx, 0
            jz wyswietlanie                         ; przeskok wtkonania pętli 2 jeśli cx = 0 
            petla_spacje:
                mov dl, ' '                         ; wpisanie znaku spacja do rejestri dl
                mov ah, 02h                         ; wpisaniie nr funkcji DOS do rejestru ah
                int 21h                             ; wywołanie przerrwania DOS
            loop petla_spacje                             ; petla powtarza sie jesli cx>0, cx jest automatycznie dekrementowane przy kazdej petli

            wyswietlanie:
            mov dl, 'A'                             ; wpisanie znaku do rejestru dl
            mov cx, 4                               ; wpisanie wartosci 10 do rejestru cx (ilosc powtorzen petli)
            petla_znaki:
                mov ah, 02h                         ; wpisaniie nr funkcji DOS do rejestru ah
                int 21h                             ; wywołanie przerrwania DOS
                inc dl                              ; inkrementacja dl
            loop petla_znaki                        ; petla powtarza sie jesli cx>0, cx jest automatycznie dekrementowane przy kazdej petli
            
            mov dl, '*'                             ; wpisanie znaku * do dl
            mov ax, 6                               ; ilosc gwiazdek do wyswietlenia
            sub ax, word ptr ds:[iloscspacji]       ; ilosc gwiazdek pomniejszana o ilość wyswietlonych spacji
            mov cx, ax                              ; przypisanie do rejestru cx ilosci gwiazdek do wyswielenia
            petla_gwiazdki:
                mov ah, 02h                         ; wpisaniie nr funkcji DOS do rejestru ah
                int 21h                             ; wywołanie przerrwania DOS
            loop petla_gwiazdki    
            add word ptr ds:[iloscSpacji], 02h      ; dodanie 02h do bx (zwiekszenie ilosci spacji)
                        
            ; koniec linii oraz powrót karetki:
            mov dl, 0Ah
            int 21h
            mov dl, 0Dh
            int 21h

            xor cx, cx
            pop cx                                  ; wpisanie wartości ze stosu do cx
    LOOP petla_zew
    

koniec:
        mov ax, 4c00h
        int 21h

iloscSpacji     dw      0h

program ends
end start