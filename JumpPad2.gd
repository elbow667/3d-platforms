extends Area


func _on_JumpPad_body_entered(body):
	print("bounce")
	if body.has_method("bounce"):
		body.bounce()
