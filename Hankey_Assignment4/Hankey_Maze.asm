;*************************************************
;Programmer: Camden Hankey
;Professor: Dr. Packard
;Purpose: develop a maze which a user can navigate
;Last Modified: April 20, 2021
;*************************************************

include "emu8086.inc"

org 100h

;*************************************************************************
;PRINTING THE MAZE--------------------------------------------------------

CURSOROFF
mov CX, NROW  ;move row count into CX
mov BX, 0     ;move 0 into BX so we start at 0 within the array



;Start to print with the first row and iterate down
PrintRow:
    mov holdCount, CX  ;hold the value in CX(rows) by using a variable
    mov CX, NCOL       ;move column number into CX
    mov CURSOR_X, 0
                                                    
                                                    
     
    ;Start to print with the first column and iterate over
    PrintCol:  
        mov ColTrack, CX         ;used this for the procedures since they use CX to hold # of rows
        mov PosTrack, BX         ;also used for procedure to keep track of position in row
        mov AL, maze_setup + BX  ;mov the memory location of the first element in the maze plus the offset of BX into AL
        cmp AL, 1                ;if AL is equal to 1, jump to PrintWall label
        je PrintWall
        
        call PrintCharPath  ;call to PrintCharPath procedure to print path char
        jmp NextChar        ;jump to iterate to the next column
        
        PrintWall:
        call PrintCharWall  ;call PrintCharWall procedure to print wall char
        
        
        NextChar:
        
        mov BX, PosTrack    ;move PosTrack value from start of loop into BX to increment
        mov CX, ColTrack    ;move ColTrack value from start of loop into CX so it can correctly decrement
        inc BX              ;increment BX to get the next column over  
        inc CURSOR_X
        loop PrintCol       ;loop back to PrintCol
        
    printn                  ;move to the next line after printing a row
    
    inc CURSOR_Y
    mov CX, holdCount       ;move holdCount from the start of the loop back into CX to decrement
    loop PrintRow           ;loop back to PrintRow
;----------------------------------------------------------------------------                                                      
                                                      


;****************************************************************************
;CHARACTER MOVEMENT----------------------------------------------------------

;original starting position
call OGCharPosition

mov userX, START_X
mov userY, START_Y
mov CX, 1 

LoopStart:
    call GetKeyPress
    mov KEY_PRESS, AL

    cmp AL, 119
    je wChar
        
    cmp AL, 97
    je aChar
        
    cmp AL, 115
    je sChar
       
    cmp AL, 100
    je dChar
       
        wChar: 
        mov BL, userY
        mov oldY, BL
        call MoveUserUp
        jmp Done
            
        aChar: 
        mov BL, userX
        mov oldX, BL
        call MoveUserLeft
        jmp Done
            
        sChar:
        mov BL, userY
        mov oldY, BL
        call MoveUserDown
        jmp Done
           
        dChar:
        mov BL, userX
        mov oldX, BL
        call MoveUserRight 
           
        mov AH, userX                 
        cmp AH, VCoordX
        jne NoWinner
        
        mov AH, userY
        cmp AH, VCoordY
        je Winner
        
        NoWinner:
       
     Done:
     inc CX
     mov AL, KEY_PRESS
     Loop LoopStart                                                 
                                                      
     Winner:                                               
ret


;****************************************************************************
;MEMORY/VARIABLES------------------------------------------------------------
;defined memory that stores the maze setup
;test case for now CMH
maze_setup DB 1,1,1,1,1,1,1,1,1,1
           DB 1,0,0,0,0,0,0,0,0,1
           DB 1,1,0,1,1,1,0,1,0,1
           DB 1,1,0,0,1,1,1,1,0,1
           DB 1,1,0,1,1,1,0,0,0,1 
           DB 1,1,1,1,1,1,1,1,1,1 


KEY_PRESS DB ?  ;variable to hold the key press value returned from GetKeyPress
CURSOR_X DB 0   ;variable to hold x coord for printing the maze
CURSOR_Y DB 0   ;variable to hold y coord for printing the maze
userX DB ?     ;variable to hold x coord of user
userY DB ?      ;variable to hold y coord of user
oldX DB ?     ;variable to hold previous x coord of char in maze
oldY DB ?    ;variable to hold previous y coord of char in maze
START_X = 6     ;starting x coord for character
START_Y = 4     ;starting y coord for character
VCoordX = 2     ;variable to hold winning x coord
VCoordY = 8     ;variable to hold winning y coord
holdCount DW ?  ;hold count for rows
ColTrack DW ?   ;hold count for columns 
PosTrack DW ?   ;hold count for position in row
NCOL = 10       ;number of columns
NROW = 6        ;number of rows
PATH = 176      ;ascii code for a path symbol
WALL = 186      ;ascii code for a wall symbol  
CYAN = 3        ;color code for cyan
LIGHT_GREEN= 10 ;color code for light green
WHITE = 15      ;color code for white
PlayerChar = 1  ;ascii code for a user character


