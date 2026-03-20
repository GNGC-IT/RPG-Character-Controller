extends PlayerState

func enter(player):
	player.anim.current_animation = "med_anims/Death_A"
	player.velocity = Vector3.ZERO
	pass

func exit(player: Player):
	pass

func physics_process(player: Player, delta):
	pass
