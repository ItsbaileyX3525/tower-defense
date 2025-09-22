extends Node2D

@onready var money_label: Label = $CanvasLayer/Control/Panel/Label
@onready var path_spawner: Node2D = $PathSpawner
@onready var timer: Timer = $PathSpawner/Timer

var on_wave: int = 1
var left_to_spawn: int = 5

func configure_wave() -> void:
	match on_wave: # IDC IF THIS LOOKS BAD I JUST NEED TO GET IT DONE!
		1:
			left_to_spawn = 5
			path_spawner.health_modifier = 1
		2:
			left_to_spawn = 7
			path_spawner.health_modifier = 1.2
		3:
			left_to_spawn = 9
			path_spawner.health_modifier = 1.5
		4:
			left_to_spawn = 10
			path_spawner.health_modifier = 1.8
		5:
			left_to_spawn = 12
			path_spawner.health_modifier = 2
		6:
			left_to_spawn = 14
			path_spawner.health_modifier = 2.2
		7:
			left_to_spawn = 16
			path_spawner.health_modifier = 2.5
		8:
			left_to_spawn = 18
			path_spawner.health_modifier = 2.8
		9:
			left_to_spawn = 19
			path_spawner.health_modifier = 3
		10:
			left_to_spawn = 20
			path_spawner.health_modifier = 3.2
		11:
			left_to_spawn = 22
			path_spawner.health_modifier = 3.5
		12:
			left_to_spawn = 25
			path_spawner.health_modifier = 5
	await get_tree().create_timer(4).timeout
	timer.start()


func _ready() -> void:
	configure_wave()


func _process(_delta: float) -> void:
	money_label.text = "Money: " + str(Game.money)

	if left_to_spawn <= 0:
		on_wave += 1
		timer.stop()
		configure_wave()
	
	$CanvasLayer/Control/Panel2/Label.text = "Health: " + str(Game.base_health)

func advance_wave() -> void:
	pass

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name.begins_with("Soldier"):
		body.call_deferred("queue_free")
		
		Game.base_health -= 10
		if Game.base_health <= 0:
			$CanvasLayer/Fail.visible = true


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Maps/Map1.tscn")
	Game.base_health = 100
	Game.money = 100
