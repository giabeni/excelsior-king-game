extends Spatial

func _ready():
	yield(get_tree().create_timer(5), "timeout")
	get_node("IntroUI/Part1").hide()
	get_node("IntroUI/Part2").show()
	yield(get_tree().create_timer(5), "timeout")
	get_node("IntroUI").hide()
