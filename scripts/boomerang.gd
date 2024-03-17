extends CharacterBody2D


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


func _on_Boomerang_body_entered(body):
	if body.is_in_group("player"):
		# Der Spieler ist auf den Boomerang gestiegen
		body.set_boomerang_instance(self)
