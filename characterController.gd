extends CharacterBody2D

@onready var mouseTracker: Sprite2D = $ShootingTracker/MouseTracker

@export var maxSpeed := 300.0
@export var accel := 1600.0
@export var friction := 1700.0

var inputDir = Vector2.ZERO

func _unhandled_input(event: InputEvent) -> void:
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			var mousePos = mouseTracker.global_position
			var newPos = mousePos + event.relative
			mouseTracker.global_position = newPos
		elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
			shoot()
	
	if event is InputEventMouseButton:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		mouseTracker.visible = true

func _do_movement(delta):
	if inputDir == Vector2.ZERO:
		if velocity.length() > friction * delta:
			velocity -= velocity.normalized() * friction * delta 
		else:
			velocity = Vector2.ZERO
	else:
		velocity += inputDir * accel * delta
	velocity = velocity.limit_length(maxSpeed)
	move_and_slide()

func _physics_process(delta: float) -> void:
	inputDir = Input.get_vector("left", "right", "up", "down").normalized()
	_do_movement(delta)
	
	var targetAngle = global_position.direction_to(mouseTracker.global_position).angle()
	rotation = lerp_angle(rotation, targetAngle, 10 * delta)
	
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func shoot():
	print("shoot")
