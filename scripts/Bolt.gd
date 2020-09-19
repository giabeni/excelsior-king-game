extends Area


func _on_Bolt_body_entered(body):
	if "has_dash" in body:
		body.has_dash = true
		self.queue_free()
