extends Node

export (NodePath) var viewport_container1_path
export (NodePath) var viewport_container2_path

onready var viewport_container1 = get_node(viewport_container1_path)
onready var viewport_container2 = get_node(viewport_container2_path)

onready var world1 = viewport_container1.world
onready var world2 = viewport_container2.world

onready var ally_projectile_spawner_handlers = get_tree().get_nodes_in_group("ally_projectile_spawner_handler")
onready var enemy_projectile_spawner_handlers = get_tree().get_nodes_in_group("enemy_projectile_spawner_handler")

onready var dream_caught_text = $DreamCaughtText

var dreams_caught = 0

func _ready():
	for ally_projectile_spawner_handler in ally_projectile_spawner_handlers:
		ally_projectile_spawner_handler.connect("allied_projectile_spawned", self, "_connect_allied_projectile")
		
	var players = get_tree().get_nodes_in_group("player")
	for player in players:
		player.connect("build", self, "_build")
		player.connect("player_dead", self, "_player_dead")
	
	for ally_projectile_spawner_handler in ally_projectile_spawner_handlers:
		ally_projectile_spawner_handler.start_spawn_wave(1, 2, [SpawnHandler.Sides.Left])
		
	for enemy_projectile_spawner_handler in enemy_projectile_spawner_handlers:
		enemy_projectile_spawner_handler.start_spawn_wave(0.001, 2, [SpawnHandler.Sides.Top, SpawnHandler.Sides.Right])

func _build(id: int, t:Transform2D):
	var new_wall = Parameters.GAME_WALL.instance()
	new_wall.transform.origin = t.origin
	var new_dream_catcher = Parameters.GAME_DREAM_CATCHER.instance()
	new_dream_catcher.transform.origin = t.origin

	if (id  == 1):
		world2.add_child(new_wall)
		world1.add_child(new_dream_catcher)
	elif (id  == 2):
		world1.add_child(new_wall)
		world2.add_child(new_dream_catcher)

func _connect_allied_projectile(spawned_instance: AllyProjectile):
	var _unused1 = spawned_instance.connect("missed_ally_projectile", self, "_on_missed_ally_projectile")
	var _unused2 = spawned_instance.connect("dream_caught", self, "_dream_caught")

func _on_missed_ally_projectile():
	pass

func _dream_caught():
	dreams_caught += 1
	var wording = " dream caught" if dreams_caught == 1 else " dreams caught"
	dream_caught_text.text = String(dreams_caught) + wording

func _player_dead(id):
	print("Player %d is dead !" % id)
	var _unused = get_tree().reload_current_scene()
