extends Button


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	self.connect("button_up", self, "pressed")


func pressed():
	self.get_parent().hide()
	self.get_parent().hidden = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
