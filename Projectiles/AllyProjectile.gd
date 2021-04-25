extends Area2D

class_name AllyProjectile

signal missed_ally_projectile

const SPEED = 75
onready var direction = Vector2.RIGHT

func initialize(spawn_location: Vector2, spawn_direction: Vector2):
	transform.origin = spawn_location
	direction = spawn_direction

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	translate(SPEED * delta * direction)

func _on_VisibilityNotifier2D_screen_exited():
	emit_signal("missed_ally_projectile")
	_projectile_destruction()

func _projectile_destruction():
	queue_free()

func _on_AllyProjectile_body_entered(body):
	if (body is Wall):
		_hit_wall()
	elif (body is DreamCatcher):
		_dream_caught()

func _hit_wall():
	queue_free()

func _dream_caught():
	queue_free()
