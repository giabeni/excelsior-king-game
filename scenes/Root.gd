extends Spatial

onready var global = get_node("/root/Global")

func _ready():
	if not global.played_intro:
		yield(get_tree().create_timer(5), "timeout")
		get_node("IntroUI/Part1").hide()
		get_node("IntroUI/Part2").show()
		yield(get_tree().create_timer(5), "timeout")
		get_node("IntroUI/Part2").hide()
		get_node("IntroUI/Part3").show()
		global.played_intro = true
		yield(get_tree().create_timer(5), "timeout")
		get_node("IntroUI").hide()
	else:
		get_node("IntroUI").hide()
