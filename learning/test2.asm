program segment
org 100h
assume cs:program

start:
        mov cx, 10              ; liczba wierszy
        mov ax, 65              ; kod znaku ASCII
        mov bx, 10

petla:
        push cx
        push ax

        xor cx, cx
        numbers:        
                xor dx, dx
                div bx                  ; dzielenie ax/10
                add dx, 48              ; dodajemy kod znaku '0' 
                push dx                 ; cyfra na stos
                xor dx, dx
                inc cx
                cmp ax, 0
        jnz numbers

        mov ah, 02h                     ; display character
        
        print:
                pop dx
                int 21h                 ; interrupt
        loop print
        
        xor dx, dx
        mov dx, '['
        int 21h                         ; interrupt
        
        xor dx, dx
        pop dx
        int 21h                         ; interrupt
        push dx                         ; -> spushowane v

        mov dx, ']'
        int 21h                         ; interrupt
        
        ; drukowanie znaku nowej linii, powrot karetki
        mov dl, 0Ah
        int 21h
        mov dl, 0Dh
        int 21h

        xor ax, ax
        pop ax
        pop cx
        inc ax
        push ax

loop petla                      ; zmniejszamy cx i wykonujemy skok jesli cx > 0 (pozostala liczba wierszy do wydrukowania > 0)

koniec:                         ; oddajemy kontrole
        mov ax, 4c00h
        int 21h

program ends
end start