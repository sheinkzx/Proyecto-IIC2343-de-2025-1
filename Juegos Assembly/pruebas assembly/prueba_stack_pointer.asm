DATA:
led 15
sw 0
dis 0
btn 0
sec 0
msec 0
usec 0

CODE:
MOV A, 8
MOV (led), A
PUSH A
INC (0FFFh)
MOV B, (0FFFh)
MOV (dis), B


