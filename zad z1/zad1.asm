program segment
org 100h
assume cs:program

start:
        mov dl, '*'
        mov ah, 02h
        int 21h

koniec:
        mov ax, 4c00h
        int 21h

program ends
end start