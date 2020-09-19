extends KinematicBody

const GRAVITY = -26
const ACCEL = 0.2
const MAX_VERTICAL_VELOCITY = 50

var rng = RandomNumberGenerator.new()
var speed = 1.1
var timer: Timer
var rat: KinematicBody
var anim: AnimationPlayer
var anim_tree: AnimationTree
var direction = Vector3()

# Called when the node enters the scene tree for the first time.
func _ready():
	timer = get_node("Timer")
	anim = get_node("AnimationPlayer")
	anim_tree = get_node("AnimationTree")
	rat = get_node(".")
	rng.randomize()
	direction = -Vector3.FORWARD
	set_process(false)

var velocity = Vector3()
onready var previous_position = get_global_transform()[3]

func _process(delta):
	if $RayCast.is_colliding():
		var body = $RayCast.get_collider()
		if not body.is_in_group("Player"):
			direction = -Vector3.FORWARD
			_rotate_rat(direction)
	else:
		self.transform[3] = previous_position + (direction * speed * delta)
		previous_position = self.transform[3]
		anim.play("Rat_Walk")
		_check_deadly_fall(velocity)

func _rotate_rat(direction):
	var angle = clamp(atan2(direction.x, direction.z), -2*PI, 2*PI)

	var char_rot = rat.get_rotation()

	var from_rot = char_rot.y
	var to_rot = angle
	var new_rot = lerp_angle(from_rot, to_rot, 0.2)

	char_rot.y = angle
	rat.rotation = char_rot

func _on_Damage_body_entered(body):
	if body.has_method("damage"):
		body.damage(1)

func _on_Timer_timeout():
	var random_number = rng.randf()
	set_process(true)
	if random_number < 0.1:
		direction = Vector3.FORWARD.rotated(Vector3.UP, rng.randf() * 2 * PI)
		_rotate_rat(direction)
	
func _check_deadly_fall(velocity):
	if (velocity.y <= -MAX_VERTICAL_VELOCITY):
		self.queue_free()


func _on_VisibilityNotifier_camera_entered(camera):
	set_process(true)
