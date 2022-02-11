;*************************************************
;Programmer: Camden Hankey
;Professor: Dr. Packard
;Purpose: develop a maze which a user can navigate
;Last Modified: April 30, 2021
;*************************************************

include "emu8086.inc"

org 100h

;/////////////////////////////////////////////////////////////////////////
;****************************INTRODUCTION*********************************
;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\ 

CURSOROFF               ;turn cursor off 

call PrintmsgOne        ;call print message procedures 
call PrintmsgTwo        ;to print introduction
call PrintmsgThree
call PrintmsgFour 
call PrintmsgFive
    

;/////////////////////////////////////////////////////////////////////////
;**************************PRINTING THE MAZE******************************
;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\


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
        mov AL, maze + BX  ;mov the memory location of the first element in the maze plus the offset of BX into AL
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
    
    call PrintExit
;----------------------------------------------------------------------------                                                      
                                                      





;////////////////////////////////////////////////////////////////////////////
;****************************CHARACTER MOVEMENT******************************
;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

;original starting position
call OGCharPosition

mov userX, START_X      ;move starting X-coord into current user position variable X
mov userY, START_Y      ;move starting Y-coord into current user position variable Y
mov oldX, START_X       ;move starting X-coord into old user position variable X
mov oldY, START_Y       ;move starting Y-coord into old user position variable Y
mov CX, 1 

CharMove:                 ;initiate the loop
    call GetKeyPress      ;call procedure to obtain the keypress
    mov KEY_PRESS, AL     ;move the result of the keypress into variable called KEY_PRESS

    cmp AL, 119       ;compare AL (keypress value) with 119(W), 97(A), 115(S), and 100(D)
    je wChar          ;if AL is equal to any of these values it will jump to its
                      ;respective jump point
    cmp AL, 97        
    je aChar        
        
    cmp AL, 115       
    je sChar          
       
    cmp AL, 100       
    je dChar          
       
        wChar:               ;jump labels for each letter
        mov BL, userY        ;move both the current position (X and Y)
        mov oldY, BL         ;into oldX&Y variables to hold their previous position
        mov BL, userX
        mov oldX, BL
        call MoveUserUp      ;call respective procedure to move up, down, left, right
        jmp Done             ;jump to Done after calling and returning procedure
            
        aChar: 
        mov BL, userX
        mov oldX, BL
        mov BL, userY
        mov oldY, BL
        call MoveUserLeft
        jmp Done
            
        sChar:
        mov BL, userY
        mov oldY, BL
        mov BL, userX
        mov oldX, BL
        call MoveUserDown
        jmp Done
           
        dChar:
        mov BL, userX
        mov oldX, BL
        mov BL, userY
        mov oldY, BL
        call MoveUserRight 
        
     Done:               ;Done label
     mov AH, userX       ;mov current x coord into AH   
     cmp AH, VCoordX     ;compare AH with winning x coord
     jne NoWinner        ;jump if not equal to NoWinner label
        
     mov AH, userY       ;if equal move current y coord into AH
     cmp AH, VCoordY     ;compare AH with winning y coord
     je Winner           ;if both x & y coord are equal jump out of loop
        
     NoWinner:
       
     inc CX              ;increment CX so it loops again
     mov AL, KEY_PRESS   ;move key press back into AL
     Loop CharMove                                                 
;----------------------------------------------------------------------------



;////////////////////////////////////////////////////////////////////////////
;*************************WINNING MESSAGE************************************
;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
                                                      
Winner:

call CLEAR_SCREEN 

call PrintWinningMsgOne
call PrintWinningMsgTwo
call PrintWinningMsgThree
     
                                                   
ret

;////////////////////////////////////////////////////////////////////////////
;****************************MEMORY/VARIABLES********************************
;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

