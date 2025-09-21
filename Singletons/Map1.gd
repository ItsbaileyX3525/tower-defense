extends Node2D

@onready var money_label: Label = $CanvasLayer/Control/Panel/Label

func _process(_delta: float) -> void:
	money_label.text = "Money: " + str(Game.money)
