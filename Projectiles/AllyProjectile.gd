extends Area2D

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
	pass

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
