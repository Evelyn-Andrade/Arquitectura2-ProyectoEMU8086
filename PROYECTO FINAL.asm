.MODEL SMALL

.STACK 100h

.DATA  

     ;==================
     ;MENU DEL PROGRAMA
     ;==================
     MsgLinea1 db 10, 13,       "============================================================================$"
     MsgTitulo db 10, 13,       "              UNIVERSIDAD MARIANO GALVEZ - ARQUITECTURA 8086                $"
     MsgLinea2 db 10, 13,       "============================================================================$"
     MsgOption1 db 10, 13,      " 1. Clasificador de Caracteres                                              $"
     MsgOption2 db 10, 13,      " 2. Generador de Codigo Hamming (10 bits -> 14 bits)                        $"
     MsgOption3 db 10, 13,      " 3. Conversor de Bases Numericas (Decimal a Binario/Hex)                    $"
     MsgOption4 db 10, 13,      " 4. Juego Interactivo de Aritmetica por Mouse (3 Niveles / 12 preguntas)    $"
     MsgOption5  db 10, 13,     " 5. Salir del Sistema                                                       $"
     MsgLinea3 db 10, 13,       "============================================================================$"
     MsgElegir db 10, 13,       "Ingrese una opcion [1-5]: $"

     MsgErrorOpcionMenu db 10, 13, "Error, debe de elegir una opcion del 1 al 5$"
     
     ;==========
     ;DESPEDIDA
     ;==========
     MsgDespedida db 10, 13, "Hasta luego!$" 
     
     ;================
     ;PREGUNTAR SI/NO
     ;================  
     MsgPreguntaSiNo db 10, 13, "Deseas continuar (S/N)$" 

     ;=============
     ;CLASIFICADOR 
     ;=============
     MsgClasificadorCaracteres db 10, 13, "CLASIFICADOR DE CARACTERES$"
     MsgPedirCaracteres db 10, 13, "Ingrese caracteres (Max 50): $"
     
     MsgCantidad_Numeros db 10, 13, "La cantidad de numeros ingresados es: $"
     MsgCantidad_Mayusculas db 10, 13, "La cantidad de mayusculas es: $"
     MsgCantidad_Minusculas db 10, 13, "La cantidad de minusculas es: $"
     MsgCantidad_Especiales db 10, 13, "La cantidad de especiales es: $"
     
     ContMayusculas  db 0
     ContMinusculas  db 0
     ContNumeros     db 0
     ContEspeciales  db 0    
     
     buffer_caracter db 51
                     db ?
                     db 51 dup("?")     
     ;=============
     ;HAMMING 
     ;=============     
     MsgEstasOpcion2 db 10, 13, "HAS ELEGIDO LA OPCION 2$"
     
     ;=============
     ;CONVERSOR 
     ;=============
     MsgEstasOpcion3 db 10, 13, "HAS ELEGIDO LA OPCION 3$"
     
     ;=============
     ;JUEGO MOUSE 
     ;=============  
     MsgEstasOpcion4 db 10, 13, "HAS ELEGIDO LA OPCION 4$"
     
.CODE
main proc
     mov ax, @DATA
     mov ds, ax
     

;==========================================================================
;-------------------------------ZONA DE MENU-------------------------------  
;==========================================================================

INICIO_MENU:
             MOV AX, 0003H
             int 10h
;------------------------------------
;------------DIBUJAR MENU------------
;------------------------------------
             lea dx, MsgLinea1
             mov ah, 09h
             int 21h

             lea dx, MsgTitulo
             mov ah, 09h
             int 21h

             lea dx, MsgLinea2
             mov ah, 09h
             int 21h

             lea dx, MsgOption1
             mov ah, 09h
             int 21h   
             
             lea dx, MsgOption2
             mov ah, 09h
             int 21h   
             
             lea dx, MsgOption3
             mov ah, 09h
             int 21h
                          
             lea dx, MsgOption4
             mov ah, 09h
             int 21h

             lea dx, MsgOption5
             mov ah, 09h
             int 21h

             lea dx, MsgLinea3
             mov ah, 09h
             int 21h
;----------------------------------------
;------------PEDIR OPCION MENU-----------
;----------------------------------------
             lea dx, MsgElegir
             mov ah, 09h
             int 21h

             mov ah, 01h
             int 21h

             sub al, 30h 
             
;-----------------------------------------
;------------COMPARACIONES MENU-----------
;-----------------------------------------
             cmp al, 1
             je OPCION1

             cmp al, 2
             je OPCION2

             cmp al, 3
             je OPCION3

             cmp al, 4
             je OPCION4
             
             cmp al, 5
             je SALIR
             jmp ERROR_MENU   

;==============================================================================
;---------------------------------ZONA ETIQUETAS------------------------------- 
;==============================================================================
OPCION1:     
             MOV AX, 0003H
             int 10h   
             
             lea dx, MsgLinea1
             mov ah, 09h
             int 21h  
             
             lea dx, MsgClasificadorCaracteres
             mov ah, 09h
             int 21h
             
             lea dx, MsgLinea2
             mov ah, 09h
             int 21h 
             
             lea dx, MsgPedirCaracteres
             mov ah, 09h
             int 21h
              
             lea dx, buffer_caracter
             mov ah, 0Ah
             int 21h 
             
             lea si, buffer_caracter + 2
             
             mov ContMayusculas, 0
             mov ContMinusculas, 0
             mov ContNumeros, 0
             mov ContEspeciales, 0
             
