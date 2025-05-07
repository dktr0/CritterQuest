extends Spatial

onready var game = $"/root/Game";

func _on_TeleportToSky_body_entered(body):
	game.teleportEntered("SkyToCabin",body);

func _on_TeleportToSky_body_exited(body):
	game.teleportExited("SkyToCabin",body);
