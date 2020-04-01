extends Area2D


# Declare member variables here. Examples:
export var identifyer = "SpaceObject"
export var mass = 10000
export var acceleration = Vector2()
export var speed = Vector2()

# if true, this SpaceObject will not be influenced by gravity
export var stay_in_place = false
export var crashed = false

var index

signal crashing(index)


func apply_acceleration(delta):
	self.speed += delta * self.acceleration


func apply_speed(delta):
	self.position += delta * self.speed


func apply_tick(delta):
	apply_acceleration(delta)
	apply_speed(delta)
	
	# I know this code is duplicate but idk what a better solution would be.
	# Is there a possibility of importing functions here?!
	if $Camera2D.current:
		if not $Camera2D.show_ui:
			$Camera2D/UI.get_child(0).show()
			$Camera2D.show_ui = true
		$Camera2D/UI/UIBox/VBoxContainer/Mass.text = "Mass: " + str(self.mass)
		$Camera2D/UI/UIBox/VBoxContainer/PosX.text = "PosX: " + str(self.position.x)
		$Camera2D/UI/UIBox/VBoxContainer/PosY.text = "PosY: " + str(self.position.y)
		$Camera2D/UI/UIBox/VBoxContainer/Speed.text = "Speed: " + str(self.speed.length())
		$Camera2D/UI/UIBox/VBoxContainer/SpeedAxis.text = "SpeedX: " + str(self.speed.x) + " SpeedY: " + str(self.speed.y)
		$Camera2D/UI/UIBox/VBoxContainer/Acceleration.text = "Acceleration: " + str(self.acceleration.length())
		$Camera2D/UI/UIBox/VBoxContainer/AccAxis.text = "AccelX: " + str(self.acceleration.x) + " AccelY: " + str(self.acceleration.y)

	elif $Camera2D.show_ui:
		$Camera2D/UI.get_child(0).hide()
		$Camera2D.show_ui = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func crash(object1, object2):
	if object1.identifyer != "HopeShip" and not object1.crashed:
		if object2.identifyer != "HopeShip" and not object2.crashed:
			if not object1.stay_in_place:
				object1.speed = (object1.speed * object1.mass + object2.speed * object2.mass) / (object1.mass + object2.mass)
				object1.position = (object1.position * object1.mass + object2.position * object2.mass) / (object1.mass + object2.mass)
			object1.mass += object2.mass
			object2.crashed = true
			get_parent().remove_child(object2)
			emit_signal("crashing", self.index)


func _on_SpaceObject_area_entered(area):
	if self.stay_in_place:
		crash(self, area)
	else:
		if self.mass > area.mass:
			crash(self, area)
		else:
			crash(area, self)
