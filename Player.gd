extends KinematicBody

var speed = 18
var acceleration = 6
var gravity = 1
var jump = 18
var mouse_sensitivity = 0.05
var isBalloonPlayer = false;

var velocity = Vector3();
var fall = Vector3();

var raycast;
onready var interaction_label = $"/root/Game/UI/InteractionLabel";
onready var game = $"/root/Game";


func _ready():	
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	if name.count("Balloon") == 0:
		print("player.gd ready for GeneralPlayer");
		raycast = $InteractionRaycast;
	else:
		print("player.gd ready for BalloonPlayer");
		isBalloonPlayer = true;
		raycast = $Camera/InteractionRaycast
	interaction_label.set_text("Interact");
		

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


func _physics_process(delta):
	
	if !isBalloonPlayer:
		raycast.rotation.x = $Camera.rotation.x;

	# interaction and collection
	if raycast.is_colliding():
		var collider = raycast.get_collider();
		# print(collider.name);
		if collider.is_in_group("Interactable"):
			if Input.is_action_just_pressed("Interact"):
				# TODO: set text to ""
				var nameOfInteractedObject = collider.name;
				if collider.is_in_group("Collectable"):
					collider.queue_free();
				game.interactWithObject(nameOfInteractedObject);
				interaction_label.set_visible(false);
			else:
				interaction_label.set_visible(true);
		else:
			interaction_label.set_visible(false);
	else:
		interaction_label.set_visible(false);

	# movement and looking
	if !isBalloonPlayer:
		generalPlayerMovement(delta);
	else:
		balloonPlayerMovement(delta);


func generalPlayerMovement(delta):
	move_and_slide(fall, Vector3.UP)
	if not is_on_floor():
		fall.y -= gravity
	if Input.is_action_just_pressed("jump") and is_on_floor():
		fall.y = jump
	var leftStick = Input.get_vector("look_left","look_right","look_up","look_down");
	rotate_y(-leftStick.x*0.04); 
	var camera = $Camera;
	camera.rotation.x -= leftStick.y * 0.04;
	camera.rotation.x = clamp(camera.rotation.x, deg2rad(-90), deg2rad(90));
	var wasd = Input.get_vector("move_left","move_right","move_forward","move_back");
	var direction = Vector3(0,0,0);
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


func balloonPlayerMovement(delta):
	var leftStick = Input.get_vector("look_left","look_right","look_up","look_down");
	rotate_y(-leftStick.x*0.04); 
	var camera = $Camera;
	camera.rotation.x -= leftStick.y * 0.04;
	camera.rotation.x = clamp(camera.rotation.x, deg2rad(-90), deg2rad(90));
	var wasd = Input.get_vector("move_left","move_right","move_forward","move_back");
	var upDown = Input.get_axis("balloon_down","balloon_up");
	var direction = Vector3(0,0,0);
	direction += wasd.x * transform.basis.x;
	direction += wasd.y * transform.basis.z;
	direction += upDown * transform.basis.y;
	if direction.length() > 1:
		direction = direction.normalized();
	velocity = velocity.linear_interpolate(direction * speed, acceleration * delta);
	velocity = move_and_slide(velocity, Vector3.UP);


func walk():
	var animationPlayer = $"Player Character/AnimationPlayer";
	if(animationPlayer.get_current_animation() != "PlayerWalk"):
		animationPlayer.play("PlayerWalk",0.05);
		
func idle():
	var animationPlayer = $"Player Character/AnimationPlayer";
	if(animationPlayer.get_current_animation() != "PlayerIdle"):
		animationPlayer.play("PlayerIdle",0.15);
