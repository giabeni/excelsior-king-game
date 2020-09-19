extends Area
onready var global = get_node("/root/Global")

func _on_Star_body_entered(body):
	if "has_super_jump" in body:
		body.has_super_jump = true
		global.has_super_jump = true
		self.queue_free()
