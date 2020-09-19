extends KinematicBody

func _on_Area_body_entered(body):
	if body.is_in_group("Player"):
		$FallTimer.start()
		$AudioStreamPlayer.play()

func _on_RespawnTimer_timeout():
	self.show()
	$CollisionShape.disabled = false

func _on_FallTimer_timeout():
	self.hide()
	$CollisionShape.disabled = true
	$RespawnTimer.start()
