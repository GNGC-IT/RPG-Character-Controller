extends PlayerState

func enter(player: Player):
	if player.character_profile == "big_guy":
		player.anim.speed_scale = 2
	player._set_anim("spawn")
	pass

func exit(player: Player):
	pass


func animation_finished(player:Player, anim_name):
	if player.character_profile == "big_guy":
		player.anim.speed_scale = 1
	player.changeState(player.StateName.MOVEMENT)
