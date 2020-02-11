extends Button


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	self.grab_focus()

#func pressed():
	#get_tree().change_scene("res://scenes/Space/Space.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_StartSpace_pressed():
	get_tree().change_scene("res://scenes/Space/Space.tscn")
