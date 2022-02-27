# Author: Jakob Tiger
# Date: Oct 1, 2021
# Description: I have created a dice rolling game called “Lucky 25”, which is 2 or 3 players. The users
# are greeted with the rules of the game at the very start. The goal of the game is to roll a set of two
# dies, every time you roll the dice the total of both dies combined is added to your previous roll.
# You as the player want to get as close as possible to 25 or exactly 25. I have also added a feature
# in which if the die is equal to each other in one of your rolls you are given the option to reroll or
# keep your roll. Once you get as close to 25 as you are satisfied with you may end your turn and
# the next player is prompted to go. If you hit exactly 25 you automatically win unless somebody
# else ties you. In the end whoever is closest to 25 without going over wins the game.


.data

newline: .asciiz "\n"
welcome: .asciiz "Welcome to LUCKY 25!\n\n"
tostart: .asciiz "Enter 5 to start: "
rules: .asciiz "Rules:\nEach player will be prompted to the roll the dice. The goal is to get exactly 25 or as close as possible.\nIf you roll doubles will have the option to replace the value you rolled, to prevent busting.\nOnce you are satisfied with your score you may end your turn.\n"
players: .asciiz "\nSelect the number of players by entering 1 or 2:\n1. 2 players\n2. 3 players\n"
error: .asciiz "\nERROR: MUST ENTER 5 TO START. PLEASE TRY AGAIN\n"
players2: .asciiz "\n\n~~2 PLAYERS SELECTED~~\n\n"
players3: .asciiz "\n\n~~3 PLAYERS SELECTED~~\n\n"
name: .asciiz "\nEnter players 1 name:\n"
name1: .asciiz "\nEnter players 2 name:\n"
name2: .asciiz "\nEnter players 3 name:\n"
playername1: .asciiz "\nPlayer 1: "
playername2: .asciiz "\nPlayer 2: "
playername3: .asciiz "\nPlayer 3: "
player1: .space 20
player2: .space 20
player3: .space 20
dicearray: .word 1,2,3,4,5,6
rolldice1: .asciiz "Player 1's turn, enter '6' to the roll the dice!\n\n"
rolldice2: .asciiz "\n\nPlayer 2's turn, enter '6' to the roll the dice!\n\n"
rolldice3: .asciiz "\n\nPlayer 3's turn, enter '6' to roll the dice!\n\n"
prompt: .asciiz "\n\nYou rolled: "
equal: .asciiz "You rolled doubles of total: "
reroll: .asciiz "\n\nIf you would like to reroll press 1, if you would like to keep your roll press 2\n"
score: .asciiz "\n\nTurn ended. Total score: "
score22: .asciiz "\n\nTurn ended. Player 2 total score: "
score1: .word 0
score2: .word 0
score3: .word 0
rollagain: .asciiz "\nTo continue rolling press '6', to end your turn press '1'\n"
currenttotal: .asciiz "\nYour current total is: "
score25: .asciiz "\nYOU GOT 25, YOU WIN!!! Unless someone else hits 25.\n"
bust: .asciiz "\nYou busted! Better luck next time :(\n"
wins: .asciiz "Wins!"
draw: .asciiz "It's a draw! Good game!"
array:  .word 1,2,3
	.word 0,0,0
space: .asciiz " "


.text

welcomestart: 
	li $v0, 4
	la $a0, welcome
	syscall
	la $a0, rules
	syscall 		#beginning text basic rules

#pseudocode:
#scanf("%d", &gamestart)
#if (gamestart == 5) 
#move into gamestart
#else return
start:
	li $v0, 5 		#reading user integer input
	syscall
	move $t0, $v0
	li $t1, 5 		#loading immediate value 5

	beq $t0, $t1, gamestart #if user enters 5 jump to gamestart
	li $v0, 4 
	la $a0, error
	syscall 
	j start 		#if user enters anything besides 5 they are asked to retry

#pseudocode: 
#scanf("%d", players)
#if (players == 1)
#start 2 player loop
#else if (players == 2)
#start 3 player loop
gamestart:

	li $v0, 4
	la $a0, players 	#prompt user to select number if players
	syscall

	li $v0, 5 		#reading user input 
	syscall 
	move $t0, $v0
	li $t1, 1
	li $t2, 2

	beq $t0, $t2, threeplayer #if user enters 2 threeplayer is started, else twoplayer is started
	beq $t0, $t1, twoplayer

twoplayer:

