extends Area


func _on_Bolt_body_entered(body):
	if "has_dash" in body:
		body.has_dash = true
		get_tree().get_root().get_node("Root/Level 1/PowerUpSound").play()
		self.queue_free()
