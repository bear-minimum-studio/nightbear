extends Area2D

###########
# PRIVATE #
###########

func _update_direction(default_direction):
	if target:
		direction = self.global_position.direction_to(target.global_position)
	else:
		direction = default_direction
		
	return direction

# Projectile call backs #

# Called when the projectile collides
func _on_collision(_body):
	pass

# Called when the projectile exit the playing area
func _on_exit_game_area():
	_end()

# Called when the projectile needs to be destroyed
func _end():
	queue_free()
	
# Inherited call backs #

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	_update_direction(direction)
	translate(speed * delta * direction)

# Signal call backs from scene elements #

# Called when the object is not visible anymore
func _on_VisibilityNotifier2D_screen_exited():
	_on_exit_game_area()

# Called when the object collides with a body
func _on_Projectile_body_entered(body):
	_on_collision(body)

##########
# PUBLIC #
##########

var world_id = 0
var direction = Vector2.ZERO
var speed = 0
var target

func initialize(spawn_location: Vector2, spawn_direction: Vector2, projectile_speed: float, projectile_target, father_world_id: int):
	world_id = father_world_id
	transform.origin = spawn_location
	speed = projectile_speed
	target = projectile_target
	_update_direction(spawn_direction)
