extends StaticBody

onready var game = $"/root/Game"
onready var player = $"/root/Game/Player"
#Is the area in which the player is detecttable
onready var playerDetectArea = $PlayerDetectArea
#Just a UI that shows E 
onready var pressE = $UI_E

func _ready():
	#setting the interactable button to false untill the player is in the area
	pressE.visible = false
	
func interact():
	if playerDetectArea.overlaps_body(player):
		#this is just a UI that pops up when the player is in the Detect Area of the object
		pressE.visible = true
		if Input.is_action_just_pressed("interact"):
			#this line of code works only after the UI is visible
			#when the player Interacts with the object with the E button
			#Game responds to the function clickedSomething
			game.clickeSomething(name)
			#This function is bound to change depending on how its defined in the Game gd
			#We can also generate a signal here to send to the player script
			#We can then in player script collect the object 
