extends StaticBody

func on_collide():
	$AnimationPlayer.play("Bump")
