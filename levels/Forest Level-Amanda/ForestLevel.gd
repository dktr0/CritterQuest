extends Spatial

onready var game = $"/root/Game"

func _on_TeleportToTreetop_body_entered(body):
	game.teleportEntered("ForestToTreetop",body);

func _on_TeleportToTreetop_body_exited(body):
	game.teleportExited("ForestToTreetop",body);
