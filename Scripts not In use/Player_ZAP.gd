extends KinematicBody

var speed = 18
var acceleration = 6
var gravity = 1
var jump = 18

var mouse_sensitivity = 0.05

var direction = Vector3()
var velocity = Vector3()
var fall = Vector3() 
onready var raycast = $Camera/InteractionRaycast
onready var game = get_node_or_null("/root/Game");
onready var cat = preload("res://levels/Cabin Cut Scene-KennedyG/AnimatedCat.tscn").instance()

var x = 0
var index_cat = 0



#Lock the Mouse in the dedicated screen
func _ready():
	
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	#the next method is to make the mouse visible
	#Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		
#Code for looking around 
func _input(event):
	
	if event is InputEventMouseMotion:
		rotate_y(deg2rad(-event.relative.x * mouse_sensitivity)) 
		$Camera.rotate_x(deg2rad(-event.relative.y * mouse_sensitivity)) 
		$Camera.rotation.x = clamp($Camera.rotation.x, deg2rad(-90), deg2rad(90))
	
	#when the escape key is pressed allows the mouse to be free
	if event is InputEventKey and event.scancode == KEY_ESCAPE:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	#to reclick back in the game
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


#Basic Player Movement Including Jump
func _physics_process(delta):
	
	
	if Input.is_action_just_pressed("Interact"):
		
		if raycast.is_colliding():
			var collider = raycast.get_collider()
			
			#Logic:
			
			#Cat
			if collider.is_in_group("Cat"):
				index_cat = index_cat + 1
				game.interactWithObject("Cat")
				if index_cat > 2:
					cat.playCutScene();
					game.interactWithObject("Cat");
				print("Catttttyyyy")

			#Polar Bear
			if collider.is_in_group("BeachLevel1"):
				game.interactWithObject("BearWithoutScarf")
				print("Beach1")
				
			if collider.is_in_group("BeachLevel"):
				game.interactWithObject("BearWithScarf")
				print("Beach2")
				
			if collider.is_in_group("Polarbear"):
				game.interactWithObject("BearInIce")
				print("IceLevel")
			
			#Monster
			if collider.is_in_group("Monster"):
				game.interactWithObject("Monster")
				print("Rawrrr")
			
			#Hotair Balloon
			if collider.is_in_group("Hotair balloon"):
				game.triggerLevelChange(6)
				
				
			#Collectibles and Interctable:
			
			#IceNpcs
			if collider.is_in_group("IceNpcs") and collider.is_in_group("Penguin") or collider.is_in_group("NPCPolar"):
				game.interactWithObject("IceNPC")
				print("Oh hey... I'm just a snowman")

			#Carrots
			if collider.is_in_group("Anusha Carrot"):
				print(collider)
				collider.visible = false


	direction = Vector3()
	
	move_and_slide(fall, Vector3.UP)
		
	#Player Movement UI
	
	if not is_on_floor():
		fall.y -= gravity
		
	if Input.is_action_just_pressed("jump") and is_on_floor():
		fall.y = jump
	
	if Input.is_action_pressed("ui_up"):
		walk();
		direction -= transform.basis.z
	
	elif Input.is_action_pressed("ui_down"):
		walk();
		direction += transform.basis.z
		
	else:
		idle();
		
	if Input.is_action_pressed("ui_left"):
		direction -= transform.basis.x			
		
	elif Input.is_action_pressed("ui_right"):
		direction += transform.basis.x

	direction = direction.normalized()
	velocity = velocity.linear_interpolate(direction * speed, acceleration * delta) 
	velocity = move_and_slide(velocity, Vector3.UP)

func walk():
	var animationPlayer = $"Player Character/AnimationPlayer";
	if(animationPlayer.get_current_animation() != "PlayerWalk"):
		animationPlayer.play("PlayerWalk",0.05);
		
func idle():
	var animationPlayer = $"Player Character/AnimationPlayer";
	if(animationPlayer.get_current_animation() != "PlayerIdle"):
		animationPlayer.play("PlayerIdle",0.15);
		
