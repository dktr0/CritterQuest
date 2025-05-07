extends CanvasLayer

func _ready():
	OS.set_window_fullscreen(true);
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE);

func _physics_process(_delta):
	if Input.is_action_just_pressed("fullscreen"):
		OS.set_window_fullscreen(!OS.window_fullscreen);
	if Input.is_action_just_pressed("first_level"):
		get_tree().change_scene("res://Game.tscn");
	if Input.is_action_just_pressed("any_controller_button"):
		startGame();
	
func _on_ExitButton_pressed():
	get_tree().quit()

func _on_BeginButton_pressed():
	startGame();
	
func startGame():
	get_tree().change_scene("res://Start Screen Stuff/CreditsVersion2.tscn")
	
	
	
	