#pseudocode: 
#printf("\nEnter players 1 name:\n");
#scanf("%s", name1);
#printf("\nEnter players 2 name:\n");
#scanf("%s", name2);
#printf("\nPlayer 1: %s\nPlayer 2: %s\n\n", name1, name2); //getting player names

	li $v0, 4
	la $a0, players2
	syscall 
	
	li $v0, 4
	la $a0, name 		#prompting player 1 name
	syscall 
	
	li $v0, 8
	la $a0, player1 	#reading player 1 name
	li, $a1, 20
	syscall 
	
	li $v0, 4
	la $a0, name1 		#prompting player 2 name
	syscall 
	
	li $v0, 8
	la $a0, player2 	#reading player 2 name
	li, $a1, 20
	syscall 
	
	li $v0, 4
	la $a0, playername1
	syscall
	la $a0, player1 	#displaying user player 1 name
	syscall
	la $a0, newline
	syscall
	la $a0, playername2
	syscall
	la $a0, player2 	#displaying user player 2 name
	syscall 
	la $a0, newline
	syscall
	

#pseudocode: 
#printf(Player's 1 turn. Enter '6' to roll the dice.\n\n");
#player1 = diceGame(); 
#printf("Player's 2 turn. Enter 'r' to roll the dice.\n\n", name2);
#player2 = diceGame();	

	la $a0, rolldice1 	#prompt player 1 to roll dice
	syscall 
	
	li $v0, 5 		#getting user input
	syscall
	move $t0, $v0
	li $t1, 6
	
	bne $t0, $t1, end 	#if user input is anything other then 6 program ends
	jal game 		#diceGame();
	addi $s5, $v1, 0	#storing final score to $t4
	
	li $v0, 4
	la $a0, rolldice2 	#prompt player 2 to roll dice
	syscall 
	
	li $v0, 5 		#getting user input
	syscall
	move $t0, $v0
	li $t1, 6
	
	bne $t0, $t1, end 	#if user input is anything other then 6 program ends
	jal game 		#diceGame();
	addi $s6, $v1, 0	#storing final score to $t5
	
#pseudocode:
# if (player1 > player2) 
#              printf("\n");
#              printf("%s WINS! GAME OVER\n\n", name1);
#          
# else if (player2 > player1) 
#              printf("\n");
#              printf("%s WINS! GAME OVER\n\n", name2);
#       
# else if (player1 == player2) 
#              printf("\n");
#              printf("IT'S A DRAW! GOOD GAME!\n\n");
#  

	
	li $t0, 3 #totalcol
	li $t3, 1 #row
	li $t4, 0 #col

	la $t2, array #baseaddress

	mul $t5, $t3, $t0
	add $t5, $t5, $t4
	sll $t5, $t5, 2
	add $t5, $t5, $t2
	sw $s5, 0($t5)

	li $t4, 1
	mul $t5, $t3, $t0
	add $t5, $t5, $t4
	sll $t5, $t5, 2
	add $t5, $t5, $t2
	sw $s6, 0($t5)
	
	

	bgt $s5, $s6, player1win	#if (player1 > player2)
	bgt $s6, $s5, player2win	#if (player2 > player1)
	beq $s5, $s6, tiegame		#if (player1 == player2)
	
	
	player1win:
	
	li $v0, 4
	la $a0, newline
	syscall
	la $a0, player1 	#printing player name
	syscall
	la $a0, wins		#printing win message
	syscall
	la $a0, newline
	syscall
	
	jal printarray
	jal winsound		#game over sound effect 
	
	li $v0, 10		#end program
	syscall 
	
	
	player2win:
	li $v0, 4
	la $a0, newline
	syscall
	la $a0, player2 	#displaying user player 2 name
	syscall
	la $a0, wins		#printing win message
	syscall
	jal winsound
	li $v0, 10		#end game
	syscall 
	
	
	tiegame:
	li $v0, 4
	la $a0, newline
	syscall
	la $a0, draw		#printing its a tie message
	syscall
	jal winsound
	li $v0, 10		#ending program
	syscall 

threeplayer:
	li $v0, 4
	la $a0, players3  	#printing 3 player message
	syscall 
	
#pseudocode:
#printf("\nEnter players 1 name:\n");
#scanf("%s", name1);
#printf("\nEnter players 2 name:\n");
#scanf("%s", name2);
#printf("\nEnter players 3 name:\n");
#scanf("%s", name3);	
	
	li $v0, 4
	la $a0, name 		#asking user to enter player1 name	
	syscall
	
	li $v0, 8
	la $a0, player1		#scanf("%s, name1);
	li $a1, 20
	syscall
	
	li $v0, 4
	la $a0, name1 		#asking user to enter player2 name
	syscall
	
	li $v0, 8
	la $a0, player2		#scanf("%s", name2);
	li $a1, 20
	syscall
	
	li $v0, 4
	la $a0, name2 		#asking user to enter player3 name
	syscall
	
	li $v0, 8
	la $a0, player3		#scanf("%s", name3);
	li $a1, 20
	syscall
	
