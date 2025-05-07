extends Camera

func _ready():
	$AnimationPlayer.play("Camera");
	
func _process(delta):
	if not $AnimationPlayer.is_playing():
		queue_free()
