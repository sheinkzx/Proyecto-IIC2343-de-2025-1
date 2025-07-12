DATA: 
led 0
sw 0
dis 0
btn 0
sec 0
msec 0
usec 0

//Variables personales
numero_secreto 0
tiempo_p1 0 //Guarda el tiempo de los jugadores para despues comparar
tiempo_p2 0
milisegundos_p1 0
milisegundos_p2 0
turno 0 //Si es 1 es el turno del jugador 1, si es 2, del jugador 2

CODE: 

////////////////////SALA DE ESPERA////////////////////////
sala_espera:
MOV D, 0
MOV (led), D  //Leds apagados
MOV (turno), D  //Reinicia los turnos
MOV D, EDCCh
MOV (dis), D//Sala de espera
MOV A, (sw)
CMP A, 8000h    //Cuando se active la ultima palanca empieza
JEQ jugador_escoger_numero
JMP sala_espera
////////////////////////////////////////////////////////
//
//
///////////SALA PARA ESCOGER NUMERO DESESADO////////////
jugador_escoger_numero:
MOV D, 05E1h    //Select 
MOV (dis), D
MOV A, (sw)     //Guarda los valores del switch
MOV (led), A    //Muestra los leds segun switch
MOV B, (btn)    //Guarda el valor de los botones
CMP B, 4        //Si se apreta el boton del izquierdo, se guarda el numero.
JEQ guardar_numero
JMP jugador_escoger_numero
/////////////////////////////////////////////////////////
//
//
////////////////GUARDAR NUMERO Y RESETEAR////////////////
guardar_numero:
MOV (numero_secreto), A        //Guarda el numero deseado
JMP resetear


resetear:       //Para que el jugador baje los switches
MOV D, 0DE1h    
MOV (dis), D
MOV A, (sw)     //Guarda los valores del switch
MOV (led), A    //Muestra los leds segun switch
CMP A, 0        //Cuando se bajen todos los sw estara listo para partir
JEQ presiona_para_partir
JMP resetear
/////////////////////////////////////////////////////////
//
//
/////////////PREPARANDO TODO PARA PARTIR/////////////////
presiona_para_partir:
MOV A, AAAAh    //Listo para partir...
MOV (dis), A
MOV B, (btn)    
CMP B, 1    //Si se apreta el boton del centro, parte un contador para partir
JEQ asignar_jugador //Asigna el turno del jugador
JMP presiona_para_partir


asignar_jugador:
INC (turno) //Incrementa el turno a 1 o 2
JMP cuenta_recresiva


cuenta_recresiva:
MOV A, 5        //Segundos maximos
MOV B, (sec)    //Guarda los segundos de ese instante
bucle_segundos:
MOV (dis), A    //Muestra los segundos faltantes en el display
MOV C, (sec)    //Guarda los segundos actuales
CMP B, C
JNE restar_tiempo   //Si se igualan los tiempos se resta 1 de A
CMP A, 0
JEQ inicio      //Cuando se acabe el tiempo parte el codigo
JMP bucle_segundos


restar_tiempo:
DEC A
INC B           //Se cambia el valor del comparador por 1 segundo mas
JMP bucle_segundos
/////////////////////////////////////////////////////////
//
//
////////////////////////INICIO///////////////////////////
// A y B ocupados, solo quedan C y D
inicio:
MOV A, 0    //Guarda los segundos que se demora en adivinar
MOV B, (sec)    //Segundos del instante
tiempo_adivinar:
MOV C, (sec)    //Guarda los segundos actuales de la placa
CMP B, C        //Compara si se realiza un cambio
JNE sumar_tiempo
PUSH A 
PUSH B
PUSH C
CALL mover_switches
POP C
POP B
POP A
CMP D, AAAAh //En caso de que se adivine el numero
JEQ guardar_tiempos
JMP tiempo_adivinar
////////////////////////////////////////////////////////
//
//
////////////////////FUNCIONES///////////////////////////
//Recordar: A = tiempo total
// B = Segundos del instante
// C = Segundos actuales
sumar_tiempo:
INC A           // Aumenta A en 1
INC B           //Se cambia el valor del comparador por 1 segundo mas
JMP tiempo_adivinar


