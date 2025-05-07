extends KinematicBody


func playCutScene():
	cutscene2()
	print("Animation")

func cutscene2():
	var animationPlayer = $AnimationPlayer;
	animationPlayer.play("CatCutScene2",1);
	print("Played")
