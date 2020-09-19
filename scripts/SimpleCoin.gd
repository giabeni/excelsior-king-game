extends Area
onready var global = get_node("/root/Global")

func _on_SimpleCoin_body_entered(body):
	if "has_double_jump" in body:
		body.has_double_jump = true
		global.has_double_jump = true
		get_tree().get_root().get_node("Root/Level 1/PowerUpSound").play()
		get_tree().get_root().get_node("Root").power_up("Label")
		self.queue_free()
