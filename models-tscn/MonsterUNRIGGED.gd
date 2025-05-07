extends KinematicBody


var SPEED = 5.0
var velocity = Vector3.ZERO
var sensory = false
var interacted = false

var isFollowing = false

onready var NavAgent = $NavigationAgent


func _physics_process(delta):
	#getting location of the animal
	var current_location = global_transform.origin
	#getting players location
	var next_location = NavAgent.get_next_location()
	#Updating a new location distance
	var location_disctance = next_location - current_location
	var location_change = current_location - next_location
	#Getting a new velocity
	var look_direction =  (location_change).normalized()
	var new_velocity = (location_disctance).normalized() * SPEED
	
	look_at(current_location + look_direction, Vector3.UP)
	#To allow the object to continue following after coming to a stop as player stops
	if isFollowing:
	# do stuff for following
		#Do stuff when too close
		if location_disctance.length() > 4.0:
			#idle()
			return NavAgent.set_velocity(Vector3.ZERO)
		else:
			NavAgent.set_velocity(new_velocity)
			#walk()
	else:
	# alternately do stuff only if not following
		#idle()
		return NavAgent.set_velocity(Vector3.ZERO)
	
#This function call on the game fuction to keep the player location up to date
func update_target_location(target_location):
	NavAgent.set_target_location(target_location )
	
"""
func walk():
	var animationPlayer = $AnimationPlayer;
	if(animationPlayer.get_current_animation() != "PBearWalkScarf"):
		animationPlayer.play("PBearWalkScarf",0.05);
		
func idle():
	var animationPlayer = $AnimationPlayer;
	if(animationPlayer.get_current_animation() != "PBearIdleScarf"):
		animationPlayer.play("PBearIdleScarf",0.15);
"""

# If we plan to keep multiple animals or followers together this might be helpful
func _on_NavigationAgent_velocity_computed(safe_velocity):
	velocity = velocity.move_toward(safe_velocity, 0.25)
	move_and_slide(velocity)

func startFollowing():
	isFollowing = true;

func stopFollowing():
	isFollowing = false;
