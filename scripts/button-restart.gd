extends Button

var label4: Label
var label5: Label
var label6: Label
var label7: Label

func _ready():
	pass

func _on_button_restart_pressed():
	get_tree().change_scene("res://scenes/Root.tscn")
