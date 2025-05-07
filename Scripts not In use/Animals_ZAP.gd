extends KinematicBody

var SPEED = 5.0
var velocity = Vector3.ZERO
var sensory = false


onready var NavAgent = $NavigationAgent


func _physics_process(delta):
	#getting location of the animal
	var current_location = global_transform.origin
	#getting players location
	var next_location = NavAgent.get_next_location()
	#Updating a new location distance
	var location_disctance = next_location - current_location
	#Getting a new velocity
	var new_velocity = (location_disctance).normalized() * SPEED
	

	
	#To allow the object to continue following after coming to a stop as player stops
	if location_disctance.length() > 3.0:
		sensory = false
	
	#Follows the player with the fixed velocity above
	if sensory == false:
		NavAgent.set_velocity(new_velocity)
		
	#As soon as the animal is in range of player it stops moving
	if sensory == true:
		NavAgent.set_velocity((location_disctance).normalized() * 0 )
	
#This function call on the game fuction to keep the player location up to date
func update_target_location(target_location):
	NavAgent.set_target_location(target_location )

#This detects the player is in range and sends a signal
func _on_NavigationAgent_target_reached():
	sensory = true
	return sensory
	
	
# If we plan to keep multiple animals or followers together this might be helpful
func _on_NavigationAgent_velocity_computed(safe_velocity):
	velocity = velocity.move_toward(safe_velocity, 0.15)
	move_and_slide(velocity)
