extends Control

onready var label = get_node("Label")

func _on_King_health_updated(health):
	label.set_text(str(health))


# Called when the node enters the scene tree for the first time.
func _ready():
	label.set_text(str(3))
	pass # Replace with function body.