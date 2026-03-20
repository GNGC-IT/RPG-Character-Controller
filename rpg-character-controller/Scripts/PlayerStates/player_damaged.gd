extends PlayerState

func enter(player: Player):
	player.anim.current_animation = "med_anims/Hit_B"
	player.velocity = Vector3.ZERO
	pass


func animation_finished(player:Player, anim_name):
	player.changeState(player.StateName.MOVEMENT)
