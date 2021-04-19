
;Programmer: Camden Hankey
;Professor: Dr. Packard
;Purpose: develop a maze which a user can navigate
;Last Modified: April 19, 2021

include "emu8086.inc"

org 100h  

mov CX, NROW
mov BX, 0

PrintRow:
    mov holdCount, CX
    mov CX, NCOL
    
    PrintCol:
        mov AL, maze_setup + BX
        cmp AL, 1
        je PrintWall
        
        putc PATH
        jmp NextChar
        
        PrintWall:
        putc WALL
        
        NextChar:
          
        inc BX
        loop PrintCol
        
    printn
    
    mov CX, holdCount
    loop PrintRow

ret

;defined memory that stores the maze setup
;test case for nowCMH
maze_setup DB 1,1,1,1,1,1,1,1,1,1
           DB 1,0,0,0,0,0,0,0,0,1
           DB 1,1,0,1,1,1,0,1,0,1
           DB 1,1,0,0,1,1,1,1,0,1
           DB 1,1,0,1,1,1,0,0,0,1 
           DB 1,1,1,1,1,1,1,1,1,1 


holdCount DW ?
NCOL = 10 ;number of columns
NROW = 6  ; number of rows
PATH = 176 ;ascii code for a path symbol
WALL = 186 ;ascii code for a wall symbol

DEFINE_PRINT_NUM
DEFINE_PRINT_NUM_UNS