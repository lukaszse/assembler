DOSSEG
    .MODEL SMALL
    .STACK 100H
    .CODE
     MOV AH, 01H ; Character input with echo
     INT 21H ; Character in AL
     MOV BL, AL ; Save in BL    

     MOV AH, 01H ; Character input with echo
     INT 21H ; Character in AL
     MOV CL, AL ; Save in CL

     MOV AH, 01H ; Character input with echo
     INT 21H ; Character in AL
;    MOV DL, AL ; Save in DL
     MOV CH, AL ; <============================

     MOV AH, 02H ; Display character function    

     MOV DL, 0DH ; carriage return
     INT 21H

     MOV DL, 0AH ; line feed
     INT 21H  

     MOV DL, BL ; Get character stored in BL and display
     INT 21H   
     MOV DL, CL ; Get character stored in BL and display
     INT 21H  
;    MOV DL, DL ; Get character stored in BL and display
     MOV DL, CH ; <============================
     INT 21H  

     MOV AH, 4CH
     INT 21H
     END