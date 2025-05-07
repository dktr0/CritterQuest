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

var x = 0

func _ready():	
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		

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
	
	# interaction and collection
	if Input.is_action_just_pressed("Interact"):
		if raycast.is_colliding():
			var collider = raycast.get_collider()
			if collider.is_in_group("Interactable"):
				if collider.is_in_group("Collectable"):
					collider.queue_free();
				game.interactWithObject(collider.name);
			
	# jumping and falling
	move_and_slide(fall, Vector3.UP)
	if not is_on_floor():
		fall.y -= gravity
	if Input.is_action_just_pressed("jump") and is_on_floor():
		fall.y = jump
	
	# looking and walking
	var leftStick = Input.get_vector("look_left","look_right","look_up","look_down");
	rotate_y(-leftStick.x*0.04); 
	var camera = $Camera;
	camera.rotation.x -= leftStick.y * 0.04;
	camera.rotation.x = clamp(camera.rotation.x, deg2rad(-90), deg2rad(90));
	var wasd = Input.get_vector("move_left","move_right","move_forward","move_back");
	direction = Vector3(0,0,0);
	direction += wasd.x * transform.basis.x;
	direction += wasd.y * transform.basis.z;
	if direction.length() > 1:
		direction = direction.normalized();
	velocity = velocity.linear_interpolate(direction * speed, acceleration * delta);
	velocity = move_and_slide(velocity, Vector3.UP);
	if abs(wasd.y) > 0.1:
		walk();
	else:
		idle();

func walk():
	var animationPlayer = $"Player Character/AnimationPlayer";
	if(animationPlayer.get_current_animation() != "PlayerWalk"):
		animationPlayer.play("PlayerWalk",0.05);
		
func idle():
	var animationPlayer = $"Player Character/AnimationPlayer";
	if(animationPlayer.get_current_animation() != "PlayerIdle"):
		animationPlayer.play("PlayerIdle",0.15);
