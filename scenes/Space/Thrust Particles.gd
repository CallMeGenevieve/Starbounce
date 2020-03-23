extends CPUParticles2D

export var base_speed = 75


func _ready():
	pass # Replace with function body.

func set_particle_speed(object_speed, direction):
	self.initial_velocity = direction * self.base_speed + direction * object_speed 

#func _process(delta):
#	pass
