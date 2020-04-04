extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_OptionsButton_pressed():
	$PauseMenu/CanvasLayer/Control.show_menu($"SpaceObjects/HopeShip/Positional Particles".process_material.color)


func _on_Control_apply_settings(ship_trail_color):
	$"SpaceObjects/HopeShip/Positional Particles".process_material.color = ship_trail_color
