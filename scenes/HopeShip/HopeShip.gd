extends Area2D


export var thrust_power = 0.25

export var mass = 10000

export var speed = Vector2(0, 0)
export var acceleration = Vector2(0, 0)
export var thrust = Vector2(0, -1)
export var angle_speed = 0
export var direction = 0

export var stay_in_place = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


func apply_acceleration(delta):
	self.rotation += self.angle_speed * delta
	
	if self.angle_speed != 0:
		self.thrust.x = sin(self.rotation) * self.thrust_power
		self.thrust.y = -cos(self.rotation) * self.thrust_power
	
	self.speed += delta * self.acceleration + self.thrust * self.direction


func apply_speed(delta):
	self.position += delta * self.speed

func apply_tick(delta):
	apply_acceleration(delta)
	apply_speed(delta)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("accelerate_ship") and not Input.is_action_pressed("break_ship"):
		if self.direction != 1:
			self.direction = 1
	elif Input.is_action_pressed("break_ship") and not Input.is_action_pressed("accelerate_ship"):
		self.direction = -1
	else:
		self.direction = 0
	if Input.is_action_pressed("turn_ship_right"):
		if self.angle_speed < 6:
			self.angle_speed += delta * 2
		elif self.angle_speed != 6:
			self.angle_speed = 6
	if Input.is_action_pressed("turn_ship_left"):
		if self.angle_speed > -6:
			self.angle_speed -= delta * 2
		elif self.angle_speed != -6:
			self.angle_speed = -6


func _on_HopeShip_area_entered(area):
	get_tree().change_scene("res://scenes/MainMenu/MainMenu.tscn")
