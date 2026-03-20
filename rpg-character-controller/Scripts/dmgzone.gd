extends Area3D

var dmg = 1


func _on_body_entered(body):
	if body is Player:
		body._take_damage(dmg)
