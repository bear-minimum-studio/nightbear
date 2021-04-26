extends Area2D

class_name DoomProjectile

onready var direction = Vector2.ZERO
onready var speed = Parameters.DOOM_PROJECTILE_SPEED
var target

func initialize(spawn_location: Vector2, _spawn_direction: Vector2, projectile_speed: float, projectile_target):
	transform.origin = spawn_location
	speed = projectile_speed
	target = projectile_target
	direction = self.get_global_position().direction_to(target.get_global_position())

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if target:
		direction = self.get_global_position().direction_to(target.get_global_position())
		translate(speed * delta * direction)

func _on_VisibilityNotifier2D_screen_exited():
	_projectile_destruction()

func _projectile_destruction():
	queue_free()

func _on_DoomProjectile_body_entered(body):
	if (body is Wall):
		body.hit()
		_projectile_destruction()
	elif (body is Player):
		body.hit()
		_projectile_destruction()
	elif(body is DreamCatcher):
		body.hit()
