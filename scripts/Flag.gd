extends Area

onready var global = get_node("/root/Global")
var activated = false

func _on_Flag_body_entered(body):
	if body.name == 'King' and !activated:
		global.spawn_point = self.get_translation()
		var check_material = load("res://models/Flag/Blue.material")
		$StaticBody/CollisionShape/Flag.set_surface_material(1, check_material)
		activated = true