;MAZE-----------------------------------------------
;defined array that stores the maze setup
maze DB 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
     DB 1,0,0,0,1,1,0,0,0,0,0,0,1,1,1,1,0,0,0,1
     DB 1,0,1,0,0,0,0,1,1,1,1,0,0,0,0,0,0,1,0,1
     DB 1,0,1,1,1,1,1,1,1,0,1,0,1,1,1,1,1,1,0,1
     DB 1,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,1,0,0,1
     DB 1,1,1,1,0,1,1,1,1,1,1,1,1,1,1,0,1,0,1,1
     DB 1,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,1,0,1,1
     DB 1,1,1,1,0,1,0,1,1,1,0,1,0,1,1,1,1,0,0,1
     DB 1,0,0,0,0,1,0,0,0,1,0,1,0,1,1,1,1,1,0,1
     DB 1,0,1,1,1,1,0,1,0,1,0,1,0,0,0,0,0,0,0,1
     DB 1,0,1,1,1,1,0,1,0,1,0,1,0,1,1,1,1,1,1,1
     DB 1,0,0,0,0,0,0,1,0,1,0,1,0,0,0,0,1,1,1,1
     DB 1,1,1,1,1,1,1,1,0,1,0,1,1,1,1,0,0,0,0,1
     DB 1,1,0,1,1,1,1,1,1,1,0,0,0,0,1,0,1,1,1,1
     DB 1,1,0,0,0,0,0,0,0,0,0,1,1,1,1,0,1,1,0,1
     DB 1,0,0,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,1
     DB 1,1,0,1,1,1,0,0,0,0,0,1,0,1,1,1,1,1,0,1
     DB 1,1,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,0,1
     DB 1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,1,0,1
     DB 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,1,1,1   
     


;MESSAGES-------------------------------------------
msgOne DB "Welcome to the maze game!",0                 ;Introductory messages
msgTwo DB "Find your way through the maze by",0         ;split up into five different lines
msgThree DB "navigating to the white and red exit.",0   
msgFour DB "Use W, A, S, D to move.",0                  
msgFive DB "GOOD LUCK!", 0                             

winningMsgOne DB  0,0,1,1,1,1,1,0,0,0,0,0,1,1,1,1,0     ;setup for the turtle congratulatory message
              DB  0,2,0,0,0,0,0,0,4,0,0,3,0,0,5,0,3
              DB  3,0,0,0,0,0,0,0,0,3,2,0,1,1,1,4,3 
              DB  3,1,1,1,1,1,1,1,1,1,2,0,0,0,0,0,0    
              DB  3,1,3,1,3,0,3,1,3,1,3,0,0,0,0,0,0
                          
winningMsgTwo DB "Congratulations! You completed the maze.", 0  ;winning messages  
winningMsgThree DB "Here is a celebratory turtle!", 0  



;VARIABLES------------------------------------------
msgOneX = 23     ;x coord for message one start
msgOneY = 5      ;y coord for message one
msgTwoX = 23     ;x coord for mesasge two start
msgTwoY = 6      ;y coord for message two
msgThreeX = 23   ;x coord for message three start
msgThreeY = 7    ;y coord for message three
msgFourX = 23    ;x coord for message four start
msgFourY = 8     ;y coord for message four
msgFiveX = 23    ;x coord for message five start
msgFiveY = 9     ;y coord for message five
msgWinX = 2      ;x coord for winning message start 
msgWinY = 7      ;y coord for winning message 
msgFinalX = 2    ;x coord for winning message final start
msgFinalY = 8    ;y coord for winning message final
KEY_PRESS DB ?   ;variable to hold the key press value returned from GetKeyPress
CURSOR_X DB 0    ;variable to hold x coord for printing the maze
CURSOR_Y DB 0    ;variable to hold y coord for printing the maze
userX DB ?       ;variable to hold x coord of user
userY DB ?       ;variable to hold y coord of user
oldX DB ?        ;variable to hold previous x coord of char in maze
oldY DB ?        ;variable to hold previous y coord of char in maze
START_X = 18     ;starting x coord for character
START_Y = 18     ;starting y coord for character
VCoordX = 16     ;variable to hold winning x coord
VCoordY = 19     ;variable to hold winning y coord
holdCount DW ?   ;hold count for rows
holdWin DW ?     ;hold count for rows in winning turtle message
ColTrack DW ?    ;hold count for columns 
PosTrack DW ?    ;hold count for position in row
ROW_WIN = 5      ;number of rows in winning turtle
COL_WIN = 17     ;number of columns in winning turtle
NCOL = 20        ;number of columns
NROW = 20        ;number of rows
PATH = 176       ;ascii code for a path symbol
WALL = 186       ;ascii code for a wall symbol
EXIT = 238       ;ascii code for exit symbol
BACKSLASH = 92
FSLASH = 47
COLON = 58
UNDERSCORE = 95
SPACE = 32
O = 111


RED_WHITE = 0000000011110100b   ;color code for red foreground and white background (exit sign)
CYAN = 3                        ;color code for cyan
LIGHT_GREEN= 10                 ;color code for light green
WHITE = 15                      ;color code for white
PlayerChar = 1                  ;ascii code for a user character
varOffset DW ?                  ;offset variable to hold offset from beginning to char position


DEFINE_PRINT_NUM
DEFINE_PRINT_NUM_UNS
DEFINE_CLEAR_SCREEN
                    


