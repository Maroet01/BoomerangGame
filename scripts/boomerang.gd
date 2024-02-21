extends StaticBody2D


const SPEED = 200.0
const RANGE = 1200
@export var direction = 1  # Initial direction
var travelled_distance = 0

func _process(delta):
	# Bewegung des Boomerangs
	position += Vector2(direction * SPEED * delta, 0)
	
	travelled_distance += SPEED * delta
	#if travelled_distance > RANGE:
	#	queue_free()


# Funktion, die aufgerufen wird, wenn der Timer auslöst
func _on_timer_timeout():
	direction *= -1
