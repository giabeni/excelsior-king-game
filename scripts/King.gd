extends KinematicBody

### GLOBAL CONSTANTS ###
const GRAVITY = -25
const SPEED = 12
const ACCELERATION = 5
const AIR_ACCEL_RES = 0.6
const DEACCELERATION = 8
const JUMP_IMPULSE = 16
const MAX_VERTICAL_VELOCITY = 50

### STATEFUL PROPERTIES ###
var velocity = Vector3()
var is_moving = false

### RELATED NODES ###
var king: KinematicBody
var camera
var anim_tree: AnimationTree
var anim_player: AnimationPlayer
var run_in_grass: AudioStreamPlayer
var land_in_grass: AudioStreamPlayer
var run_in_cave: AudioStreamPlayer
var land_in_cave: AudioStreamPlayer

### HEALTH VARIABLES ###
export (float) var max_health = 3
onready var health = max_health setget _set_health
onready var invulnerability_timer = $InvulnerabilityTimer
signal health_updated(health)
signal killed()

### SOUND VARIABLES ###
var running_in_grass = false
var running_in_cave = false

func _ready():
	anim_tree = get_node("AnimationTree")
	run_in_grass = get_node("Run_in_grass")
	run_in_cave = get_node("Run_in_cave")
	land_in_grass = get_node("Land_in_grass")
	king = get_node(".")

func _process(_delta):
	pass

func _physics_process(delta):
	camera = get_node("Target/Camera").get_global_transform()

	self._move_king(delta)
	self.play_running_sound()
	
	
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
	
	velocity.y += clamp(delta * GRAVITY, -MAX_VERTICAL_VELOCITY, MAX_VERTICAL_VELOCITY)

	var hv = velocity # horizontal velocity
	hv.y = 0
	var new_pos = dir * SPEED
	var accel_resistance = 1 if is_on_floor() else AIR_ACCEL_RES
	var accel = DEACCELERATION * accel_resistance
	
	
	if (dir.dot(hv) > 0):
		accel = ACCELERATION * accel_resistance
	
	hv = hv.linear_interpolate(new_pos, accel * delta)	
	
	velocity.x = hv.x
	velocity.z = hv.z
	
	if (Input.is_action_just_pressed("jump") and is_on_floor()):
		velocity.y = JUMP_IMPULSE
		anim_tree.set('parameters/jump/active', true)
		
	velocity = move_and_slide(velocity, Vector3(0,1,0))
	
	# check if player is falling to death
	_check_deadly_fall()
	
	if is_moving:
		_rotate_king(hv)
		
		
	
	var speed = hv.length() / SPEED
	anim_tree.set('parameters/idle-walk-run/blend_amount', speed)

func _rotate_king(hv):
	var angle = clamp(atan2(hv.x, hv.z), -2*PI, 2*PI)
	
	var char_rot = king.get_rotation()
	
	
	char_rot.y = angle
	king.rotation = lerp(king.get_rotation(), char_rot, 0.2)
	
func kill():
	anim_tree.set('parameters/die/blend_amount', 1)
	yield(get_tree().create_timer(2.292), "timeout")
	get_tree().change_scene("res://scenes/GameOver.tscn")
	

func _check_deadly_fall():
	if (velocity.y <= -0.5 * MAX_VERTICAL_VELOCITY):
		anim_tree.set('parameters/idle-walk-run/blend_amount', 0)

	if (velocity.y <= -MAX_VERTICAL_VELOCITY):
		kill()
		
	
func damage(amount):
	if invulnerability_timer.is_stopped():
		invulnerability_timer.start()
		_set_health(health - amount)
		blink()
		anim_tree.set('parameters/attacked/active', true)
	
func _set_health(value):
	var prev_health = health
	health = clamp(value, 0, max_health)
	if health != prev_health:
		emit_signal("health_updated", health)
		if health == 0:
			kill()
			emit_signal("killed")


func _on_animation_finished(anim_name):
	pass
	
func blink():
	var damage_material = load("res://models/King/SkinDamage.material")
	var safe_material = load("res://models/King/Skin.material")
	# Flicker 4 times
	for i in 5:
		$CharacterArmature/Skeleton/Body.set_surface_material(1, damage_material)
		yield(get_tree().create_timer(0.1), "timeout")
		$CharacterArmature/Skeleton/Body.set_surface_material(1, safe_material)
		yield(get_tree().create_timer(0.1), "timeout")


func play_running_sound():
	if is_on_floor() and is_moving:
		for i in get_slide_count():
			var collision = get_slide_collision(i)
			if collision.collider.name == "GridMap" and !running_in_grass:
				run_in_cave.stop()
				run_in_grass.play()
				running_in_grass = true
			elif collision.collider.name == "GridMap2" and !running_in_cave:
				run_in_grass.stop()
				run_in_cave.play()
				running_in_cave = true
	elif running_in_grass and !is_moving:
		running_in_grass = false
		run_in_grass.stop()
	elif running_in_cave and !is_moving:
		running_in_cave = false
		run_in_cave.stop()


func _on_Run_in_grass_finished():
	running_in_grass = false


func _on_Run_in_cave_finished():
	running_in_cave = false
