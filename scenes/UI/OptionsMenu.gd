extends Control

export (bool) var hidden = true
var new_color = null
var fullscreen_mode = false

signal apply_settings(ship_trail_color)

# Called when the node enters the scene tree for the first time.
func _ready():
	self.hide()


func show_menu(ship_color):
	self.new_color = ship_color
	self.fullscreen_mode = OS.window_fullscreen
	$VBoxContainer/CheckBox.pressed = fullscreen_mode
	$VBoxContainer/HBoxContainer/ColorPickerButton.color = ship_color
	self.hidden = false
	self.show()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not hidden:
		if Input.is_action_just_pressed("ui_cancel"):
			self.hide()
			self.hidden = true


func _on_ColorPickerButton_color_changed(color):
	self.new_color = color


func _on_CheckBox_toggled(button_pressed):
	self.fullscreen_mode = button_pressed


func _on_Cancel_pressed():
	self.hide()


func _on_ApplyButton_pressed():
	OS.window_fullscreen = self.fullscreen_mode
	emit_signal("apply_settings", self.new_color)
	_on_Cancel_pressed()
