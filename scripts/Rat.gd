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

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var movement = direction * speed
	var velocity = movement * (1 + ACCEL * delta)
	velocity.y += clamp(delta * GRAVITY, -MAX_VERTICAL_VELOCITY, MAX_VERTICAL_VELOCITY)
	move_and_slide(velocity, Vector3.UP, false, 1600, deg2rad(80))
	anim.play("Rat_Walk")
	
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
	if random_number < 0.1:
		direction = Vector3.FORWARD.rotated(Vector3.UP, rng.randf() * 2 * PI)
		_rotate_rat(direction)
	#elif random_number < 0.05:
	#	direction = Vector3.ZERO
