extends Area


func _on_Star_body_entered(body):
	if "has_super_jump" in body:
		body.has_super_jump = true
		get_tree().get_root().get_node("Root/Level 1/PowerUpSound").play()
		self.queue_free()
