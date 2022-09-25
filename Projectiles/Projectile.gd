extends Area2D

class_name Projectile

enum ProjectyleType {Ally, Ennemy, Doom}

onready var sprite_container = $SpriteContainer
onready var particles = $Particles
onready var collision_shape = $CollisionShape2D

###########
# PRIVATE #
###########

func _update_direction(default_direction: Vector2) -> void:
	direction = default_direction

# Projectile call backs #

# Called when the projectile collides
func _on_collision(_body: Node2D) -> void:
	pass

# Called when the projectile exit the playing area
func _on_exit_game_area() -> void:
	_end()

# Called when the projectile needs to be destroyed
func _end() -> void:
	queue_free()
	
# Inherited call backs #

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	_update_direction(direction)
	translate(speed * delta * direction)

# Signal call backs from scene elements #

# Called when the object is not visible anymore
func _on_VisibilityNotifier2D_screen_exited() -> void:
	_on_exit_game_area()

# Called when the object collides with a body
func _on_Projectile_body_entered(body: Node2D) -> void:
	_on_collision(body)

func _die_with_particles():
	set_physics_process(false)
	collision_shape.call_deferred("set_disabled", true)
	sprite_container.visible = false
	particles.emitting = true
	# TODO needs to be freed after particles stop emitting, but not trivial

##########
# PUBLIC #
##########

var world_id := 0
var direction := Vector2.ZERO
var speed := 0.0

func initialize(spawn_parameters: Dictionary, father_world_id: int) -> void:
	world_id = father_world_id
	transform.origin = spawn_parameters.position
	speed = spawn_parameters.speed
	_update_direction(spawn_parameters.direction)
