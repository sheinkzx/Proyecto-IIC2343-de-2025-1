DATA: //Creando las variables para la lectura de componentes
led 0
sw 0
dis 0
btn 0
sec 0
msec 0
usec 0
CODE: //Empezando el codigo

MOV C, 1

timer:   //Crearemos un reloj para ver si los segundos es un incremento o es un valor
MOV A, (sec)    //Segundos guardados en A
CMP A, C        //Si A = C, carga
JEQ cargar
JMP timer

cargar:
ADD B, (sec)    //Se le suma a B los segundos
INC C   //Se aumenta C
MOV (dis), B    //Se muestra el valor de B en el display
JMP timer

//Se concluye que los segundos son un valor y no un incremento