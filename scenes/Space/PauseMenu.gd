extends CanvasLayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var hidden = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		if self.hidden:
			self.hidden = false
			get_tree().paused = true
			$PauseMenuBackground.show()
			$VBoxContainer.show()
		else:
			$PauseMenuBackground.hide()
			$VBoxContainer.hide()
			get_tree().paused = false
			self.hidden = true
	elif Input.is_action_just_pressed("toggle_fullscreen"):
		OS.window_fullscreen = !OS.window_fullscreen
	elif Input.is_action_just_pressed("take_screenshot"):
		var image = get_viewport().get_texture().get_data()
		image.flip_y()
		image.save_png("screenshot.png")
