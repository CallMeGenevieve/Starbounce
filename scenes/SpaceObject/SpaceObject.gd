extends Area2D


# Declare member variables here. Examples:
export var mass = 10000
export var acceleration = Vector2()
export var speed = Vector2()

# if true, this SpaceObject will not be influenced by gravity
export var stay_in_place = false

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


func _on_SpaceObject_area_entered(area):
	self.mass += area.mass