;///////////////////////////////////////////////////////////////////////////                    
;*******************************PROCEDURES**********************************
;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\



;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
;PROCEDURES FOR PRINTING THE MAZE-------------------------
                    
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
PrintCharPath ENDP;---------------------------------------
;_________________________________________________________





;---------------------------------------------------------
PrintCharWall PROC;_______________________________________
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
PrintCharWall ENDP;---------------------------------------
;_________________________________________________________


;---------------------------------------------------------
PrintExit PROC;___________________________________________
;
;Uses int 10h/09h to print a color characted stored in EXIT variable
;Receives: nothing
;Returns: red foreground and white background for exit symbol
;AH = 09h, AL = EXIT, BX = RED_WHITE, CX = 1
;Requires: nothing
    GOTOXY VCoordX, VCoordY
    mov AH, 09h
    mov AL, EXIT
    mov BX, RED_WHITE
    mov CX, 1
    int 10h
    
    ret
PrintExit ENDP;-------------------------------------------
;_________________________________________________________
;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ 





;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;PROCEDURES FOR CHARACTER MOVEMENT------------------------

;---------------------------------------------------------
OGCharPosition PROC;______________________________________ 
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
OGCharPosition ENDP;--------------------------------------
;_________________________________________________________
 
 
;---------------------------------------------------------
GetKeyPress PROC;_________________________________________
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
MoveUserUp PROC;_________________________________________ 
;
;Uses int 10h/09h to move the user's char position up
;Receives: uses both userX and userY values
;Returns: prints player char one square up from previous
;position and calls rewrite procedure
;Requires: AL must be equal to 119 (user must press W) 
    mov DL, userY                                        
    dec DL
    mov userY, DL
    call CheckForWall
    cmp CH, 1
    je NoGoodU
    
    call Rewrite
    GOTOXY userX, userY
    mov AH, 09h
    mov AL, PlayerChar
    mov BX, WHITE
    mov CX, 1
    int 10h 
    jmp GoodU
     
    NoGoodU:
    mov DL, userY
    inc DL
    mov userY, DL
    
    GoodU:
     
    ret         
MoveUserUp ENDP;-----------------------------------------
;________________________________________________________


;--------------------------------------------------------
MoveUserDown PROC;_______________________________________
;
;Uses int 10h/09h to move the user's char position down
;Receives: uses both userX and userY values
;Returns: prints player char one square down from previous
;position and calls rewrite procedure
;Requires: AL must be equal to 115 (user must press S)
    mov DL, userY
    inc DL
    mov userY, DL
    call CheckForWall
    cmp CH, 1
    je NoGoodD 
    
    call Rewrite
    GOTOXY userX, userY
    mov AH, 09h
    mov AL, PlayerChar
    mov BX, WHITE
    mov CX, 1
    int 10h
    jmp GoodD
    
    NoGoodD:
    mov DL, userY
    dec DL
    mov userY, DL
    
    GoodD: 
    
    ret
MoveUserDown ENDP;---------------------------------------
;________________________________________________________


;--------------------------------------------------------    
MoveUserLeft PROC;_______________________________________
;
;Uses int 10h/09h to move the user's char position left
;Receives: uses both userX and userY values
;Returns: prints player char one square to the left of
;previous position and calls rewrite procedures
;Requires: AL must be equal to 97 (user must press A)
    mov DL, userX
    dec DL
    mov userX, DL
    call CheckForWall
    cmp CH, 1
    je NoGoodL
     
    call Rewrite
    GOTOXY userX, userY
    mov AH, 09h
    mov AL, PlayerChar
    mov BX, WHITE
    mov CX, 1
    int 10h
    jmp GoodL
    
    NoGoodL:
    mov DL, userX
    inc DL
    mov userX, DL
    
    GoodL: 
    
    ret
MoveUserLeft ENDP;---------------------------------------
;________________________________________________________
                 
                                  
;--------------------------------------------------------                 
MoveUserRight PROC;______________________________________
;
;Uses int 10h/09h to move the user's char position right
;Receives: uses both userX and userY values
;Returns: prints player char one square to the right of
;previous position and calls rewrite procedure
;Requires: AL must be equal to 100 (user must press D)
    mov DL, userX
    inc DL
    mov userX, DL
    call CheckForWall
    cmp CH, 1
    je NoGoodR
    
    call Rewrite
    GOTOXY userX, userY
    mov AH, 09h
    mov AL, PlayerChar
    mov BX, WHITE
    mov CX, 1
    int 10h
    jmp GoodR 
    
    NoGoodR:
    mov DL, userX
    dec DL
    mov userX, DL
    
    GoodR:
    
    ret
