extends PlayerState

func enter(player):
	player._set_anim("death")
	player.velocity = Vector3.ZERO
	pass

func exit(player: Player):
	pass

func physics_process(player: Player, delta):
	pass
