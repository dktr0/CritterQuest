extends Camera

var balloon

func _ready():
	balloon = get_parent().get_node("balloon")

func _process(delta):
	var target_position = player_container.global_transform.origin
	var target_rotation = player_container.global_transform.basis.get_euler()
	global_transform.origin = lerp(global_transform.origin, target_position, delta * 5)
	global_transform.basis = lerp(global_transform.basis, target_rotation, delta * 5)

