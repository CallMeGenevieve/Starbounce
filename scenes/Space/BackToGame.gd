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
	get_parent().get_parent().get_node("VBoxContainer").hide()
	get_parent().get_parent().get_node("PauseMenuBackground").hide()
	
	get_parent().get_parent().hidden = true
	get_tree().paused = false