mover_switches:
MOV A, (sw)     //Guarda el valor de los sw sin prender los leds
MOV (led), A    //Prende las luces de la placa
MOV B, (btn)    //Registro que guarda el valor del boton 
CMP B, 4    //Revisa si se apretó el boton izquierdo
JEQ comparar_valor
RET   


//Usaremos el Reg D para guardar el valor del numero secreto
comparar_valor: //Comparará el valor del numero y el secreto
MOV C, (numero_secreto)
CMP A, C #Se comparan los numeros.
JGT mayor
CMP A, C #Se comparan los numeros.
JLT menor
CMP A, C #Se comparan los numeros.
JEQ ganador


retorno:
RET


mayor: //Para decir que el numero es mayor se representa como BIG
MOV D, b16h
MOV (dis), D
JMP retorno


menor: //Para decir que el numero es menor se representa como FALL
MOV D, FA11h
MOV (dis), D
JMP retorno


ganador:
MOV D, AAAAh //Valor identificador para casos ganadores
JMP retorno
////////////////////////////////////////////////////////
//
//
/////////////////FINAL DE RONDAS////////////////////////
//NO PUEDO ALTERAR EL VALOR DEL REGISTRO A
guardar_tiempos:
MOV D, 0
MOV (led), D //Apaga los leds
MOV D, (turno) //Compara que jugador esta jugando
CMP D, 1
JEQ turno_j1
CMP D, 2
JEQ turno_j2


termino_ronda:
MOV C, 6666h    //Termino de rondas = GGGG (6666)
MOV (dis), C
MOV B, (btn)    //Guarda los click del boton
CMP B, 2        //Si apreta el boton de arriba
JEQ mostrar_tiempo  //Para mostrar el tiempo
MOV D, (turno) 
CMP D, 1
JEQ jugador_1_presiona //Para ir a la siguiente ronda
CMP D, 2
JEQ jugador_2_presiona //Para terminar la partida
JMP termino_ronda
////////////////////////////////////////////////////////
//
//
/////////////FUNCIONES DE LA MEDIA RONDA////////////////
mostrar_tiempo:
MOV D, (turno) //Compara que jugador esta jugando
CMP D, 1
JEQ mostrar_j1
CMP D, 2
JEQ mostrar_j2
////////////////////////////////////////////////////////
//
//
/////////////////DATOS DE TURNOS////////////////////////
turno_j1:
MOV (tiempo_p1), A  //Guarda el tiempo
MOV B, (msec)   //Guardando los milisegundos
MOV (milisegundos_p1), B
JMP termino_ronda


turno_j2:
MOV (tiempo_p2), A  //Guarda el tiempo
MOV B, (msec)   //Guardando los milisegundos
MOV (milisegundos_p2), B
JMP termino_ronda


mostrar_j1:     //Muestra los tiempo en el display
MOV D, (tiempo_p1)  
MOV (dis), D
MOV B, (btn)    
CMP B, 1    //Si apreta el boton del centro vuelve a la media ronda
JEQ termino_ronda
CMP B, 8    //Si apreta el boton derecho muestra los milisegundos
JEQ mostrar_milisegundos_p1
JMP mostrar_j1
 

mostrar_j2: //Muestra los tiempo en el display
MOV D, (tiempo_p2)  
MOV (dis), D
MOV B, (btn)    
CMP B, 1    //Si apreta el boton del centro vuelve a la media ronda
JEQ termino_ronda
CMP B, 8    //Si apreta el boton derecho muestra los milisegundos
JEQ mostrar_milisegundos_p2
JMP mostrar_j2


mostrar_milisegundos_p1:
MOV D, (milisegundos_p1)  
MOV (dis), D
MOV B, (btn)    
CMP B, 2    //Si apreta el boton de arriba vuelve a mostrar los segundos
JEQ mostrar_j1  
JMP mostrar_milisegundos_p1


