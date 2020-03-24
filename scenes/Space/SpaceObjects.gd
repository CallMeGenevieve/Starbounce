extends Node2D


export var gravitational_constant = 6.6743


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


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
	var all_space_objects = self.get_children()
	
	for space_object in all_space_objects:
		space_object.acceleration *= 0
	
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
