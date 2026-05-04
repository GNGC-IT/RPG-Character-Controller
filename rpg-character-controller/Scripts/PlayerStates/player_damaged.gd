extends PlayerState

func enter(player: Player):
	player._set_anim("hit")
	player.velocity = Vector3.ZERO
	pass


func animation_finished(player:Player, anim_name):
	player.changeState(player.StateName.MOVEMENT)