#pseudocode:
#printf("\nPlayer 1: %s\nPlayer 2: %s\nPlayer 3: %s\n\n", name1, name2, name3);
	li $v0, 4
	la $a0, playername1
	syscall
	la $a0, player1	 	#displaying user player 1 name
	syscall
	la $a0, newline
	syscall
	la $a0, playername2
	syscall
	la $a0, player2 	#displaying user player 2 name
	syscall 
	la $a0, newline
	syscall
	la $a0, playername3
	syscall
	la $a0, player3 	#displaying player 3
	syscall
	la $a0, newline
	syscall
	
#pseudocode:
#printf(Player's 1 turn. Enter '6' to roll the dice.\n\n");
#player1 = diceGame(); 
#printf("Player's 2 turn. Enter 'r' to roll the dice.\n\n", name2);
#player2 = diceGame();	
#printf("Player's 3 turn. Enter 'r' to roll the dice.\n\n", name2);
#player3 = diceGame();	
	
	la $a0, rolldice1 	#printf(Player's 1 turn. Enter '6' to roll the dice.\n\n");
	syscall 
	
	li $v0, 5 		#getting user input
	syscall
	move $t0, $v0
	li $t1, 6
	
	bne $t0, $t1, end 	#if user input is anything other then 6 program ends
	jal game 		#player1 = diceGame(); 
	addi $s4, $v1, 0	#storing player score in $t4
	
	li $v0, 4
	la $a0, rolldice2 	#printf(Player's 2 turn. Enter '6' to roll the dice.\n\n");
	syscall 
	
	li $v0, 5 		#getting user input
	syscall
	move $t0, $v0
	li $t1, 6
	
	bne $t0, $t1, end 	#if user input is anything other then 6 program ends
	jal game 		##player2 = diceGame(); 
	addi $s5, $v1, 0	#playing player score in #t5
	
	li $v0, 4
	la $a0, rolldice3 	#printf(Player's 2 turn. Enter '6' to roll the dice.\n\n");
	syscall 
	
	li $v0, 5 		#getting user input
	syscall
	move $t0, $v0
	li $t1, 6
	
	bne $t0, $t1, end 	#if user input is anything other then 6 program ends
	jal game 		##player3 = diceGame(); 
	addi $s6, $v1, 0	#storing player score in $t6
	
	
#pseudocode: 
#if (player1 > player2 && player1 > player3) {
#                printf("\n%s WINS! GAME OVER\n", name1);
#else if (player2 > player1 && player2 > player3) {
#                printf("\n%s WINS! GAME OVER\n", name2);
#else if (player3 > player1 && player3 > player2) {
#              printf("\n%s WINS! GAME OVER\n", name3);
#else if (player1 == player2 && player1 == player3 && player3 == player2) {
#                printf("\nIT'S A DRAW! GOOD GAME!\n");
	
	bgt $s4, $s5, check  	#if player1 > player2
	bgt $s5, $s4, check1 	#if player2 > player1
	bgt $s6, $s4, check2 	#if player3 > player1
	
	check:
	bgt $s4, $s6, win1 	#if player1 > player3
	check1:
	bgt $s5, $s6, win2 	#if player2 > player3
	check2:
	bgt $s6, $s5, win3 	#if player3> player2
	
	win1: 
	li $v0, 4
	la $a0, newline
	syscall
	la $a0, player1 	#displaying user player 1 name
	syscall
	la $a0, wins
	syscall
	jal winsound
	li $v0, 10
	syscall 
	
	win2: 
	li $v0, 4
	la $a0, newline
	syscall
	la $a0, player2 	#displaying user player 2 name
	syscall
	la $a0, wins
	syscall
	jal winsound
	li $v0, 10
	syscall 
	
	win3:
	li $v0, 4
	la $a0, newline
	syscall
	la $a0, player3 	#displaying user player 3 name
	syscall
	la $a0, wins
	syscall
	jal winsound
	li $v0, 10
	syscall 	
	
