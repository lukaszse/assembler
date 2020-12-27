program segment
org 100h
assume cs:program

start:
        mov ax, 65                      ; znak w kodzie ASCII od którego zostanie uruchomione wyświetlanie
        mov cx, 10                      ; ilość znaków do wyświetlenia
        mov bx, 10                       ; dzielnik           

petla:
        push cx
        push ax
        xor cx, cx

        ; algorytm konwersji kodu ASCII na liczbe
        ascii_to_number:
                xor dx, dx              ; zerowanie dx przed dzieleniem
                div bx                  ; dzielenie ax/bx
                add dx, 48              ; dodajemy 48 aby uzyskać nr w kodzie ASCII 
                push dx                 ; dodajemy dx na stos
                inc cx                  ; inkrementacja licznika
                cmp ax, 0               
        jnz ascii_to_number
        
        mov ah, 2h                      ; funkcja wyświetlenia znku
        wystwietl:
                pop dx
                int 21h
        loop wystwietl
        
        mov dl, '['
        int 21h                         ; uruchamiamy przerwanie DOS
        
        pop dx
        int 21h                         ; uruchamiamy przerwanie DOS
        push dx

        mov dl, ']'
        int 21h                         ; uruchamiamy przerwanie DOS
        
        ; drukowanie znaku nowej linii, powrot karetki
        mov dl, 0Ah
        int 21h
        mov dl, 0Dh
        int 21h

        pop ax
        inc ax
        pop cx

loop petla                ; jesli cx>0 wracamy do etykiety petla


koniec:                        
        mov ax, 4c00h
        int 21h

program ends
end start