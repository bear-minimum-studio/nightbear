extends Area2D

class_name EnemyProjectile

onready var direction = Vector2.RIGHT
var enemy_projectile_speed

func initialize(spawn_location: Vector2, spawn_direction: Vector2):
	transform.origin = spawn_location
	direction = spawn_direction
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	enemy_projectile_speed = rng.randf_range(Parameters.ENEMY_PROJECTILE_MIN_SPEED, Parameters.ENEMY_PROJECTILE_MAX_SPEED)


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	translate(enemy_projectile_speed * delta * direction)

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
