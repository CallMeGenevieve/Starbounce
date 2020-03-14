extends KinematicBody2D


export var thrust_power = 1

export var speed = Vector2(0, 0)
export var acceleration = Vector2(0, 0)
export var thrust = Vector2(0, -1)
export var angle_speed = 0
export var direction = 0

var thrust_particles = null

# Called when the node enters the scene tree for the first time.
func _ready():
	self.thrust_particles = get_parent().get_node("HopeShip/Thrust Particles")


func apply_acceleration(delta):
	self.rotation += self.angle_speed * delta
	
	if self.angle_speed != 0:
		self.thrust.x = sin(self.rotation) * self.thrust_power
		self.thrust.y = -cos(self.rotation) * self.thrust_power
	
	self.speed += delta * self.acceleration + self.thrust * self.direction


func apply_speed(delta):
	self.position += delta * self.speed


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("accelerate_ship") and not Input.is_action_pressed("break_ship"):
		self.direction = 1
		self.thrust_particles.emitting = true
	elif Input.is_action_pressed("break_ship") and not Input.is_action_pressed("accelerate_ship"):
		self.direction = -1
		self.thrust_particles.emitting = true
	else:
		self.direction = 0
		self.thrust_particles.emitting = false
	if Input.is_action_pressed("turn_ship_right"):
		self.angle_speed += delta * 2
	if Input.is_action_pressed("turn_ship_left"):
		self.angle_speed -= delta * 2
	
	apply_acceleration(delta)
	apply_speed(delta)

