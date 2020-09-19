extends Area


func _on_SimpleCoin_body_entered(body):
	if "has_double_jump" in body:
		body.has_double_jump = true
		self.queue_free()
