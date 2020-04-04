extends Node2D


export var gravitational_constant = 6.6743
export var game_speed = 1
export (bool) var simulation_paused = false
var edit_mode = 0
var all_space_objects
var amount_of_space_objects
var active_camera_index = 0

signal speed_change(new_speed)


func _ready():
	emit_signal("speed_change", self.game_speed)
	self.get_space_objects()

func get_space_objects():
	self.all_space_objects = self.get_children()
	self.amount_of_space_objects = len(all_space_objects)


func calculate_acceleration_from_force(space_object_1, space_object_2):
	var distance: Vector2 = space_object_1.position - space_object_2.position
	
	var direction: Vector2 = Vector2(distance.x / distance.length(), distance.y / distance.length())
	
	var force_1: float = self.gravitational_constant * space_object_1.mass / (pow(distance.length(), 2))
	var force_2: float = self.gravitational_constant * space_object_2.mass / (pow(distance.length(), 2))
	
	var force_vector_1: Vector2 = direction * force_1
	var force_vector_2: Vector2 = direction * force_2
	
	return [force_vector_1, force_vector_2]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	self.get_space_objects()
	
	if Input.is_action_just_pressed("increase_game_speed"):
		self.game_speed *= 2
		apply_simulation_speed_on_particles()
		emit_signal("speed_change", self.game_speed)
	elif Input.is_action_just_pressed("decrease_game_speed"):
		if self.game_speed > 1:
			self.game_speed /= 2
			apply_simulation_speed_on_particles()
			emit_signal("speed_change", self.game_speed)
	elif Input.is_action_just_pressed("switch_focus"):
		self.active_camera_index += 1
		manage_camera()
		if self.edit_mode == 2:
			get_parent().get_node("PauseMenu/CanvasLayer/UI").current_space_object = self.all_space_objects[self.active_camera_index]
			get_parent().get_node("PauseMenu/CanvasLayer/UI").init_editor(
			self.all_space_objects[self.active_camera_index].mass,
			self.all_space_objects[self.active_camera_index].scale.x,
			self.all_space_objects[self.active_camera_index].get_node("Positional Particles").process_material.color,
			self.all_space_objects[self.active_camera_index].stay_in_place,
			self.all_space_objects[self.active_camera_index].position,
			self.all_space_objects[self.active_camera_index].speed
		)
	elif Input.is_action_just_pressed("pause_simulation") and self.edit_mode == 0:
		self.simulation_paused = !self.simulation_paused
		apply_simulation_speed_on_particles()

	if not self.simulation_paused:
		for blah in range(self.game_speed):
			var index = 0
			for space_object in all_space_objects:
				space_object.acceleration *= 0
				space_object.index = index
				index += 1
		
			for i in range(len(all_space_objects)):
				var space_object_1 = all_space_objects[i]
			
				for j in range(i + 1, len(all_space_objects)):
					var space_object_2 = all_space_objects[j]
					var forces = calculate_acceleration_from_force(space_object_1, space_object_2)
				
					if not space_object_1.stay_in_place:
						space_object_1.acceleration -= forces[1]
					if not space_object_2.stay_in_place:
						space_object_2.acceleration += forces[0]
			
				space_object_1.apply_tick(delta)


func manage_camera():
	if self.active_camera_index >= self.amount_of_space_objects:
		self.reset_camera_on_hopeship()
	else:
		self.all_space_objects[self.active_camera_index].get_node("Camera2D").current = true


func reset_camera_on_hopeship():
	self.get_node("HopeShip/Camera2D").current = true
	self.active_camera_index = 0


func create_space_object():
	var scene_instance = load("res://scenes/SpaceObject/SpaceObject.tscn").instance()
	scene_instance.set_name("scene")
	add_child(scene_instance)
	scene_instance.get_node("Camera2D").current = true
	scene_instance.index = len(get_children()) - 1
	self.amount_of_space_objects += 1
	self.active_camera_index = len(get_children()) - 1
	return scene_instance


func apply_simulation_speed_on_particles():
	self.get_space_objects()
	for space_object in self.all_space_objects:
		space_object.change_particle_tick(self.game_speed, self.simulation_paused)
