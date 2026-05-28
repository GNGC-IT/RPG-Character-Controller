extends PlayerState

func enter():
	if player.character_profile == "big_guy":
		player.anim.speed_scale = 2
	player._set_anim("spawn")
	pass

func exit():
	pass


func animation_finished(anim_name):
	if player.character_profile == "big_guy":
		player.anim.speed_scale = 1
	player.change_state("movement")
