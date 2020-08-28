extends KinematicBody2D

const UP = Vector2(0, -1)

export var max_walking_speed = 120
var speed = Vector2()

func _physics_process(delta):
	if Input.is_action_pressed("walk_right") and not Input.is_action_pressed("walk_left"):
		speed.x = max_walking_speed
		if is_on_floor():
			$AnimatedSprite.animation = "walking"
		$AnimatedSprite.flip_h = false
	elif Input.is_action_pressed("walk_left") and not Input.is_action_pressed("walk_right"):
		speed.x = -max_walking_speed
		if is_on_floor():
			$AnimatedSprite.animation = "walking"
		$AnimatedSprite.flip_h = true
	else:
		speed.x = 0
	if is_on_floor():
		if Input.is_action_just_pressed("jump"):
			speed.y = -400
			$AnimatedSprite.animation = "jumping"
		else:
			speed.y = 0
	else:
		speed.y += 9.8
		if speed.y > 10 and $AnimatedSprite.animation != "falling":
			$AnimatedSprite.animation = "falling"
	if speed.length() > -0.1 and speed.length() < 0.1:
		$AnimatedSprite.animation = "default"
	if is_on_ceiling():
		if speed.y < 2:
			speed.y += 9.8
		else:
			speed.y = 0
	move_and_slide(speed, UP)
