extends Spatial

onready var game = $"/root/Game";

func _on_TransitionToIce_body_entered(body):
	game.teleportEntered("BeachToIce",body);

func _on_transitiontoforest_body_entered(body):
	game.teleportEntered("BeachToForest",body);

func _on_transitiontoforest_body_exited(body):
	game.teleportExited("BeachToForest",body);

func _on_TransitionToIce_body_exited(body):
	game.teleportExited("BeachToIce",body);


