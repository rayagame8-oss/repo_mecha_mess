extends Area2D

func _on_body_entered(body):
	if body.name == "BluePlayer":
		var gm = get_tree().get_first_node_in_group("game_manager")
		if gm:
			gm.set_checkpoint(global_position)
