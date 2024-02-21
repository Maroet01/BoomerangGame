extends CharacterBody2D

@export var SPEED = 300.0
@export var JUMP_VELOCITY = -400.0

var boomerang_instance = null

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	handle_gravity(delta)
	handle_jump()
	handle_movement()
	handle_boomerang_throw()
	handle_boomerang_recall() 
	move_and_slide()

func handle_jump():
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

func handle_movement():
	var horizontal_direction = Input.get_axis("move_left", "move_right")
	if horizontal_direction:
		velocity.x = horizontal_direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

func handle_boomerang_throw():
	var shot_left_pressed = Input.is_action_just_pressed("shot_left")
	var shot_right_pressed = Input.is_action_just_pressed("shot_right")

	if shot_left_pressed or shot_right_pressed:
		throw_boomerang(Input.get_axis("shot_left", "shot_right"))

func handle_boomerang_recall():
	var recall_pressed = Input.is_action_just_pressed("recall_boomerang")

	if recall_pressed and boomerang_instance != null:
		recall_boomerang()

func throw_boomerang(direction: float):
	const BOOMERANG = preload("res://scenes/boomerang.tscn")
	
	# Wenn der Boomerang noch nicht geworfen wurde, erzeuge einen neuen Boomerang
	if boomerang_instance != null:
		return
		
	boomerang_instance = BOOMERANG.instantiate()
	boomerang_instance.position = position
	boomerang_instance.set("direction", Vector2(direction, 0))
	get_parent().add_child(boomerang_instance) # this is so the boomerang does not move with the player
	
func recall_boomerang():
	boomerang_instance.queue_free()
	boomerang_instance = null
	
func handle_gravity(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
