extends CharacterBody2D

@export var SPEED = 300.0
@export var JUMP_VELOCITY = -400.0

var boomerang_instance = null

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input horizontal_direction and handle the movement/deceleration.
	# horizontal_direction returns either -1, 0 or 1 depending on if we press "move_left", nothing or "move_right"
	var horizontal_direction = Input.get_axis("move_left", "move_right")
	if horizontal_direction:
		# here we multiply by the horizontal_direction which is either -1, 0 or 1 to direct if we go left, stop or right
		velocity.x = horizontal_direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	if Input.is_action_just_pressed("shot_left") || Input.is_action_just_pressed("shot_right"):
		throw_boomerang(Input.get_axis("shot_left", "shot_right"))
		
	print(global_position)
	move_and_slide()


func throw_boomerang(direction: float):
	const BOOMERANG = preload("res://scenes/boomerang.tscn")
	
	# Wenn der Boomerang noch nicht geworfen wurde, erzeuge einen neuen Boomerang
	if boomerang_instance != null:
		return
		
	boomerang_instance = BOOMERANG.instantiate()
	boomerang_instance.position = Vector2(0,0)
	boomerang_instance.set("direction", Vector2(direction, 0))
	get_parent().add_child(boomerang_instance) # this is so the boomerang does not move the player
	
