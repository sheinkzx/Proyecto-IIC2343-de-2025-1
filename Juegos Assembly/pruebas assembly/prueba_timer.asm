DATA: //Creando las variables para la lectura de componentes
led 0
sw 0
dis 0
btn 0
sec 0
msec 0
usec 0
CODE: //Empezando el codigo

MOV A, 3        //Maximo de segundos
MOV C, 0        //Se usa este reg para comparar si los segundos cambiaron

timer:   //Crearemos un reloj cuenta recresiva
MOV (dis), A    //Se muestra el tiempo actual en display
MOV B, (sec)    //Se guardan los segundos actuales
CMP B, C        //Se comparan los registros
JNE tiempo      //Si el tiempo cambia, salta...

continuar:      //Revisa si A == 0
CMP A, 0        //En caso de que el tiempo acabe
JEQ start       //Salta para "Empezar algo"
JMP timer       //Vuelve al timer


tiempo:
SUB A, 1    //Se resta 1 en el display
INC C       //Se suma 1 en C
JMP continuar


start:
MOV (dis), A    //Se muestra el tiempo actual en display
MOV A, AAAAh
MOV (led), A
