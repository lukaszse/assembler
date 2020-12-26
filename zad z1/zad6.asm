program segment
org 100h
assume cs:program

start:
        mov ax, 0               ; znak w kodzie ASCII od którego zostanie uruchomione wyświetlanie
        mov cx, 256             ; ilość znaków do wyświetlenia
        mov bx, 10             ; dzielnik           

petla:
        push ax
        xor dx, dx              ; zerowanie dx przed dzieleniem
        div bx                  ; dzielenie ax/bx
        add dx, 48              ; dodajemy 48 aby uzyskać nr w kodzie ASCII 
        push dx                 ; dodajemy dx na stos

        xor dx, dx              ; zerowanie dx przed dzieleniem
        div bx                  ; dzielenie ax/bx
        add dx, 48              ; dodajemy 48 aby uzyskać nr w kodzie ASCII  
        push dx                 ; dodajemy dx na stos
        
        xor dx, dx              ; zerowanie dx przed dzieleniem
        div bx                  ; dzielenie ax/bx
        add dx, 48              ; dodajemy 48 aby uzyskać nr w kodzie ASCII 
        mov ah, 02h             ; do rejestru ah wpisujemy kod funkcji  odpowiedzialnej za wyswietlenie znaku
        int 21h                 ; uruchamiamy przerwanie DOS

        xor dx, dx
        pop dx
        mov ah, 02h             ; do rejestru ah wpisujemy kod funkcji  odpowiedzialnej za wyswietlenie znaku
        int 21h                 ; uruchamiamy przerwanie DOS
        
        pop dx
        mov ah, 02h             ; do rejestru ah wpisujemy kod funkcji  odpowiedzialnej za wyswietlenie znaku
        int 21h                 ; uruchamiamy przerwanie DOS

        mov dx, '['
        int 21h                 ; uruchamiamy przerwanie DOS
        
        pop dx
        int 21h                 ; uruchamiamy przerwanie DOS
        push dx

        mov dx, ']'
        int 21h                 ; uruchamiamy przerwanie DOS
        
        ; drukowanie znaku nowej linii, powrot karetki
        mov dl, 0Ah
        int 21h
        mov dl, 0Dh
        int 21h

        xor ax, ax
        pop ax
        inc ax

loop petla                ; jesli cx>0 wracamy do etykiety petla


koniec:                        
        mov ax, 4c00h
        int 21h

program ends
end start