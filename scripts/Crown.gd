extends Area


func _on_Crown_body_entered(body):
	if body.has_method("win"):
		body.win()
		self.queue_free()
