program segment
org 100h
assume cs:program

start:

    mov cx, 03h
    mov bx, 02h

    petla0:

            push cx
            mov dl, 'A'
            mov cx, 8

            petla1:

                mov ah, 02h
                int 21h
                inc dl

            LOOP petla1
                        
            mov dl, 0Ah
            int 21h
            mov dl, 0Dh
            int 21h
            
            mov cx, bx
            petla2:

                mov dl, ' '
                int 21h
            
            LOOP petla2
            add bx, 02h

            pop cx
    LOOP petla0
    

koniec:
        mov ax, 4c00h
        int 21h

program ends
end start