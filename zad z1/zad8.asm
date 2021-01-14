program segment
org 100h
assume cs:program

start:
        mov cx, 10                      ; dlugosc boku               
        mov bx, cx               
        mov ah, 02h             

; lewy gorny naroznik
        mov dx, 201
        int 21h


; linia pozioma
        add cx, cx                      ; pomnozenie cx x2 w celu wyswietlenia kwadratu o rownych bokach            
        horizontal:
                mov dx, 205
                int 21h
        loop horizontal

; prawy gorny naroznik
        mov dx, 187
        int 21h


        mov dl, 0Ah
        int 21h
        mov dl, 0Dh
        int 21h
        mov cx, bx
        sub cx, 2                      ; pomnozenie cx x2 w celu wyswietlenia kwadratu o rownych bokach 

; linie pionowe
vertical:
        push cx             
        mov dx, 186
        int 21h

        mov cx, bx
        add cx, cx
        wnetrze_kwadr:
                mov dx, 177            ; wypelnienie 
                int 21h
        loop wnetrze_kwadr
        mov dx, 186
        int 21h                 
        mov dl, 0Ah
        int 21h
        mov dl, 0Dh
        int 21h
        pop cx
loop vertical


; lewy dolny naroznik
        mov dx, 200
        int 21h

; linia pozioma
        mov cx, bx
        add cx, cx               ; pomnozenie cx x2 w celu wyswietlenia kwadratu o rownych bokach
        horizontal2:
                mov dx, 205
                int 21h
        loop horizontal2

; prawy dolny naroznik 
        mov dx, 188
        int 21h

        mov dl, 0Ah
        int 21h
        mov dl, 0Dh
        int 21h
        pop cx

koniec:                         ; oddajemy kontrole
        mov ax, 4c00h
        int 21h

program ends
end start