extends KinematicBody

const ACCEL = 0.5

var player = null
var speed = 8
var once = 0
var bat_velocity = Vector3.ZERO
var bat_position = Vector3()
var player_position = Vector3()
var timer: Timer
var bat: KinematicBody
var anim: AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	timer = get_node("Timer")
	anim = get_node("AnimationPlayer")
	bat = get_node(".")
	bat_position = bat.global_transform.origin
	set_process(false)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player and !once:
		once = 1
		bat_velocity = bat_position.direction_to(player_position) * speed
		
		print ('BAT ID', bat.name)
		timer.start()
		var rotation = (bat_position * Vector3(1,0,1)).angle_to(player_position * Vector3(1,0,1))
		rotate_y(rotation + PI / 2)
		rotate_x(PI / 2 + 1)
		anim.play("Bat_Flying")
		bat_velocity = move_and_slide(bat_velocity, Vector3.UP, false, 1600, deg2rad(80))
	elif (player and once):
		bat_velocity = bat_velocity * (1 + ACCEL * delta)
		print ("BAT POS", bat.global_transform.origin)
		print ("BAT SPEED", speed)
		print ("BAT VEL", bat_velocity)
		bat_velocity = move_and_slide(bat_velocity, Vector3.UP, false, 1600, deg2rad(80))


func _on_Area_body_entered(body):
	if body.is_in_group("Player"):
		print("\n\nPLAYER HAS BEEN SEEN BY BAT!!!\n")
		yield(get_tree().create_timer(1), "timeout")
		anim.play("Bat_Attack")		
		yield(get_tree().create_timer(2), "timeout")
		print("Bat is about to fly\n")
		player = body
		player_position = body.global_transform.origin


func _on_Timer_timeout():
	bat_velocity = bat_velocity * 2
	timer.start()
	queue_free()


func _on_damage_body_entered(body):
	if body.has_method("damage"):
		body.damage(1)


func _on_VisibilityNotifier_camera_entered(camera):
	set_process(true)
