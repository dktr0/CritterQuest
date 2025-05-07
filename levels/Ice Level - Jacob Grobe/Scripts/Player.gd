extends KinematicBody


onready var camera = $Camera;
var speed = 15
var velocity = Vector3.ZERO
var gravity = Vector3.DOWN * 12

func _ready(): #captures cursor
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):

	if event is InputEventMouseMotion:
		var movement = event.relative;
		camera.rotation.x += -deg2rad(movement.y * 0.5);
		camera.rotation.x = clamp(camera.rotation.x,deg2rad(-30),deg2rad(75));
		camera.rotation.y += -deg2rad(movement.x * 0.2);

	#Captures and Frees the mouse cursor
	if Input.is_action_just_pressed("ui_cancel"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)




func _physics_process(delta):
	var dir = Vector2(0,0);
	var direction = Vector3.ZERO
	velocity += gravity * delta
	velocity = move_and_slide(velocity, Vector3.UP)
	
	if(Input.is_action_pressed("ui_left")): #left
		dir.y += 1;
	if(Input.is_action_pressed("ui_right")): #right
		dir.y -= 1;
	if(Input.is_action_pressed("ui_up")): #forward
		dir.x -= 1;
	if(Input.is_action_pressed("ui_down")): #back
		dir.x += 1;
	dir = dir.normalized().rotated(-camera.rotation.y); #lock camera to direction of mouse, therefore controls too
	var speed = 8;
	var vel = Vector3(dir.x*speed,0,dir.y*speed);

	move_and_slide(vel,Vector3.UP); #kill player if they are below y -35
	if get_translation().y < -35:
		queue_free()
		get_tree().change_scene("res://scenes/GameOver.tscn") 
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		
func _on_Area_body_entered(body): 

	if(body.is_in_group("Projectile")):
		body.queue_free(); # delete the projectile
		queue_free(); #kill the player
		get_tree().change_scene("res://scenes/GameOver.tscn") #restart game
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE) #give player mouse control
		