dice: 	
	li $t0, 60 #pitch
	li $t1, 62 #pitch
	li $t2, 67 #pitch
	li $t3, 500 #duration
	li $t4, 113 #istrument
	li $t5, 75 #volume

	move $a0, $t0 #moving all to a registers
	move $a1, $t3
	move $a2, $t4
	move $a3, $t5
	li $v0, 31 #service to play midi
	syscall 
	move $a0, $t1
	li $v0, 31
	syscall
	move $a0, $t2
	li $v0, 31
	syscall
	
	li $v0, 42 		#random number generator
	li $a1, 6 		#max number 
	syscall
	add $a0, $a0, 1 	#lowest bound
	#jal dicelfsr
	move $t0, $a0 		#storing die1 into $t0
	li $v0, 42 		#random number generator
	li $a1, 6 		#max number 
	syscall
	add $a0, $a0, 1 	#lowest bound
	#jal dicelfsr 		#storing die2 into $t1
	move $t1, $a0
	add $t2, $t0, $t1 	#adding die 1 and 2 together
				#above sourced from stack overflow, link supplied in report
	
	bne $t0, $t1, total 	#if die are not equal jump to total, if they are ask user if they want to re roll
	li $v0, 4
	la $a0, equal
	syscall
	li $v0, 1
	move $a0, $t2 		#showing user total with double roll
	syscall
	li $v0, 4
	la $a0, reroll 		#ask them to press 1 for reroll and 2 to keep roll
	syscall
	li $v0, 5 		#read user input
	syscall
	move $t5, $v0
	li $t3, 1
	li $t4, 2
	beq $t3, $t5, dice 	#if user enters 1 function restarted, if not jump to total
	j total
	
	
	total:
	li $v0, 4
	la $a0, prompt
	syscall
	move $a0, $t2
	li $v0, 1 		#printing total roll
	syscall
	
	
	
	jr $ra 			#returning to main with value stored in $ra
	
game: 
	addi $sp, $sp, -12 	#making room in stack
	sw $ra, 8($sp) 		#storing original return address in stack
	jal dice
	move $v1, $t2
	
	goagain:
	li $v0, 4
	la $a0, rollagain 	#ask user to continue or end turn
	syscall
	li $v0, 5
	syscall
	move $t0, $v0
	li $t1, 6
	bne $t0, $t1, endturn 	#if user chooses to stop jump to endturn
	jal dice
	add $v1, $v1, $t2 	#adding total to new total
	li $t3, 25
	beq $v1, $t3, youwon 	#if user gets exactly 25, auto end turn
	bgt $v1, $t3, youlost 	#if user go over 25, auto end turn and set score to 0
	li $v0, 4
	la $a0, currenttotal 	#displaying current total
	syscall
	li $v0, 1
	move $a0, $v1
	syscall
	j goagain
	
	
	endturn:
	li $v0, 4
	la $a0, score
	syscall
	li $v0 1
	move $a0, $v1
	syscall
	j mainreturn
	
	youwon:
	li $v0, 4
	la $a0, score25
	syscall
	li $v0, 4
	la $a0, score
	syscall
	li $v0 1
	move $a0, $v1
	syscall
	j mainreturn
	
	youlost:
	li $v0, 4
	la $a0, bust
	syscall
	li $v0, 4
	la $a0, score
	syscall
	li $v0, 1
	mul $v1, $v1, $zero 		#set score to 0 if go over 25
	move $a0, $v1
	syscall
	j mainreturn
	
	
	mainreturn:
	lw $ra, 8($sp) 			#loading origianl return address
	addi $sp, $sp, 12 		#restoring stack
	jr $ra

end: 
	li $v0, 10 			#function to terminate
	syscall
	
winsound: 
	li $t0, 60 #pitch
	li $t1, 62 #pitch
	li $t2, 67 #pitch
	li $t6, 72 #pitch
	li $t3, 500 #duration
	li $t4, 88 #istrument
	li $t5, 75 #volume
	move $a0, $t0 #moving all to corresponding registers for service 31
	move $a1, $t3
	move $a2, $t4
	move $a3, $t5
	li $v0, 31 #service to play midi
	syscall 
	move $a0, $t1 #reloading a0 with each different pitch and playing again
	li $v0, 31
	syscall
	move $a0, $t2
	li $v0, 31
	syscall
	move $a0, $t6
	li $v0, 31
	syscall
	
	jr $ra



	printarray:
	li $t0, 3 #totalcol
	li $t3, 0 #row
	li $t4, 0 #col

	la $t2, array #baseaddress

	printarraycol:

	mul $t5, $t3, $t0
	add $t5, $t5, $t4
	sll $t5, $t5, 2
	add $t5, $t5, $t2

	li $v0, 1
	lw $a0, 0($t5)
	syscall

	li $v0, 4
	la $a0, space
	syscall

	addi $t4, $t4, 1

	bge $t4, $t0, new
	j printarraycol

	new:
	li $v0, 4
	la $a0, newline
	syscall
	li $t3, 1 #row 1
	li $t4, 0 #col
	j printarrayrow


	printarrayrow:


	mul $t5, $t3, $t0
	add $t5, $t5, $t4
	sll $t5, $t5, 2
	add $t5, $t5, $t2

	li $v0, 1
	lw $a0, 0($t5)
	syscall

	li $v0, 4
	la $a0, space
	syscall

	addi $t4, $t4, 1

	bge $t4, $t0, end5
	j printarrayrow

	end5:
	jr $ra
	
	




 
