extends Control

onready var health = $Health

func _on_health_updated(health, amount)
	health. = health


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
