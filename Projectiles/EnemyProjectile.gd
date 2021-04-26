extends Area2D

class_name EnemyProjectile

onready var direction = Vector2.RIGHT
onready var speed = Parameters.ALLY_PROJECTILE_SPEED

func initialize(spawn_location: Vector2, spawn_direction: Vector2, spawn_speed: float):
	transform.origin = spawn_location
	direction = spawn_direction
	speed = spawn_speed

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	translate(speed * delta * direction)

func _on_VisibilityNotifier2D_screen_exited():
	_projectile_destruction()

func _projectile_destruction():
	queue_free()

func _on_EnemyProjectile_body_entered(body):
	if (body is Wall):
		body.hit()
		_projectile_destruction()
	elif (body is Player):
		body.hit()
		_projectile_destruction()
	elif(body is DreamCatcher):
		body.hit()