mostrar_milisegundos_p2:
MOV D, (milisegundos_p2)  
MOV (dis), D
MOV B, (btn)    
CMP B, 2    //Si apreta el boton de arriba vuelve a mostrar los segundos
JEQ mostrar_j2
JMP mostrar_milisegundos_p2


jugador_1_presiona:
MOV B, (btn)
CMP B, 8    //Si apreta el boton de la derecha
JEQ jugador_escoger_numero //Ir a la siguiente ronda
JMP termino_ronda


jugador_2_presiona:
MOV B, (btn)
CMP B, 8    //Si apreta el boton de la derecha
JEQ comparar_ganadores //Ir a la siguiente ronda
JMP termino_ronda
////////////////////////////////////////////////////////
//
//
/////////////////FINAL DE PARTIDA////////////////////////

//Registro A guarda el tiempo p1
//Registro B guarda el tiempo p2
comparar_ganadores:
MOV A, (tiempo_p1)
MOV B, (tiempo_p2)
CMP A, B 
JLT ganador_p1
CMP A, B 
JGT ganador_p2
CMP A, B
JEQ desempate //En caso de que esten iguales los segundos
JMP comparar_ganadores
////////////////////////////////////////////////////////
//
//
////////////FUNCIONES PARA EL FIN DE PARTIDA////////////
desempate:
MOV A, (milisegundos_p1)
MOV B, (milisegundos_p2)
CMP A, B 
JLT ganador_p1
CMP A, B 
JGT ganador_p2
CMP A, B
JMP desempate

ganador_p1:
MOV D, 1111h //Muestra eso porque ganó el jugador 1
MOV (dis), D
MOV B, (btn)
CMP B, 2    //Si se apreta el boton de arriba
JEQ ganador_tiempo_p1
MOV C, (sw)
CMP C, 1    //Si se activa el sw de la derecha
JEQ limpiar_datos
JMP ganador_p1


ganador_p2:
MOV D, 2222h //Muestra eso porque ganó el jugador 2
MOV (dis), D
MOV B, (btn)
CMP B, 2    //Si se apreta el boton de arriba
JEQ ganador_tiempo_p2
MOV C, (sw)
CMP C, 1    //Si se activa el sw de la derecha
JEQ limpiar_datos
JMP ganador_p2


ganador_tiempo_p1:
MOV A, (tiempo_p1)
MOV (dis), A
MOV B, (btn)
CMP B, 1 //Si se apreta el boton del centro
JEQ ganador_p1
CMP B, 8    //Para mostrar los milisegundos del ganador
JEQ milisegundos_ganador_p1
JMP ganador_tiempo_p1


ganador_tiempo_p2:
MOV A, (tiempo_p2)
MOV (dis), A
MOV B, (btn)
CMP B, 1 //Si se apreta el boton del centro
JEQ ganador_p2
CMP B, 8    //Para mostrar los milisegundos del ganador
JEQ milisegundos_ganador_p2
JMP ganador_tiempo_p2


milisegundos_ganador_p1:
MOV A, (milisegundos_p1)  
MOV (dis), A
MOV B, (btn)    
CMP B, 2    //Si apreta el boton de arriba vuelve a mostrar los segundos ganadores
JEQ ganador_tiempo_p1  
JMP milisegundos_ganador_p1


milisegundos_ganador_p2:
MOV A, (milisegundos_p2)  
MOV (dis), A
MOV B, (btn)    
CMP B, 2    //Si apreta el boton de arriba vuelve a mostrar los segundos ganadores
JEQ ganador_tiempo_p2  
JMP milisegundos_ganador_p2


limpiar_datos:  //Funcion que limpia todos los registros o variables
MOV A, 0
MOV B, 0
MOV C, 0
MOV D, 0
MOV (numero_secreto), A
MOV (tiempo_p1), A
MOV (tiempo_p2), A
JMP sala_espera