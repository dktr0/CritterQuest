extends Spatial

onready var game = $"/root/Game";

func _on_TeleportToBeach_body_entered(body):
	game.teleportEntered("CabinToBeach",body);

func _on_TeleportToBeach_body_exited(body):
	game.teleportExited("CabinToBeach",body);
