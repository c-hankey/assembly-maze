
;Programmer: Camden Hankey
;Professor: Dr. Packard
;Purpose: develop a maze which a user can navigate
;Last Modified: April 19, 2021

include "emu8086.inc"

org 100h
  
;As it is right now the code will run and print 
;the test maze I have
;
;The four lines of code that are commented out 
;with arrows pointing to them are the procedures I 
;attempted to use to print through interrupts
;________________________________________________________
;PRINTING THE MAZE---------------------------------------

mov CX, NROW  ;move row count into CX
mov BX, 0     ;move 0 into BX so we start at 0 within the array



;Start to print with the first row and iterate down
PrintRow:
    mov holdCount, CX  ;hold the value in CX(rows) by using a variable
    mov CX, NCOL       ;move column number into CX
                                                    
                                                    
     
    ;Start to print with the first column and iterate over
    PrintCol:  
        mov ColTrack, CX         ;used this for the procedures since they use CX to hold # of rows
        mov PosTrack, BX         ;also used for procedure to keep track of position in row
        mov AL, maze_setup + BX  ;mov the memory location of the first element in the maze plus the offset of BX into AL
        cmp AL, 1                ;if AL is equal to 1, jump to PrintWall label
        je PrintWall
        
        ;call PrintCharPath  ;<---commented out procedure
        ;putc 32 
        
        putc PATH               ;if AL is not equal to 1, print PATH char
        jmp NextChar            ;jump to iterate to the next column
        
        PrintWall:
        putc WALL               ;if AL is equal to 1, print WALL char
                      ;
        ;call PrintCharWall  ;<---commented out procedure
        ;putc 32
        
        NextChar:
        
        mov BX, PosTrack    ;move PosTrack value from start of loop into BX to increment
        mov CX, ColTrack    ;move ColTrack value from start of loop into CX so it can correctly decrement
        inc BX              ;increment BX to get the next column over
        loop PrintCol       ;loop back to PrintCol
        
    printn                  ;move to the next line after printing a row
    
    mov CX, holdCount       ;move holdCount from the start of the loop back into CX to decrement
    loop PrintRow           ;loop back to PrintRow

ret


;defined memory that stores the maze setup
;test case for now CMH
maze_setup DB 1,1,1,1,1,1,1,1,1,1
           DB 1,0,0,0,0,0,0,0,0,1
           DB 1,1,0,1,1,1,0,1,0,1
           DB 1,1,0,0,1,1,1,1,0,1
           DB 1,1,0,1,1,1,0,0,0,1 
           DB 1,1,1,1,1,1,1,1,1,1 


holdCount DW ?  ;hold count for rows
ColTrack DW ?   ;hold count for columns 
PosTrack DW ?   ;hold count for position in row
NCOL = 10       ;number of columns
NROW = 6        ;number of rows
PATH = 176      ;ascii code for a path symbol
WALL = 186      ;ascii code for a wall symbol  
CYAN = 3        ;color code for cyan
LIGHT_GREEN= 10 ;color code for light green

DEFINE_PRINT_NUM
DEFINE_PRINT_NUM_UNS

;---------------------------------------------------------
PrintCharPath PROC;_______________________________________
;
;Uses int 10h/09h to print a color character stored in PATH variable
;Receives: nothing
;Returns: cyan colored path char
;AH = 09h, AL = PATH, BX = CYAN, CX = 1
;Requires: nothing
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
;Requires: nothing
    mov AH, 09h
    mov AL, WALL
    mov BX, LIGHT_GREEN
    mov CX, 1
    int 10h 

    
    ret
PrintCharWall ENDP;--------------------------------------
;________________________________________________________
    


