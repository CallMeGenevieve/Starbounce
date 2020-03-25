extends Area2D


# Declare member variables here. Examples:
export var identifyer = "SpaceObject"
export var mass = 10000
export var acceleration = Vector2()
export var speed = Vector2()

# if true, this SpaceObject will not be influenced by gravity
export var stay_in_place = false
export var crashed = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func apply_acceleration(delta):
	self.speed += delta * self.acceleration


func apply_speed(delta):
	self.position += delta * self.speed


func apply_tick(delta):
	apply_acceleration(delta)
	apply_speed(delta)


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


func _on_SpaceObject_area_entered(area):
	if self.stay_in_place:
		crash(self, area)
	else:
		if self.mass > area.mass:
			crash(self, area)
		else:
			crash(area, self)
