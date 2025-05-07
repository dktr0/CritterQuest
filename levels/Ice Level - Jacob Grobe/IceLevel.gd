extends Spatial

onready var game = $"/root/Game";

func _on_TeleportToBeach_body_entered(body):
	game.teleportEntered("IceToBeach",body);

func _on_TeleportToBeach_body_exited(body):
	game.teleportExited("IceToBeach",body);
