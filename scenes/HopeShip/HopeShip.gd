extends Area2D


export var identifyer = "HopeShip"
export var thrust_power = 25

export var mass = 1

export var speed = Vector2(0, 0)
export var acceleration = Vector2(0, 0)
export var thrust = Vector2(0, -1)
export var angle_speed = 0
export var direction = 0

export var stay_in_place = false

var index = 0


func apply_acceleration(delta):
	get_node("Sprite").rotation += self.angle_speed * delta
	get_node("Positional Particles").rotation += self.angle_speed * delta
	get_node("CollisionShape2D").rotation += self.angle_speed * delta
	
	self.thrust.x = sin(get_node("Sprite").rotation) * self.thrust_power
	self.thrust.y = -cos(get_node("Sprite").rotation) * self.thrust_power
	
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

