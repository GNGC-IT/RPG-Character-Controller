extends PlayerState

func enter():
	player._set_anim("hit")
	player.velocity = Vector3.ZERO
	pass


func animation_finished(anim_name):
	player.change_state("movement")
