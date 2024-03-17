extends CharacterBody2D

@export var SPEED = 300.0
@export var JUMP_VELOCITY = -400.0
@export var SPAWN_BOOMERANG_FROM_PLAYER = 100.0
@export var DEATH_HEIGHT = 1000.0
@export var START_POSITION = Vector2(350, 0)

var boomerang_instance = null
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	position = START_POSITION

func _physics_process(delta):
	handle_gravity(delta)
	handle_jump()
	handle_movement()
	handle_boomerang_throw()
	handle_boomerang_recall()
	check_death()
	move_and_slide()

func handle_jump():
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

func handle_movement():
	var horizontal_direction = Input.get_axis("move_left", "move_right")
	if horizontal_direction:
		velocity.x = horizontal_direction * SPEED
	else:
		velocity.x = 0

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

	if boomerang_instance != null:
		return

	boomerang_instance = BOOMERANG.instantiate()
	boomerang_instance.position = position + Vector2(SPAWN_BOOMERANG_FROM_PLAYER * direction, 0)
	boomerang_instance.set("direction", direction)
	get_parent().add_child(boomerang_instance) # this is to avoid the boomerang moving with the player

func recall_boomerang():
	boomerang_instance.queue_free()
	boomerang_instance = null

func handle_gravity(delta):
	if not is_on_floor():
		velocity.y += gravity * delta

func check_death():
	if position.y > DEATH_HEIGHT:
		die()

func die():
	position = START_POSITION
	# Hier könntest du zusätzliche Logik hinzufügen, um den Spielerzustand zurückzusetzen
	# zum Beispiel die Energie, Leben, etc.
