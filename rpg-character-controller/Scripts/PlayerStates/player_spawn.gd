extends PlayerState

func enter(player: Player):
	player.anim.current_animation = "med_anims/Spawn_Ground"
	pass

func exit(player: Player):
	pass


func animation_finished(player:Player, anim_name):
	player.changeState(player.StateName.MOVEMENT)
