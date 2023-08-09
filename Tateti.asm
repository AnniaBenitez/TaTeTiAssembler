;Tateti.asm
;Author: Annia Micaela Benitez Hofbauer
;Date:11 de Octubre del 2022                
.model small
.stack 256
    CR equ 13d
    LF equ 10d   
.data    
    ;Menu principal - textos
    titulo db 'TA - TE - TI ',CR,LF,'Formato de juego: ',CR,LF,'  1   2   3',CR,LF,'  4   5   6',CR,LF,'  7   8   9',CR,LF, '$' 
    mensaje2 db CR,LF,'Valor incorrecto! ',CR,LF,'$' 
    pausa db CR, LF, 'Presione cualquier letra para continuar','$'
    turnoJugador db 'Es su turno! elija un numero de casilla del 1 al 9!!',CR, LF,'$'
    turnoMaquina db 'Turno de la maquina!!',CR, LF,'$' 
    peticion db CR,LF,'Ingrese un numero: ','$'
    usuarioWIN db CR,LF,'Felicidades! usted gano el juego!',7,'$'
    maquinaWIN db CR,LF,'La computadora gano el juego!!! ',7,'$'
    empate db CR,LF,'EMPATE  :( !!! ',7,'$'  
    repetido db CR,LF,'Valor repetido, vuelva a intentar...','$'
    
    ;Variables string      
    tablero db 176d,176d,176d,176d,176d,176d,176d,CR,LF,176d,' ',176d,' ',176d,' ',176d,CR,LF,176d,176d,176d,176d,176d,176d,176d,CR,LF,176d,' ',176d,' ',176d,' ',176d,CR,LF,176d,176d,176d,176d,176d,176d,176d,CR,LF,176d,' ',176d,' ',176d,' ',176d,CR,LF,176d,176d,176d,176d,176d,176d,176d,CR,LF,'$'  
        
    ;Variables numericas y caracteres
    a db 176d
    b db 176d
    c db 176d
    d db 176d
    e db 176d
    f db 176d
    g db 176d
    h db 176d
    i db 176d 
    contador db 0 
    contador2 db 0  
    caracter db ?
    
.code   
start:   
    mov ax, @data
    mov ds, ax 
    ; exhibe el menu principal     
    mov dx, offset titulo                  
    call puts   
    call pausaLectura  
    ;Una vez demostrado el formato, se juega
    call jugar 
    ;Si nadie gana, se declara empate y se termina el juego
    call declararEmpate           
    
;Subrutinas/////////////////////////////////////////////////////
;Se imprime el tablero de juego
    imprimirTablero:
        mov dx, offset tablero                  ;Se extrae el texto               
        call puts                               ;Se imprime el texto
        ret             

;Jugar hasta que alguien gane
    jugar: 
        inc contador                            ;Como pueden haber 9 rondas, se incrementa el contador  
        mov caracter,'X'                        ;Se toma la Equiz para el usuario
        call jugarUsuario                       ;El usuario juega
        call comprobarGanador                   ;Se comprueba que el usuario no haya ganado
        cmp contador,9                          ;Se comprueba la cantidad de rondas jugadas
        je declararEmpate                       ;Si ya se jugaron 9 rondas y no hay ganador, se declara empate
        inc contador                            ;Se incrementa el contador de rondas
        mov caracter,'O'                        ;Se toma el circulo para la maquina
        call jugarMaquina                       ;La maquina juega usando numeros random
        call comprobarGanador                   ;Se comprueba que no haya ganado la maquina
        cmp contador,9                          ;Se vuelve a verificar la cantidad de rondas jugadas
        jne jugar                               ;Se vuelve a jugar si aun hay casillas 
        
;Si el juego se queda sin casillas y nadie gano, se declara empate
    declararEmpate:
        call limpiar_pantalla                   ;Se vacia la pantalla
        mov dx, offset empate                   ;Se toma el texto de aviso
        call puts                               ;Se imprime el aviso de empate
        call finalizar                          ;Termina el programa      
    
;Se imprime el titulo y el tablero refrescado        
    imprimirCabecera:
        call puts                               ;Se imprime el titulo
        call imprimirTablero                    ;Se imprime el tablero    
        ret
        
