extends Area2D


export var identifyer = "HopeShip"
export var thrust_power = 25

export var mass = 1

export var speed = Vector2(0, 0)
export var acceleration = Vector2(0, 0)
export var thrust = Vector2(0, -1)
export var angle_speed = 0  # the speed at which the ship rotates every frame
export var direction = 0  # indicates forward/backward/no acceleration from thrusters (1, -1, 0)

export var stay_in_place = false

var index = 0
var ui_node
var positional_particles
var crashed = false


func _ready():
	self.ui_node = get_parent().get_parent().get_node("PauseMenu/CanvasLayer/UI/VBoxContainer")
	self.positional_particles = $"Positional Particles"


func apply_acceleration(delta):
	get_node("Sprite").rotation += self.angle_speed * delta
	#get_node("Positional Particles").rotation += self.angle_speed * delta
	get_node("CollisionShape2D").rotation += self.angle_speed * delta
	
	if self.direction != 0:
		if not $"Thruster Particles".emitting:
			$"Thruster Particles".emitting = true
		var dir_x = sin(get_node("Sprite").rotation)
		var dir_y = -cos(get_node("Sprite").rotation)
		self.thrust.x = dir_x * self.thrust_power
		self.thrust.y = dir_y * self.thrust_power
		
		$"Thruster Particles".process_material.direction.x = -direction * dir_x
		$"Thruster Particles".process_material.direction.y = -direction * dir_y
	
	elif $"Thruster Particles".emitting:
		$"Thruster Particles".emitting = false
	
	self.acceleration += self.thrust * self.direction
	
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
func _process(delta):
	if not get_parent().simulation_paused and not self.crashed:
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
	if get_parent().edit_mode == 0 and not self.crashed:
		self.crashed = true
		hide()
		get_parent().get_space_objects()
		get_parent().manage_camera()
		get_parent().get_parent().get_node("PauseMenu/CanvasLayer/UI/GameOverDialogue").show_modal(true)


func set_trail_colour(colour):
	$"Positional Particles".process_material.color = colour


func change_particle_tick(game_speed, simulation_paused):
	if simulation_paused:
		$"Positional Particles".speed_scale = 0
		$"Thruster Particles".speed_scale = 0
	else:
		$"Positional Particles".speed_scale = game_speed
		$"Thruster Particles".speed_scale = game_speed
