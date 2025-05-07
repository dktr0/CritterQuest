extends CanvasLayer

onready var animation = $AnimationPlayerforCredits

func _ready():
	animation.play()

func _physics_process(_delta):
	if Input.is_action_just_pressed("fullscreen"):
		OS.set_window_fullscreen(!OS.window_fullscreen);
	 # Replace with function body.
	
func _on_AnimationPlayerforCredits_animation_finished(CreditsAnimation):
	get_tree().change_scene("res://Game.tscn");