;Es el turno del usuario, elige una posicion disponible y juega
    jugarUsuario:
        call limpiar_pantalla                   ;Se limpia el contenido de la pantalla
        mov dx, offset turnoJugador             ;Se toma el titulo     
        call imprimirCabecera                   ;Se imprime el titulo y el tablero de juego
        ingresarDigito:                         ;Se ingresa un digito numerico entre el 1 y 9
            mov dx, offset peticion             ;Titulo de peticion de numero
            call puts                           ;Se imprime dicho titulo
            call getDigit                       ;Se obtiene el digito del jugador en al(ya verificado que sea numerico)
            call comprobarYRellenar             ;Se comprueba que la casilla no este ocupada y se rellena
            call limpiar_pantalla               ;Se limpia pantalla
            mov dx, offset turnoJugador         ;Se vuelve a imprimir la cabecera, ahora..
            call imprimirCabecera               ;.. con los valores actualizados
            call PausaLectura                   ;se presiona cualquier tecla para continuar
        ret
    
;La maquina juega su turno
    jugarMaquina:  
        call limpiar_pantalla                   ;Se limpia el contenido de la pantalla
        mov dx, offset turnoMaquina             ;Se toma el titulo     
        call imprimirCabecera                   ;Se imprime el titulo y tabla de juego
        call calcularRandom                     ;en dl se guarda valor random
        call comprobarYRellenar                 ;Se comprueba que el numero no este ocupado y se rellena
        call limpiar_pantalla                   ;Se limpia la pantalla 
        mov dx, offset turnoMaquina             ;Se toma el titulo 
        call imprimirCabecera                   ;Se vuelve a imprimir la cabecera, actualizada
        call PausaLectura                       ;Presione enter para continuar
        ret 
        
;Se comprueba que el espacio este vacio y se rellena si es el caso. Se recorre casilla a casilla
    comprobarYRellenar: 
        mov bx, offset tablero                  ;Se guarda la ubicacion del tablero 
        mov contador2,0                         ;Contador de posicion de casilla elegida por el usuario o maquina
        buscarCasilla:
            cmp byte ptr[bx],176d               ;Se compara si es caracter de borde o de casilla
            jne comprobarRellenar               ;Si hay una casilla u otro caracter, se verifica el contenido
            avanzar:                            ;Se sigue avanzando para buscar casillas en el array
                inc bx                          ;Se incrementa bx
                jmp buscarCasilla               ;Se repite el bucle de comparacion            
            ComprobarRellenar:                  ;Se verifica que exista un espacio casilla, lleno o no
                cmp byte ptr[bx],' '            ;Si es un espacio en blanco, se rellena si es el digito ingresado
                je rellenar                     ;Se rellena si es la posicion correcta
                cmp byte ptr[bx],'X'            ;Si es una X, se verifica que sea la posicion correcta
                je espacioOcupado               
                cmp byte ptr[bx],'O'            ;Si es un O, se verifica que sea la posicion correcta
                je espacioOcupado  
                cmp byte ptr[bx],0              ;Si es null, es el fin de la cadena y se prueba con otro digito
                je arreglarNumMaquina
                jmp avanzar                     ;Si no es ninguno de ellos, se sigue avanzando en la cadena                        
            rellenar:                           ;Se rellena la casilla si es la requerida por el usuario
                inc contador2                   ;Se incrementa el contador de casillas
                cmp al,contador2                ;Se compara que sea la casilla requerida por el usuario
                je intercambio                  ;Si es, se pone la X o O en el lugar
                jne avanzar                     ;Si aun no es la casilla, se sigue buscando                
            intercambio:                        ;Si es la casilla correcta, se hace el intercambio por X o O
                mov dl,caracter                 ;Se para el caracter elegido el dl
                mov byte ptr[bx],dl             ;Se modifica el array con dicho caracter
                ret                             ;SE RETORNA AL PROGRAMA                
            espacioOcupado:                     ;Si se detecta X o O,primero se verifica que sea el lugar ingresado
                inc contador2                   ;Se incrementa el contador de casillas
                cmp al,contador2                ;Si es el lugar ingresado, se procede a pedir ingreso nuevamente
                je intercambio2
                jne avanzar                     ;Si no es el lugar, se sigue acanzando              
            intercambio2:                       ;Peticion de cambio de numero de casilla
                cmp caracter, 'O'               ;Si se buscaba poner O, la maquina debe generar nuevo numero
                je arreglarNumMaquina           ;La maquina genera nuevo valor
                mov dx, offset repetido         ;Si es de usuario, se pide al usuario ingresar nuevo numero
                call puts                       ;Se imprime peticion
                cmp caracter, 'X'
                je IngresarDigito               ;Se pide al usuario ingresar nuevo numero de casilla vacia

