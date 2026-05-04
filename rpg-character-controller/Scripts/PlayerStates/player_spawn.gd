extends PlayerState

func enter(player: Player):
	player._set_anim("spawn")
	pass

func exit(player: Player):
	pass


func animation_finished(player:Player, anim_name):
	player.changeState(player.StateName.MOVEMENT)
