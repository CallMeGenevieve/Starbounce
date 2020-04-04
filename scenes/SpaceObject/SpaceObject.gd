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
var ui_node
var positional_particles

signal crashing(index)


func _ready():
	$"Positional Particles".process_material = ($"Positional Particles".process_material.duplicate())
	self.ui_node = get_parent().get_parent().get_node("PauseMenu/CanvasLayer/UI/VBoxContainer")
	self.positional_particles = $"Positional Particles"


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
		ui_node.get_node("Mass").text = "Mass: " + str(self.mass)
		ui_node.get_node("PosX").text = "PosX: " + str(self.position.x)
		ui_node.get_node("PosY").text = "PosY: " + str(self.position.y)
		ui_node.get_node("Speed").text = "Speed: " + str(self.speed.length())
		ui_node.get_node("SpeedAxis").text = "SpeedX: " + str(self.speed.x) + " SpeedY: " + str(self.speed.y)
		ui_node.get_node("Acceleration").text = "Acceleration: " + str(self.acceleration.length())
		ui_node.get_node("AccAxis").text = "AccelX: " + str(self.acceleration.x) + " AccelY: " + str(self.acceleration.y)


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
			self.remove_space_object(object2)


func remove_space_object(object):
	print(str(object.index) + " " + str(get_parent().active_camera_index))
	
	if object.index == get_parent().active_camera_index:
		get_parent().active_camera_index -= 1
		get_parent().manage_camera()
	elif object.index < get_parent().active_camera_index:
		get_parent().active_camera_index -= 1
#		get_parent().manage_camera()
	get_parent().remove_child(object)
	


func _on_SpaceObject_area_entered(area):
	if get_parent().edit_mode == 0:
		if self.stay_in_place:
			crash(self, area)
		else:
			if self.mass > area.mass:
				crash(self, area)
			else:
				crash(area, self)


func set_trail_colour(colour):
	$"Positional Particles".process_material.color = colour


func change_particle_tick(game_speed, simulation_paused):
	if simulation_paused:
		$"Positional Particles".speed_scale = 0
	else:
		$"Positional Particles".speed_scale = game_speed
