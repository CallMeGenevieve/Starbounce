extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var hidden = true

# Called when the node enters the scene tree for the first time.
func _ready():
	self.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		if self.hidden:
			var hope_ship = get_parent().get_node("SpaceObjects/HopeShip")
			self.position = hope_ship.position
			self.hidden = false
			get_tree().paused = true
			self.show()
		else:
			self.hide()
			get_tree().paused = false
			self.hidden = true
