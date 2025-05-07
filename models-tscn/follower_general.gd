extends KinematicBody


var SPEED = 5.0
var velocity = Vector3.ZERO


var isFollowing = false


onready var NavAgent = $NavigationAgent


func _physics_process(delta):
	
	if isFollowing == true:
		var current_location = global_transform.origin
		var next_location = NavAgent.get_next_location()
		var location_disctance = next_location  - current_location
		var location_change = current_location - next_location
		var look_direction =  (location_change).normalized()
		var new_velocity = (location_disctance).normalized() * SPEED	
		look_at(current_location + look_direction, Vector3.UP)

		if location_disctance.length() > 1:
			walk();			
			NavAgent.set_velocity(new_velocity);
		else:
			idle();
			NavAgent.set_velocity(Vector3.ZERO);
		
	else:
		idle();	
		NavAgent.set_velocity(Vector3.ZERO);
		
	
#This function call on the game fuction to keep the player location up to date
func update_target_location(target_location):
	NavAgent.set_target_location(target_location )
	
func walk():
	if name == "PolarBearCharacterwithscarf":
		var animationPlayer = $AnimationPlayer;
		if(animationPlayer.get_current_animation() != "PBearWalkScarf"):
			animationPlayer.play("PBearWalkScarf",0.05);
	elif name == "fox no goggles":
		var animationPlayer = $AnimationPlayer;
		if(animationPlayer.get_current_animation() != "fox_walk"):
			animationPlayer.play("fox_walk",0.05);
	elif name == "fox with goggles":
		var animationPlayer = $AnimationPlayer;
		if(animationPlayer.get_current_animation() != "fox_goggles_walk"):
			animationPlayer.play("fox_goggles_walk",0.05);
	elif name == "bunny":
		var animationPlayer = $AnimationPlayer;
		if(animationPlayer.get_current_animation() != "walk2"):
			animationPlayer.play("walk2",0.05);
	elif name == "SquirrelLeaf":
		var animationPlayer = $AnimationPlayer;
		if(animationPlayer.get_current_animation() != "SquirrelWalk"):
			animationPlayer.play("SquirrelWalk",0.05);
	
	
func idle():
	if name == "PolarBearCharacterwithscarf":
		var animationPlayer = $AnimationPlayer;
		if(animationPlayer.get_current_animation() != "PBearIdleScarf"):
			animationPlayer.play("PBearIdleScarf",0.15);
	elif name == "fox no goggles":
		var animationPlayer = $AnimationPlayer;
		if(animationPlayer.get_current_animation() != "fox_idle"):
			animationPlayer.play("fox_idle",0.15);
	elif name == "fox with goggles":
		var animationPlayer = $AnimationPlayer;
		if(animationPlayer.get_current_animation() != "fox_goggles_idle"):
			animationPlayer.play("fox_goggles_idle",0.15);
	elif name == "bunny":
		var animationPlayer = $AnimationPlayer;
		if(animationPlayer.get_current_animation() != "idle"):
			animationPlayer.play("idle",0.15);
	elif name == "SquirrelLeaf":
		var animationPlayer = $AnimationPlayer;
		if(animationPlayer.get_current_animation() != "SquirrelIdle"):
			animationPlayer.play("SquirrelIdle",0.15);
	
	
# If we plan to keep multiple animals or followers together this might be helpful
func _on_NavigationAgent_velocity_computed(safe_velocity):
	velocity = velocity.move_toward(safe_velocity, 0.25)
	move_and_slide(velocity)

func startFollowing():
	isFollowing = true;
 
func stopFollowing():
	isFollowing = false;
