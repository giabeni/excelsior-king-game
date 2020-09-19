extends KinematicBody

const ACCEL = 1

var player = null
var speed = 25
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

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if player and !once:
		once = 1
		bat_velocity = bat_position.direction_to(player_position) * speed
		
		print ("BAT POS", bat.global_transform.origin)
		speed = speed + (ACCEL * delta)
		print ("BAT SPEED", speed)
		print ("BAT VEL", bat_velocity)
		timer.start()
		var rotation = (bat_position * Vector3(1,0,1)).angle_to(player_position * Vector3(1,0,1))
		rotate_y(rotation + PI / 2)
		rotate_x(PI / 2 + 1)
		anim.play("Bat_Flying")
	move_and_slide(bat_velocity)


func _on_Area_body_entered(body):
	if body.is_in_group("Player"):
		print("\n\nPLAYER HAS BEEN SEEN BY BAT!!!\n\n")
		player = body
		player_position = body.global_transform.origin


func _on_Timer_timeout():
	bat_velocity = bat_velocity * 2
	timer.start()
	queue_free()


func _on_damage_body_entered(body):
	if body.has_method("damage"):
		body.damage(1)
