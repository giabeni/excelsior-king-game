extends Area


func _on_Stalactite_body_entered(body):
	if body.has_method("damage"):
		body.damage(1)
