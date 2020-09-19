extends Control

var label4: Label
var label5: Label
var label6: Label
var label7: Label

func _ready():
	label4 = get_node("Giovanni")
	label5 = get_node("Nathy")
	label6 = get_node("Helder")
	label7 = get_node("Nai")


func _on_buttoncredits_pressed():
	label4.visible = !label4.visible
	label5.visible = !label5.visible
	label6.visible = !label6.visible
	label7.visible = !label7.visible


func _on_buttonstart_pressed():
	get_tree().change_scene("res://scenes/Root.tscn")
