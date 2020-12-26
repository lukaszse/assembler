program segment
org 100h
assume cs:program

start:
            mov dl, 'A'
            mov cx, 10

        petla1:

            mov ah, 02h
            int 21h
            inc dl
            LOOP petla1

koniec:
        mov ax, 4c00h
        int 21h

program ends
end start