;En caso de que la maquina genere un numero random repetido, se vuelve a generar                
    arreglarNumMaquina:
        call calcularRandom                     ;Se calcula numero random
        jmp comprobarYRellenar                  ;Se vuelve a comprobar y rellenar con el nuevo numero
    
;Se comprueba que el jugador actual no haya ganado. Se verifican todas las combinaciones posibles
    comprobarGanador: 
        call getValores                         ;Se guardan o actualizan valores de las tablas en variables individuales         
        mov ah,a                                ;Combinacion ABC
        mov al,b
        mov bl,c
        call comparar3                          ;Se compara que ABC sean iguales         
        mov ah,d
        mov al,e
        mov bl,f                                ;Combinacion DEF
        call comparar3                          ;Se compara que DEF sean iguales         
        mov ah,g
        mov al,h
        mov bl,i                                ;Combinacion GHI
        call comparar3                          ;Se compara que GHI sean iguales         
        mov ah,a
        mov al,d
        mov bl,g                                ;Combinacion ADG
        call comparar3                          ;Se compara que ADG sean iguales        
        mov ah,b
        mov al,e
        mov bl,h                                ;Combinacion BEH
        call comparar3                          ;Se compara que BEH sean iguales         
        mov ah,c
        mov al,f
        mov bl,i                                ;Combinacion CFI
        call comparar3                          ;Se compara que CFI sean iguales         
        mov ah,a
        mov al,e
        mov bl,i                                ;Combinacion AEI
        call comparar3                          ;Se compara que AEI sean iguales        
        mov ah,c
        mov al,e
        mov bl,g                                ;Combinacion CEG
        call comparar3                          ;Se compara que CEG sean iguales
        ret          
    
;Se pasan 3 valores para ver si son iguales    
    comparar3:
        cmp ah,' '                              ;Se compara que ah no sea un espacio en blanco, para que no gane por espacios en blanco
        jne condicionalComparar3                ;Si no es espacio en blanco, se compara 
        ret                                     ;Si es espacio en blanco, no se tiene en cuenta        
        condicionalComparar3:                   ;Se hace la primera comparacion
            cmp ah,al                           ;Se compara que ah y al sean iguales
            je condicionalComparar3_2           ;Si son iguales, se compara aun con el tercer valor
            ret                                 ;Si no son iguales, se ignora y retorna          
            condicionalComparar3_2:             ;Se compara con el valor que falta
                cmp ah,bl                       ;Se compara si ah tambien es igual a bl(tercer valor)
                je imprimirGanador              ;Si son iguales, hay un ganador
                ret                             ;Si no son iguales, se retorna    
                imprimirGanador:                ;Se imprime el mensaje final depende de quien gano
                    cmp al,'O'                  ;Si el caracter de la linea ganadora es O
                    je ganadorO                 ;Se procede segun O
                    cmp al,'X'                  ;Si el caracter de la linea ganadora es X
                    je ganadorX                 ;Se procede segun X      

;Si el usuario gana el juego...
    ganadorX:
        mov dx, offset usuarioWIN               ;Se toma el mensaje de ganador
        call puts                               ;Se imprime
        call finalizar                          ;Finaliza el programa
             
;Si la maquina gana el juego...
    ganadorO:
        mov dx, offset maquinaWIN               ;Se toma el mensaje de ganador
        call puts                               ;Se imprime
        call finalizar                          ;Finaliza el programa     
        
;Se guardan los valores de la tabla actuales
    getValores:
        mov bx,offset tablero                   ;Se toman todos los valores contenidos en   
        add bx,10                               ;Casillas del tablero y se pasan a variables
        mov dl,byte ptr[bx]                     ;independientes para poder comparar mas facilmente
        mov a,dl
        add bx,2 
        mov dl,byte ptr[bx]
        mov b,dl
        add bx,2 
        mov dl,byte ptr[bx]
        mov c,dl
        add bx,14  
        mov dl,byte ptr[bx]
        mov d,dl
        add bx,2   
        mov dl,byte ptr[bx]
        mov e,dl
        add bx,2   
        mov dl,byte ptr[bx]
        mov f,dl
        add bx,14   
        mov dl,byte ptr[bx]
        mov g,dl
        add bx,2 
        mov dl,byte ptr[bx]
        mov h,dl
        add bx,2  
        mov dl,byte ptr[bx]
        mov i,dl
        ret                           

