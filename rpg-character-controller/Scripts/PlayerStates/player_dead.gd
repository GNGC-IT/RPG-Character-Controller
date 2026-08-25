extends PlayerState

func enter():
	player._set_anim("death")
	player.velocity = Vector3.ZERO
	pass

func exit():
	pass

func physics_process(delta):
	pass
