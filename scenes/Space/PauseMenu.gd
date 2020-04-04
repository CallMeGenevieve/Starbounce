extends CanvasLayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var hidden = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		if self.hidden:
			$UI._on_AccessPauseMenuButton_pressed()
		else:
			$VBoxContainer/BackToGame._on_BackToGame_pressed()
	elif Input.is_action_just_pressed("toggle_fullscreen"):
		OS.window_fullscreen = !OS.window_fullscreen
	elif Input.is_action_just_pressed("take_screenshot"):
		var image = get_viewport().get_texture().get_data()
		image.flip_y()
		image.save_png("screenshot.png")
