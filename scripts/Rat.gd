extends KinematicBody


var rng = RandomNumberGenerator.new()

var player = null
var speed = 20
var once = 0
var rat_velocity = Vector3.ZERO
var rat_position = Vector3()
var final_position = Vector3()
var timer: Timer
var rat: KinematicBody
var anim_tree: AnimationTree
var is_walking = false
var direction = Vector3()

# Called when the node enters the scene tree for the first time.
func _ready():
	timer = get_node("Timer")
	anim_tree = get_node("AnimationTree")
	rat = get_node(".")
	rat_position = rat.global_transform.origin
	rng.randomize()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var movement = direction * speed
	move_and_slide(movement)
	anim_tree.set('parameters/idle-walk-run/blend_amount', movement)

func _on_Damage_body_entered(body):
	if body.has_method("damage"):
		body.damage(1)

func _on_Timer_timeout():
	var random_number = rng.randf()
	if random_number < 0.05:
		direction = Vector3.ZERO
	elif random_number < 0.1:
		direction = Vector3.DOWN.rotated(Vector3(0, 1, 0), rng.randf() * 2 * PI)
