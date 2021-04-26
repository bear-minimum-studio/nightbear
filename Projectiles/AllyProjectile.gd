extends Area2D

class_name AllyProjectile

signal missed_ally_projectile
signal dream_caught

onready var direction = Vector2.RIGHT
onready var speed = Parameters.ALLY_PROJECTILE_SPEED
var world_id

func initialize(spawn_location: Vector2, spawn_direction: Vector2, projectile_speed: float, target):
	transform.origin = spawn_location
	direction = spawn_direction
	speed = projectile_speed
	world_id = target.id

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	translate(speed * delta * direction)

func _on_VisibilityNotifier2D_screen_exited():
	emit_signal("missed_ally_projectile", world_id)
	_projectile_destruction()

func _projectile_destruction():
	queue_free()

func _on_AllyProjectile_body_entered(body):
	if (body is Wall):
		_hit_wall()
	elif (body is DreamCatcher):
		body.caught()
		_dream_caught()

func _hit_wall():
	queue_free()

func _dream_caught():
	emit_signal("dream_caught", self.global_position)
	queue_free()
