DATA: //Creando las variables para la lectura de componentes
led 0
sw 0
dis 0
btn 0
sec 0
msec 0
usec 0
CODE: //Empezando el codigo

////////////////////SALA DE ESPERA////////////////////////
sala_espera:
MOV D, 0
MOV (led), D  //Leds apagados
MOV D, EDCCh
MOV (dis), D  //Sala de espera
MOV A, (sw)
CMP A, 8000h    //Cuando se active la ultima palanca empieza
JEQ inicio

//Registro de jugadores en la sala de espera
MOV B, (btn)
CMP B, 1
JEQ jugador_1
CMP B, 2
JEQ jugador_2
CMP B, 4
JEQ jugador_3
CMP B, 8
JEQ jugador_4
CMP B, 16
JEQ jugador_5
JMP sala_espera
////////////////////////////////////////////////////////

/////////////////////JUGADORES//////////////////////////
jugador_1:
MOV C, 1
MOV (dis), C
MOV B, (btn)
CMP B, 0
JEQ sala_espera
JMP jugador_1

jugador_2:
MOV C, 2
MOV (dis), C
MOV B, (btn)
CMP B, 0
JEQ sala_espera
JMP jugador_2

jugador_3:
MOV C, 3
MOV (dis), C
MOV B, (btn)
CMP B, 0
JEQ sala_espera
JMP jugador_3

jugador_4:
MOV C, 4
MOV (dis), C
MOV B, (btn)
CMP B, 0
JEQ sala_espera
JMP jugador_4

jugador_5:
MOV C, 5
MOV (dis), C
MOV B, (btn)
CMP B, 0
JEQ sala_espera
JMP jugador_5

////////////////////////////////////////////////////////


////////////////////////INICIO///////////////////////////
inicio:
MOV C, (sec)   //Guarda los segundos del instante
MOV A, 3  // comenzaremos a mostrar el numero 3    

cuenta_regresiva:
MOV (dis), A     // mostramos el numero actual :D

CMP A, 0 // contamos hasta 0
JEQ esperar_reaccion 

esperar_segundo:
MOV B, (sec)
CMP B, C
JEQ esperar_segundo
INC C            // esperamos el siguiente segundo
DEC A            // vamos descreciendo el numero

//Parte el juego cuando llegue a 0
JMP cuenta_regresiva

////////////////////////ESPERAR REACCION////////////////////////////////

esperar_reaccion:
MOV A, (msec)   // guardamos el tiempo actual del timer

espera_btn: // esperamos que los jugadores presionen el boton
MOV B, (btn)
CMP B, 0
JEQ espera_btn //si alguien lo presiono se termina el bucle

//Cuando alguien presione el boton continua aca

MOV C, (msec)   // se guarda el tiempo actual de quien presiono
SUB C, A        // C = tiempo_final - tiempo_inicio

MOV (led), C    // el cuanto se demoro se proyecta en el LED

// SE COMPRUEBA QUIEN PRESIONO EL BOTON PARA HACER EL SALTO!!
CMP B, 1
JEQ mostrar_jugador_1
CMP B, 2
JEQ mostrar_jugador_2
CMP B, 4
JEQ mostrar_jugador_3
CMP B, 8
JEQ mostrar_jugador_4
CMP B, 16
JEQ mostrar_jugador_5

JMP fin_juego

mostrar_jugador_1:
MOV D, 1
MOV (dis), D
JMP fin_juego

mostrar_jugador_2:
MOV D, 2
MOV (dis), D
JMP fin_juego

mostrar_jugador_3:
MOV D, 3
MOV (dis), D
JMP fin_juego

mostrar_jugador_4:
MOV D, 4
MOV (dis), D
JMP fin_juego

mostrar_jugador_5:
MOV D, 5
MOV (dis), D
JMP fin_juego


fin_juego:
MOV A, (sw)
CMP A, 8000h
JEQ fin_juego   // si todavia no se baja el switch sigue esperando

JMP sala_espera // si se bajo, reinicia el juego
