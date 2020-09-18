extends Control

onready var label = get_node("Label")

onready var heart1 = get_node("heart1")
onready var heart2 = get_node("heart2")
onready var heart3 = get_node("heart3")

func _on_King_health_updated(health):
	print ("DAMAGED", health)
	if (health == 0):
		heart1.visible = false
	
	if (health == 1):
		heart2.visible = false
		
	if (health == 2):
		heart3.visible = false


# Called when the node enters the scene tree for the first time.
func _ready():
	label.set_text(str(3))
	pass # Replace with function body.
