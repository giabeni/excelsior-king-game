extends Area


func _on_SimpleCoin_body_entered(body):
	if "has_double_jump" in body:
		body.has_double_jump = true
		get_tree().get_root().get_node("Root/Level 1/PowerUpSound").play()
		self.queue_free()