MoveUserRight ENDP;---------------------------------------
;_________________________________________________________
                
                
;---------------------------------------------------------                
Rewrite PROC;_____________________________________________
;
;Uses int 10h/09h to print the path in the position the 
;play was previously in
;Recevies: uses both oldX and oldY values
;Returns: prints path char in place of the old player char
;Requires: a keypress of either W,A,S,D from the user
    GOTOXY oldX, oldY
    mov AH, 09h
    mov AL, PATH
    mov BX, CYAN
    mov CX, 1
    int 10h
    
    ret
Rewrite ENDP;---------------------------------------------
;_________________________________________________________


;---------------------------------------------------------
CheckForWall PROC;________________________________________
;
;Checks to see if user is going into a wall by comparing 
;the users new position with that position within the two 
;dimensional array
;Receives: NCOL, userY, userX, maze_setup
;Returns: 1 in CH if it is a wall, 0 in CH if not
;Requires: a keypress from the user
    mov BX, 0
    mov DX, NCOL
    mov BL, userY
    cmp BL, 0
    jz NoGood 
    
    mov AX, BX
    mul DX 
    
    add AL, userX
    mov varOffset, AX
    lea BX, [maze] 
    add BX, varOffset
    mov AH, [BX] 
    cmp AH, 1
    jne Good
    
    NoGood:
    putc 7
    mov CH, 1
    jmp ThatsAWall
    
    Good:
    mov CH, 0 
    
    ThatsAWall:
    
    ret
CheckForWall ENDP;----------------------------------------
;_________________________________________________________
    
;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!



;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;PROCEDURES FOR PRINTING MESSAGES_________________________
                                                            
                                                            
;---------------------------------------------------------
PrintmsgOne PROC;_________________________________________
;
;Iterates through msgOne and prints each character
;Receives: msgOneX, msgOneY, msgOne
;Returns: msgOne printeed onto the screen 
;Requires: nothing
    GOTOXY msgOneX, msgOneY
    mov BX, 0
    
    MessageOne:
        mov AL, msgOne + BX
        putc AL
        
        inc BX
        
        cmp msgOne + BX, 0
        jz DoneWithMessageOne
        
        jmp MessageOne
    
    DoneWithMessageOne:
    
    ret
PrintmsgOne ENDP;-----------------------------------------
;_________________________________________________________


;---------------------------------------------------------
PrintmsgTwo PROC;_________________________________________
;
;Iterates through msgTwo and prints each character
;Receives: msgTwoX, msgTwoY, msgTwo
;Returns: msgTwo printeed onto the screen 
;Requires: nothing
    GOTOXY msgTwoX, msgTwoY                               
    mov BX, 0
    
    MessageTwo:
        mov AL, msgTwo + BX
        putc AL
        
        inc BX
        
        cmp msgTwo + BX, 0
        jz DoneWithMessageTwo
        
        jmp MessageTwo
    
    DoneWithMessageTwo:
    
    ret   
PrintmsgTwo ENDP;-----------------------------------------
;_________________________________________________________


;---------------------------------------------------------
PrintmsgThree PROC;_______________________________________
;
;Iterates through msgThree and prints each character
;Receives: msgThreeX, msgThreeY, msgThree
;Returns: msgThree printeed onto the screen 
;Requires: nothing
    GOTOXY msgThreeX, msgThreeY
    mov BX, 0
    
    MessageThree:
        mov AL, msgThree + BX
        putc AL
        
        inc BX
        
        cmp msgThree + BX, 0
        jz DoneWithMessageThree
        
        jmp MessageThree
    
    DoneWithMessageThree:
    
    ret 
PrintmsgThree ENDP;---------------------------------------
;_________________________________________________________


;---------------------------------------------------------                    
PrintmsgFour PROC;________________________________________
;
;Iterates through msgFour and prints each character
;Receives: msgFourX msgFourY, msgFour
;Returns: msgFour printeed onto the screen 
;Requires: nothing
    GOTOXY msgFourX, msgFourY
    mov BX, 0
    
    MessageFour:
        mov AL, msgFour + BX
        putc AL
        
        inc BX
        
        cmp msgFour + BX, 0
        jz DoneWithMessageFour
        
        jmp MessageFour
    
    DoneWithMessageFour:
    
    ret 
PrintmsgFour ENDP;----------------------------------------
;_________________________________________________________


