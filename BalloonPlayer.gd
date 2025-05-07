extends KinematicBody

var speed = 18
var acceleration = 6
var jump = 10

var mouse_sensitivity = 0.05

var direction = Vector3()
var velocity = Vector3()
var fall = Vector3() 
onready var raycast = $Camera/InteractionRaycast
onready var game = get_node_or_null("/root/Game");


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


func _physics_process(delta):
	
	# interaction
	if Input.is_action_just_pressed("Interact"):
		if raycast.is_colliding():
			var collider = raycast.get_collider()
			if collider.is_in_group("Cat"):
				game.interactWithObject("Cat")
				print("Catttttyyyy")
			if collider.is_in_group("Anusha Carrot"):
				print(collider)
				collider.visible = false
			if collider.is_in_group("Anusha Snowman"):
				print("Oh hey... I'm just a snowman")
			if collider.is_in_group("Polar bear"):
				print("Take me away")
			if collider.is_in_group("Hotair balloon"):
				game.triggerLevelChange(6)

	# movement control
	direction = Vector3()
	var leftStick = Input.get_vector("look_left","look_right","look_up","look_down");
	rotate_y(-leftStick.x*0.04); 
	var camera = $Camera;
	camera.rotation.x -= leftStick.y * 0.04;
	camera.rotation.x = clamp(camera.rotation.x, deg2rad(-90), deg2rad(90));
	var wasd = Input.get_vector("move_left","move_right","move_forward","move_back");
	var upDown = Input.get_axis("balloon_down","balloon_up");
	direction += wasd.x * transform.basis.x;
	direction += wasd.y * transform.basis.z;
	direction += upDown * transform.basis.y;
	if direction.length() > 1:
		direction = direction.normalized();
	velocity = velocity.linear_interpolate(direction * speed, acceleration * delta);
	velocity = move_and_slide(velocity, Vector3.UP);
