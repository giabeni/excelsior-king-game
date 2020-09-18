extends KinematicBody

### GLOBAL CONSTANTS ###
const GRAVITY = -9.8
const SPEED = 6
const ACCELERATION = 3
const DEACCELERATION = 5

### STATEFUL PROPERTIES ###
var velocity = Vector3()
var is_moving = false

### RELATED NODES ###
var king: KinematicBody
var camera
var anim_tree: AnimationTree
var anim_player: AnimationPlayer

### HEALTH VARIABLES ###
export (float) var max_health = 3
onready var health = max_health setget _set_health
onready var invulnerability_timer = $InvulnerabilityTimer
signal health_updated(health)
signal killed()

func _ready():
	anim_tree = get_node("AnimationTree")
	king = get_node(".")

func _process(_delta):
	pass

func _physics_process(delta):
	camera = get_node("Target/Camera").get_global_transform()

	self._move_king(delta)
	
	
func _move_king(delta):
	
	var dir = Vector3()

	is_moving = false

	if(Input.is_action_pressed("move_fw")):
		dir += -camera.basis[2]
		is_moving = true
	
	if(Input.is_action_pressed("move_bw")):
		dir += camera.basis[2]
		is_moving = true
	
	if(Input.is_action_pressed("move_l")):
		dir += -camera.basis[0]
		is_moving = true
	
	if(Input.is_action_pressed("move_r")):
		dir += camera.basis[0]
		is_moving = true
	
	dir.y = 0	
	dir = dir.normalized()
	
	velocity.y += delta * GRAVITY

	var hv = velocity # horizontal velocity
	hv.y = 0
	var new_pos = dir * SPEED
	var accel = DEACCELERATION
	
	
	if (dir.dot(hv) > 0):\
		accel = ACCELERATION
	
	hv = hv.linear_interpolate(new_pos, accel * delta)	
	
	velocity.x = hv.x
	velocity.z = hv.z
		
	velocity = move_and_slide(velocity, Vector3(0,1,0))
	
	if is_moving:
		
		# Rotate the character
		var angle = atan2(hv.x, hv.z)
		
		var char_rot = king.get_rotation()
		
		char_rot.y = angle
		king.rotation = char_rot
		
	
	var speed = hv.length() / SPEED
	anim_tree.set('parameters/idle-walk-run/blend_amount', speed)
	
func damage(amount):
	if invulnerability_timer.is_stopped():
		invulnerability_timer.start()
		_set_health(health - amount)
		#anim_tree.play('parameters/idle-walk-run/blend_amount')
	
func kill():
	pass

func _set_health(value):
	var prev_health = health
	health = clamp(value, 0, max_health)
	if health != prev_health:
		emit_signal("health_updated", health)
		if health == 0:
			kill()
			emit_signal("killed")