;---------------------------------------------------------
PrintmsgFive PROC;________________________________________ 
;
;Iterates through msgFive and prints each character
;Receives: msgFiveX, msgFiveY, msgFive
;Returns: msgFiive printeed onto the screen 
;Requires: nothing
    GOTOXY msgFiveX, msgFiveY
    mov BX, 0
    
    MessageFive:
        mov AL, msgFive + BX
        putc AL
        
        inc BX
        
        cmp msgFive + BX, 0
        jz DoneWithMessageFive
        
        jmp MessageFive
    
    DoneWithMessageFive:
    
    ret 
PrintmsgFive ENDP;-----------------------------------------
;__________________________________________________________



;----------------------------------------------------------
PrintWinningMsgOne PROC;___________________________________
; 
;Iterates through 2d array holding turtle message and prints
;each character. Very similar to printing the actual maze except
;held within a procedure
;Receives: ROW_WIN, COL_WIN, WinningMsgOne
;Returns: WinningMsgOne printed onto the screen
;Requires: user has made it to the end of the maze 
         mov CX, ROW_WIN    ;move row count into CX
         mov BX, 0          ;move 0 into BX so we start at 0 within the array



        ;Start to print with the first row and iterate down
        PrintWinR:
            mov holdWin, CX       ;hold the value in CX(rows) by using a variable
            mov CX, COL_WIN       ;move column number into CX
                                                    
                                                    
     
            ;Start to print with the first column and iterate over
            PrintWinC:
                mov colTrack, CX
                mov posTrack, BX  
                mov AL, WinningMsgOne + BX  ;mov the memory location of the first element in the message plus the offset of BX into AL
                cmp AL, 0                   ;if AL equals 0, jump to PrintSpace label
                je PrintSpace
        
                cmp AL, 1
                je PrintUnderscore          ;if AL equals 1, jump to PrintUnderscore
        
                cmp AL, 3
                je PrintColon               ;if AL equals 3, jump to PrintColon
        
                cmp AL, 2
                je PrintFSlash              ;if AL equals 2, jump to PrintFSlash
        
                cmp AL, 5
                je PrintO                   ;if AL equals 5, jump to PrintO (only one case)
        
                putc BACKSLASH              ;if AL does not equal any of those, print backslash (only two cses)
        
                PrintSpace:
                putc SPACE                  ;prints respective character in AL
                jmp NextCharWin             ;after printing, jump to the end of loop                  
        
                PrintUnderscore:
                putc UNDERSCORE 
                jmp NextCharWin              
        
                PrintColon: 
                putc COLON 
                jmp NextCharWin
        
                PrintFslash:
                putc FSLASH
                jmp NextCharWin
        
                PrintO:
                putc O
        
                NextCharWin:  
                mov CX, colTrack            ;Puts column tracker and position tracher back in CX and BX
                mov BX, posTrack
                inc bx                      ;increment position within row
                
                
            loop PrintWinC       ;loop back to PrintWinC (print next character in the row)
    
        
        printn                   ;move to the next line after printing a row
        mov CX, holdWin          ;move holdWin from the start of the loop back into CX to decrement
        loop PrintWinR           ;loop back to PrintWinR to move to the next row

    ret
PrintWinningMsgOne ENDP;---------------------------------------
;______________________________________________________________


;--------------------------------------------------------------
PrintWinningMsgTwo PROC;_______________________________________
; 
;iterates through WinningMsgTwo and prints each character
;Receives: msgWinX, msgWinY, WinningMsgTwo
;Returns: prints each character in WinningMsgTwo
;Requires: user to beat the maze
    GOTOXY msgWinX, msgWinY
    mov BX, 0
    
    WinMessageTwo:
        mov AL, WinningMsgTwo + BX
        putc AL
        
        inc BX
        
        cmp WinningMsgTwo + BX, 0
        jz DoneWithWinMessage
        
        jmp WinMessageTwo
    
    DoneWithWinMessage:
    
    ret 
PrintWinningMsgTwo ENDP;---------------------------------------
;______________________________________________________________ 


;--------------------------------------------------------------
PrintWinningMsgThree PROC;_____________________________________
;
;Iterates through WinningMsgThree and prints each charcter
;Receives: msgFinalX, msgFinalY, WinningMsgThree
;Returns: prints each character in WinningMsgThree
;Requires: user to beat the maze
    GOTOXY msgFinalX, msgFinalY
    mov BX, 0
    
    WinMessageThree:
        mov AL, WinningMsgThree + BX
        putc AL
        
        inc BX
        
        cmp WinningMsgThree + BX, 0
        jz DoneWithWinMessageFinal
        
        jmp WinMessageThree
    
    DoneWithWinMessageFinal:
    
    ret 
PrintWinningMsgThree ENDP;-------------------------------------
;______________________________________________________________
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%                                                                                                   `    