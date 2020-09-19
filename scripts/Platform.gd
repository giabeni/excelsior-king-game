extends KinematicBody

export var motion = Vector3(5,0,0)
export var cycle = 1.0
var accum = 0.0
var velocity = Vector3()
onready var initial_position = get_global_transform()[3]

func _physics_process(delta):
	#velocity = move_and_slide(velocity + motion * speed)
	var d = 0
	accum += delta * (1.0 / cycle) * PI * 2.0
	accum = fmod(accum, PI * 2.0)
	d = sin(accum)
	self.transform[3] = initial_position + (motion * d) 
