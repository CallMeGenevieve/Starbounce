extends Button


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	grab_focus()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_BackToGame_pressed():
	for element in self.get_parent().get_parent().get_children():
		element.hide()
	
	get_parent().get_parent().hidden = true
	get_tree().paused = false
