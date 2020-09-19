extends Area
onready var global = get_node("/root/Global")

func _on_Bolt_body_entered(body):
	if "has_dash" in body:
		body.has_dash = true
		global.has_dash = true
		get_tree().get_root().get_node("Root/Level 1/PowerUpSound").play()
		get_tree().get_root().get_node("Root").power_up("Label2")
		self.queue_free()
