extends Button


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var button_selected = false
export var button_blocked = .2

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func select_button():
	self.button_selected = true
	self.button_blocked = .2
	self.grab_focus()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if self.button_selected and self.button_blocked <= 0:
		if Input.is_action_pressed("ui_down"):
			self.button_selected = false
			get_parent().get_node("StartSpace").select_button()
		elif Input.is_action_pressed("ui_up"):
			self.button_selected = false
			get_parent().get_node("StartPlanet").select_button()
	elif self.button_blocked > 0:
		self.button_blocked -= delta


func _on_ExitGame_pressed():
	get_tree().quit(0)
