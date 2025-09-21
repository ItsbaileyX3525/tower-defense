extends Panel

@onready var tower_scene = preload("res://Assets/Tower/GunT1.tscn")
var preview_tower: Node2D = null
var can_place: bool = false

func _on_gui_input(event: InputEvent) -> void:
	var obstacles = get_node("/root/Map1/TowerExclusion")
	var parent = get_parent().get_parent().get_parent().get_parent() #Talk about tunneling
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if preview_tower == null:
			preview_tower = tower_scene.instantiate()
			add_child(preview_tower)
			preview_tower.process_mode = Node.PROCESS_MODE_DISABLED

		_check_valid_placement(event.global_position, obstacles)
		
		if parent.expanded:
			parent.move()

	elif event is InputEventMouseMotion and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		if preview_tower:
			_check_valid_placement(event.global_position, obstacles)

	elif event is InputEventMouseButton and not event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if preview_tower:
			if can_place:
				print("Final placement valid, committing tower.")
				var path = get_node("/root/Map1/Towers")
				remove_child(preview_tower)
				path.add_child(preview_tower)
				preview_tower.global_position = event.global_position
				preview_tower.get_node("Area").hide()
				preview_tower.process_mode = Node.PROCESS_MODE_INHERIT
			else:
				print("Final placement invalid, discarding tower.")
				preview_tower.queue_free()

			preview_tower = null
			if not parent.expanded:
				parent.move()


	else:
		if preview_tower:
			print("Placement cancelled.")
			preview_tower.queue_free()
			preview_tower = null
			if not parent.expanded:
				parent.move()


func _check_valid_placement(pos: Vector2, obstacles: Node) -> void:
	var space = get_world_2d().direct_space_state
	var params = PhysicsPointQueryParameters2D.new()
	params.position = pos
	params.collide_with_bodies = true
	params.collide_with_areas = false

	var results = space.intersect_point(params, 32)
	can_place = true

	print("Mouse at:", pos, " | Hits:", results.size())

	for hit in results:
		print(" -> Hit:", hit.collider.name, " [", hit.collider.get_class(), "]")
		if obstacles.is_ancestor_of(hit.collider):
			print("    Blocked by:", hit.collider.name)
			can_place = false
			break

	if preview_tower:
		preview_tower.global_position = pos
		if can_place:
			preview_tower.modulate = Color(1, 1, 1, 0.8) # white = valid
			print("Placement VALID at", pos)
		else:
			preview_tower.modulate = Color(1, 0, 0, 0.8) # red = invalid
			print("Placement INVALID at", pos)
