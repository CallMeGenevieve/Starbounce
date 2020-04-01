extends Camera2D

export (bool) var show_ui = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("zoom_out"):
		if self.zoom.x < 16:
			self.zoom.x *= 2
			self.zoom.y *= 2
	elif Input.is_action_just_pressed("zoom_in"):
		if self.zoom.x > 0.125:
			self.zoom.x /= 2
			self.zoom.y /= 2