;Se calcula un numero random y se guarda en dl    
    calcularRandom:
        mov ah, 0h         
        int 1ah                                 ;Se guarda el numero de ticks de reloj en cx y dx   
        mov ax, dx                              ;Se pasa el valor a ax solo de dx
        mov ah,0                                ;Trabajamos con el numero generado en al, descartando ah
        mov cl,100                              ;Se procede a hallar la unidad, se divide con 100
        div cl                                  ;El resto de la division se va a considerar, el entero se descarta
        mov al,ah                               ;Se toma el resto nomas
        mov ah,0                                ;Se descarta el entero
        mov cl,10                               ;Se divide con 10 el resto, para tener una unidad 
        div cl                                  ;Se hace la division
        mov al,ah                               ;La unidad obtenida se pasa a al, y es el numero random para la maquina    
        ret          

;Devuelve el digito convertido en al, ya verificando que sea entre 1 y 9
    getDigit:
        call getc                               ;Se pide el ingreso de un caracter
        cmp AL,49d                              ;Se verifica que no sea mejor que 49(1 en ascii)
        jl mensajeError                         ;Si es menor, se lanza error
        cmp AL,57d                              ;Se verifica que no sea mayor que 57(9 en ascii)
        jg mensajeError                         ;Si es mayor, se lanza error
        call convertir                          ;Se convierte a numero decimal
        ret    

;Convierte a decimal
    convertir:                                  
        sub al, 30h                             ;Se resta 30 hexa para pasar a numeros no ascii
        ret  
    
;Se imprime el mensaje de error y se vuelve a intentar
    mensajeError:
        mov dx, offset mensaje2                 ;Se extrae el mensaje     
        call puts                               ;Se imprime el mensaje        
        jmp getDigit                            ;Se vuelve a solicitar digito
        ret 
                
;Imprime un string en dx terminado en $
    puts:  
        push ax                                 ;Se guardan valores en los registros
        push bx
        push cx
        push dx
        mov ah,9h                               ;Se llama a la interruocion
        int 21h                                 ;para imprimir el string
        pop dx                                  ;Se recuperan valores del registro
        pop cx
        pop bx
        pop ax
        ret    
        
;lee caracter dentro de al
    getc: 
        push bx                                 ;Se guardan valores en los registros
        push cx 
        push dx 
        mov ah, 1h                              ;Se solicita el ingreso de un caracter
        int 21h                                 ;Mediante una interrupcion
        pop dx                                  ;Se recuperan los registros de la pila
        pop cx 
        pop bx 
        ret   
          
;limpia la pantalla del MS-DOS    
    limpiar_pantalla:         
        push ax                                 ;Se guardan valores en los registros
        push bx 
        push cx 
        push dx
        mov ah,00h                              ;Se limpia la pantalla de la consola
        mov al,03h                              ;Mediante un a interrupcion
        int 10h                                 ;Se recuperan los registros de la pila
        pop dx 
        pop cx 
        pop bx 
        pop ax     
        ret 
    
;Imprime un mensaje de presione cualquier tecla para continuar     
    pausaLectura:
        push ax                                 ;Se guardan valores en los registros
        push bx
        push cx
        push dx
        mov dx, offset pausa                    ;Mensaje de pausa
        call puts                               ;Se imprime el mensaje de pausa
        call getc                               ;Se pide ingreso de caracter para congelar el programa
        pop dx                                  ;Se recuperan los registros de la pila
        pop cx
        pop bx
        pop ax
        ret
        
;Se imprime un salto de linea
    imprimirSaltoLinea:     
        push ax                                 ;Se guardan valores en los registros
        push bx
        push cx
        push dx
        mov dl, CR                              ;Se imprime un Carriage return
        mov ah, 2h         
        int 21h
        mov dl, LF                              ;Se imprime un lineFeed
        mov ah, 2h
        int 21h 
        pop dx                                  ;Se recuperan los registros de la pila
        pop cx
        pop bx
        pop ax
        ret                       

;Termina el programa        
    finalizar:
        mov ax, 4c00h                           ;Se llama a una interrupcion que devuelve el control
        int 21h                                 ;al SO, finalizando el programa
               
end start