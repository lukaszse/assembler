program segment

org 100h
assume cs:program

start:

    mov bx, 03h                             ; ilosc liter do wyswietlenia zapisana w rejestrze bx
    mov cx, 03h                             ; ilosć linijek (powtorzen pętli
    petla0:                                 ; petla zewnetrzna (powtorzenie dla kazdej linijki)

            push cx
            xor dx, dx
            mov dl, 'A'                     ; wpisanie znaku 'A' do rejestru dl
            mov cx, bx                      ; wpisanie do rejestru cx zawartosci rejestru bx z iloscia liter do wyswietlenia

            petla1:                         ; petla wewnetrza (wyświetlanie znaków)
                mov ah, 02h                 ; wpisanie do rejestru ah kodu funkcji słuzącej do wyświetlenia znaku w kodzie ASCII
                int 21h                     ; wywyłanie przerwania DOS
                inc dl                      ; inkrementacja rejestru dl (zmiana znaku na kolejnyw  kodzie ASCII)
            LOOP petla1

            add bx, 03h                     ; zwiekszenie o 3 rejestru bx (zawierajaceggo ilosc liter do wyświetlenia)
                        
            ; znak konca linii i powrot karetki:
            mov dl, 0Ah
            int 21h
            mov dl, 0Dh
            int 21h    

            pop cx                          ; zdjęcie wartości ze stosu i wpisanie do rejestru cx

    LOOP petla0                             ; jeśli cx jest większ eniż 0, powrót do etykiety petla0
    

koniec:
        mov ax, 4c00h
        int 21h

program ends
end start