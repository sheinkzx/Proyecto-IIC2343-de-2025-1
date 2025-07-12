DATA: //Creando las variables para la lectura de componentes
led 0
sw 0
dis 0
btn 0
sec 0
msec 0
usec 0
CODE: //Empezando el codigo
click:
MOV A, (btn)   //Se guarda en A el estado del botón (1, 2, 4, 8, 16 (Son los bits 0, 1, 2, 3, 4 respectivamente))
MOV (dis), A   //Muestra el valor del boton en el display
CMP A, 1
JEQ boton_1     //Si no se apreta el boton sigue bucle

CMP A, 2
JEQ boton_2     //Si no se apreta el boton sigue bucle

CMP A, 4
JEQ boton_3     //Si no se apreta el boton sigue bucle

CMP A, 8
JEQ boton_4     //Si no se apreta el boton sigue bucle

CMP A, 16
JEQ boton_5     //Si no se apreta el boton sigue bucle

JMP click       //Vuelve al bucle


boton_1:
MOV B, 1h
MOV (led), B    // Se prende el primer 1er led
JMP click

boton_2:
MOV B, 3h
MOV (led), B    // Se prende los 2 primeros leds
JMP click

boton_3:
MOV B, 7h
MOV (led), B    // Se prende los 3 primeros leds
JMP click

boton_4:
MOV B, Fh
MOV (led), B    // Se prende los 4 primeros leds
JMP click

boton_5:
MOV B, 1Fh
MOV (led), B    // Se prende los 5 primeros leds
JMP click

