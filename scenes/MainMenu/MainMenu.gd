extends Node2D


# Declare member variables here. Examples:
# var a = 2
var window_size = Vector2()


# Called when the node enters the scene tree for the first time.
func _ready():
	self.window_size = Vector2(ProjectSettings.get_setting("display/window/size/width"), ProjectSettings.get_setting("display/window/size/height"))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("toggle_fullscreen"):
		OS.window_fullscreen = !OS.window_fullscreen
