extends Camera

onready var balloon = get_node("../balloon")

func _process(delta):
	look_at(balloon.global_transform.origin, Vector3.UP)