DEFINE_PRINT_NUM
DEFINE_PRINT_NUM_UNS
                    


                    
;***************************************************************************
;PROCEDURES-----------------------------------------------------------------
                    
;---------------------------------------------------------
PrintCharPath PROC;_______________________________________
;
;Uses int 10h/09h to print a color character stored in PATH variable
;Receives: nothing
;Returns: cyan colored path char
;AH = 09h, AL = PATH, BX = CYAN, CX = 1
;Requires: AL to be equal to 0
 
    GOTOXY CURSOR_X,CURSOR_Y
    mov AH, 09h
    mov AL, PATH
    mov BX, CYAN
    mov CX, 1
    int 10h
    
    ret
PrintCharPath ENDP;--------------------------------------
;________________________________________________________





;--------------------------------------------------------
PrintCharWall PROC;______________________________________
;
;Uses int 10h/09h to print a color character stored in WALL variable
;Receives: nothing
;Returns: light green colored wall char
;AH = 09h, AL = WALL, BX = LIGHT_GREEN, CX = 1
;Requires: AL to be equal to 1
    
    GOTOXY CURSOR_X,CURSOR_Y
    mov AH, 09h
    mov AL, WALL
    mov BX, LIGHT_GREEN
    mov CX, 1
    int 10h 

    
    ret
PrintCharWall ENDP;--------------------------------------
;________________________________________________________
 
 
 
 

;--------------------------------------------------------
OGCharPosition PROC;_____________________________________ 
;
;Uses int 10h/09h to print the original character position in white
;Receives: START_X and START_Y and the values with them
;Returns: white colored player char
;Requires: nothing
    GOTOXY START_X, START_Y
    mov AH, 09h
    mov AL, PlayerChar
    mov BX, WHITE
    mov CX, 1
    int 10h
    
    ret
OGCharPosition ENDP;-------------------------------------
;________________________________________________________
 
 
 
 
    

;--------------------------------------------------------
GetKeyPress PROC;________________________________________
;
;Uses int 21h/07h to obtain a keypress from the user
;Receives: keypress from the user
;Returns: stores ascii char of key pressed into AL
;Requires: nothing
    mov AH, 07h                                           
    int 21h
      
    ret
GetKeyPress ENDP;----------------------------------------
;________________________________________________________

    
    
    


;--------------------------------------------------------
MoveUserUp PROC
    mov DL, userY
    dec DL
    mov userY, DL
    GOTOXY userX, userY
    mov AH, 09h
    mov AL, PlayerChar
    mov BX, WHITE
    mov CX, 1
    int 10h 
    call Rewrite
    
    ret         
MoveUserUp ENDP




MoveUserDown PROC
    mov DL, userY
    inc DL
    mov userY, DL
    GOTOXY userX, userY
    mov AH, 09h
    mov AL, PlayerChar
    mov BX, WHITE
    mov CX, 1
    int 10h 
    call Rewrite
    
    ret
MoveUserDown ENDP 



    
MoveUserLeft PROC
    mov DL, userX
    dec DL
    mov userX, DL
    GOTOXY userX, userY
    mov AH, 09h
    mov AL, PlayerChar
    mov BX, WHITE
    mov CX, 1
    int 10h 
    call Rewrite
    
    ret
MoveUserLeft ENDP
                 
                 
                 
                 
MoveUserRight PROC
    mov DL, userX
    inc DL
    mov userX, DL
    GOTOXY userX, userY
    mov AH, 09h
    mov AL, PlayerChar
    mov BX, WHITE
    mov CX, 1
    int 10h 
    call Rewrite
    
    ret
MoveUserRight ENDP 
                
                
                
Rewrite PROC
    GOTOXY oldX, oldY
    mov AH, 09h
    mov AL, PATH
    mov BX, CYAN
    mov CX, 1
    int 10h
    
    ret
Rewrite ENDP
        