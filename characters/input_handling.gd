extends CharacterBody2D

var persistentState : Node2D




#All and all I hate this, I can't think of anything better right now
#I'd love for it to be one file for input handling for both players though
#since it'd make the special move detection probably easier to write, and DRY
#principles of course/ But this will get very messy
var leftString
var rightString
var upString
var downString

var currentDirection
#Player 1 is a and d atm, player 2 is left and right
func _ready():
	if(name == "Player1"):
		persistentState = get_node("Player1State")
		leftString = "player1_left"
		rightString = "player1_right"
		upString = "player1_up"
		downString = "player1_down"
	else:
		persistentState = get_node("Player2State")		
		leftString = "player2_left"
		rightString = "player2_right"
		upString = "player2_up"
		downString = "player2_down"
	currentDirection = persistentState.direction

#The extra if checks here make it so you can hold left or right cross screen
#and it will probably go into the walk backwards


# All inputs are assumed, for consistency, that the player is facing right.
# if they are facing left, we flip the stick values as though they were facing right
# This implementation may become problematic if we decide to introduce charge characters, where a '4' input needs to be held for 30 frames
# The way the array is initialized also means the game takes at least 1 second to start accepting inputs, as the buffer waits to fill before
# reading new inputs
func _process(_delta):
	# We call the buffer every time so it updates
	var buffer = persistentState.inputBuffer
	if(buffer.front() == null):
		return
	
	if (persistentState.direction == persistentState.directions.LEFT):
		for node in persistentState.inputBuffer:
			node.inverseDirection()
	# Now, we can check for every type of input here, and execute a state change based on priority
	# if we find a super input first, we super, if not, we special, attack, move, etc.
	# exact hierarchy is in the design doc in the discord
	#print(buffer.slice(-1)[0].toString())
	if(buffer.slice(-1)[0].stickPosition == 7):
		persistentState.backward_jump()
	if(buffer.slice(-1)[0].stickPosition == 8):
		persistentState.neutral_jump()
	if (buffer.slice(-1)[0].stickPosition == 9):
		persistentState.forward_jump()
	if(buffer.slice(-1)[0].stickPosition == 6):
		persistentState.move_forward()
	if(buffer.slice(-1)[0].stickPosition == 4):
		persistentState.move_backwards()
