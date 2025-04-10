.DATA
    msg_welcome db "Welcome to the Number Guessing Game!", 0Dh, 0Ah, "$"
    msg_prompt db "Guess a number between 1 and 10: $"
    msg_too_low db "Too low! Try again.", 0Dh, 0Ah, "$"
    msg_too_high db "Too high! Try again.", 0Dh, 0Ah, "$"
    msg_correct db "Congratulations! You guessed it. The secret number was:", 0Dh, 0Ah, "$"
    guess_attempts db "Tries Taken to guess: ",0Dh,0Ah,"$"
    msg_set_number db "Set the next secret number (1 to 10): $"
    msg_replay db 0Dh, 0Ah, "Do you want to play again? (y/n): ",0Dh,0Ah, "$"
    msg_invalid db 0Dh, 0Ah, "Invalid input! Try again.", 0Dh, 0Ah, "$"
    new_line db , 0Dh, 0Ah, "$"
    secret_num db 7           ; Secret number
    guess db 0                ; User's guess 
    guess_counter db 0

.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX
    CALL GAME
    
    ; Exit the program
    EXIT_GAME:
    MOV AH, 4CH
    INT 21H
MAIN ENDP
GAME PROC
    

    ; Display welcome message
    GAME_START:
    ; Reset guess counter
    MOV guess_counter, 0

    ; Display welcome message
    LEA DX, new_line
    MOV AH, 09H
    INT 21H
    
    LEA DX, msg_welcome
    MOV AH, 09H
    INT 21H

GUESS_LOOP:
    ; Prompt user for a guess
    LEA DX, msg_prompt
    MOV AH, 09H
    INT 21H

    ; Read the guess (single-digit number)
    MOV AH, 01H
    INT 21H  
    CMP AL, '0'
    JL GUESS_LOOP       ; Restart if input is less than '0'
    CMP AL, '9'
    JG GUESS_LOOP       ; Restart if input is greater than '9'
   

    SUB AL, '0'        ; Convert ASCII to integer
    MOV guess, AL 
    INC guess_counter

    ; Compare the guess with the secret number
    MOV AL, guess
    CMP AL, secret_num
    JE CORRECT         ; Jump if the guess is correct
    JL TOO_LOW         ; Jump if the guess is less than the secret number

    ; If the guess is too high
    LEA DX, msg_too_high
    MOV AH, 09H
    INT 21H
    JMP GUESS_LOOP     ; Go back to guessing

TOO_LOW:
    ; If the guess is too low
    LEA DX, msg_too_low
    MOV AH, 09H
    INT 21H
    JMP GUESS_LOOP     ; Go back to guessing
    
    INVALID_INPUT:
    ; If input is invalid
    LEA DX, msg_invalid
    MOV AH, 09H
    INT 21H
    JMP GUESS_LOOP 
    
    INVALID_INPUT2:
    ; If input is invalid
    LEA DX, msg_invalid
    MOV AH, 09H
    INT 21H
    JMP replay_game 
    
    INVALID_INPUT3:
    ; If input is invalid
    LEA DX, msg_invalid
    MOV AH, 09H
    INT 21H
    JMP set_number
    
    
CORRECT:
    ; If the guess is correct
    LEA DX, new_line
    MOV AH, 09H
    INT 21H
    
    
    LEA DX, msg_correct
    MOV AH, 09H
    INT 21H
    
    LEA DX, guess_attempts
    MOV AH, 09H
    INT 21H
    
    MOV AL, guess_counter
    ADD AL, '0'        ; Convert to ASCII
    MOV DL, AL
    MOV AH, 02H        ; Display the character
    INT 21H
    replay_game: 
    LEA DX, msg_replay
    MOV AH, 09H
    INT 21H

    ; Get player's choice
    MOV AH, 01H
    INT 21H
    CMP AL, 'y'        ; Check if the player pressed 'y'
    JE SET_NUMBER
    CMP AL, 'Y'        ; Check if the player pressed 'Y'
    JE SET_NUMBER

    ; Exit if the player chooses 'n'
    CMP AL, 'n'
    JE EXIT_GAME
    CMP AL, 'N'
    JE EXIT_GAME

    JMP INVALID_INPUT2  ; Handle invalid input

SET_NUMBER:
    ; Prompt the player to set the next secret number
    
    LEA DX, new_line
    MOV AH, 09H
    INT 21H
    
    LEA DX, msg_set_number
    MOV AH, 09H
    INT 21H

    ; Read the new secret number
    MOV AH, 01H
    INT 21H
    CMP AL, '0'
    JL INVALID_INPUT3
    CMP AL, '9'
    JG INVALID_INPUT3
    SUB AL, '0'        ; Convert to integer
    MOV secret_num, AL
    MOV AH, 06H
    MOV AL, 0
    MOV BH, 07H
    MOV CX, 0000H
    MOV DX, 184FH
    INT 10H

    ; Reset cursor position
    MOV AH, 02H
    MOV BH, 00H
    MOV DH, 00H
    MOV DL, 00H
    INT 10H

    ; Restart the game
    JMP GAME_START
    
RET 
GAME ENDP        
END MAIN