extends Camera

# class member variables go here:
export var distance = 8.0
export var height = 4.0
var smooth_pos_speed = 10
var smooth_rot_speed = 6
var smooth_camera_pos = Vector3()
var smooth_camera_rot = Vector3()

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	set_as_toplevel(true)

func _physics_process(delta):
	var target = get_parent().get_global_transform().origin
	var pos = get_global_transform().origin
	var up = Vector3(0,1,0)
	
	var offset = pos - target
	
	offset = offset.normalized()*distance
	offset.y = height
	
	pos = target + offset
	
	smooth_camera_pos = smooth_camera_pos.linear_interpolate(pos, smooth_pos_speed * delta)
	smooth_camera_rot = smooth_camera_rot.linear_interpolate(target, smooth_rot_speed * delta)
	
	look_at_from_position(smooth_camera_pos, smooth_camera_rot, up)
