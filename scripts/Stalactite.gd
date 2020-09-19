extends KinematicBody

onready var velocity = Vector3(0,0,0)
onready var falling = false
const gravity = -15

func _process(delta):
	if falling:
		velocity.y += delta * gravity
		velocity = move_and_slide(velocity, Vector3(0, 1, 0))
	if $RayCast.is_colliding():
		var thing = $RayCast.get_collider()
		if thing.is_in_group("Player"):
			$AnimationPlayer.play("shake")


func _on_Area_body_entered(body):
	if body.has_method("damage"):
		body.damage(1)


func _on_AnimationPlayer_animation_finished(anim_name):
	falling = true