CLASIFICAR_INICIO:
             mov al, [si]
             cmp al, 0Dh
             je  CLASIFICAR_MOSTRAR       
             
            ;-------------------------------------------------  
            ;-----------CONDICIONES PARA CLASIFICAR-----------
            ;-------------------------------------------------              
             
             cmp al, 30h
             jb ESPECIALES  
             
             cmp al, 39h
             jbe NUMERO   
             
             cmp al, 41h
             jb  ESPECIALES
             
             cmp al, 5Ah
             jbe LETRA_MAYUS 
             
             cmp al, 61h 
             jb  ESPECIALES
             
             cmp al, 7Ah
             jbe LETRA_MINUS 
             
             jmp ESPECIALES  
                
             NUMERO:
                    inc ContNumeros
                    inc si
                    jmp CLASIFICAR_INICIO

             LETRA_MAYUS:
                    inc ContMayusculas
                    inc si
                    jmp CLASIFICAR_INICIO
            
             LETRA_MINUS:
                    inc ContMinusculas
                    inc si
                    jmp CLASIFICAR_INICIO                   
            
             ESPECIALES:
                    inc ContEspeciales
                    inc si
                    jmp CLASIFICAR_INICIO
            
             CLASIFICAR_MOSTRAR:
             
                         ;NUMEROS
                         lea dx, MsgCantidad_Numeros
                         mov ah, 09h
                         int 21h  
                                 
                         mov al, ContNumeros  
                         mov ah, 0
                         
                         NUM_INICIO_UD1:  
                                
                                ;unidad
                                cmp al, 10
                                jb NUM_FINAL_UD1
                                
                                          
                                sub al, 10
                                inc ah 
                                jmp NUM_INICIO_UD1
                    
                         NUM_FINAL_UD1:
                         
                                ;UNIDAD
                                mov cl, al
                                
                                ;DECENA 
                                mov dl, ah 
                                add dl, 30h
                                mov ah, 02h 
                                int 21h   
                                
                                ;UNIDAD 
                                mov dl, cl 
                                add dl, 30h
                                mov ah, 02h 
                                int 21h
              
                         ;MAYUS
                         lea dx, MsgCantidad_Mayusculas
                         mov ah, 09h
                         int 21h
                        
                         mov al, ContMayusculas  
                         mov ah, 0
                         
                         NUM_INICIO_UD2:  
                                
                                ;unidad
                                cmp al, 10
                                jb NUM_FINAL_UD2
                                
                                          
                                sub al, 10
                                inc ah 
                                jmp NUM_INICIO_UD2
                    
                         NUM_FINAL_UD2:
                         
                                ;UNIDAD
                                mov cl, al
                                
                                ;DECENA 
                                mov dl, ah 
                                add dl, 30h
                                mov ah, 02h 
                                int 21h   
                                
                                ;UNIDAD 
                                mov dl, cl 
                                add dl, 30h
                                mov ah, 02h 
                                int 21h
                
              
                         ;MINUS
                         lea dx, MsgCantidad_Minusculas
                         mov ah, 09h
                         int 21h    
                         
                         mov al, ContMinusculas  
                         mov ah, 0
              
                         NUM_INICIO_UD3:  
                                
                                ;unidad
                                cmp al, 10
                                jb NUM_FINAL_UD3
                                
                                          
                                sub al, 10
                                inc ah 
                                jmp NUM_INICIO_UD3
                    
                         NUM_FINAL_UD3:
                         
                                ;UNIDAD
                                mov cl, al
                                
                                ;DECENA 
                                mov dl, ah 
                                add dl, 30h
                                mov ah, 02h 
                                int 21h   
                                
                                ;UNIDAD 
                                mov dl, cl 
                                add dl, 30h
                                mov ah, 02h 
                                int 21h
                    
                        ;ESPECIALES
                        lea dx, MsgCantidad_Especiales
                        mov ah, 09h
                        int 21h
                        
                        mov al, ContEspeciales  
                        mov ah, 0
              
                        NUM_INICIO_UD4:  
                                
                                ;unidad
                                cmp al, 10
                                jb NUM_FINAL_UD4
                                
                                          
                                sub al, 10
                                inc ah 
                                jmp NUM_INICIO_UD4
                    
                         NUM_FINAL_UD4:
                         
                                ;UNIDAD
                                mov cl, al
                                
                                ;DECENA 
                                mov dl, ah 
                                add dl, 30h
                                mov ah, 02h 
                                int 21h   
                                
                                ;UNIDAD 
                                mov dl, cl 
                                add dl, 30h
                                mov ah, 02h 
                                int 21h 
              
              jmp PREGUNTAR
             
;-------------------------------------------------------------------------------

OPCION2:
             lea dx, MsgEstasOpcion2
             mov ah, 09h
             int 21h
             jmp INICIO_MENU

OPCION3:
             lea dx, MsgEstasOpcion3
             mov ah, 09h
             int 21h
             jmp INICIO_MENU

OPCION4:
             lea dx, MsgEstasOpcion4
             mov ah, 09h
             int 21h
             jmp INICIO_MENU
             
ERROR_MENU:
             lea dx, MsgErrorOpcionMenu
             mov ah, 09h
             int 21h
             jmp INICIO_MENU 

PREGUNTAR:   
             lea dx, MsgLinea1
             mov ah, 09h
             int 21h    
             
             ;CONDICIONES 
             lea dx, MsgPreguntaSiNo
             mov ah, 09h
             int 21h
             
             mov ah, 01h
             int 21h
             
             cmp al, 'S'
             je INICIO_MENU  
             
             cmp al, 's'
             je INICIO_MENU 
             
             cmp al, 'N'
             je SALIR 

             cmp al, 'n'
             je SALIR
             
             jmp SALIR

SALIR:
             lea dx, MsgDespedida
             mov ah, 09h
             int 21h

             mov ah, 4ch
             int 21h

main endp
end main