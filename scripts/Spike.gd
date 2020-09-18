extends Area


func _on_Spike_body_entered(body):
	if body.has_method("damage"):
		body.damage(1)
