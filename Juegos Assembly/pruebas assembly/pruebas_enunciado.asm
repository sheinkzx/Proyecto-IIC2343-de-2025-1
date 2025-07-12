 DATA:
 CODE: //Pseudo Reloj |Velocidad declock a"full"
 loop:
 MOV A,(4) //|
 MOV (2),A //|MostrarSegundosen elDisplay
 MOV B,(5) //|
 MOV (0),B //|YMilisegundos en losLeds
 JMP loop // Repetir