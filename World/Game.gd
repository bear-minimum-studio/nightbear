extends Control

@onready var viewports_containers = $ViewportsContainer
@export var level_catalog : LevelCatalogResource

var level_index := -1
var wave_ended : bool = false
var level_ended : bool = false

@onready var wave_number_text = $MarginContainer/WaveNumber
@onready var dream_caught_text = $DreamCaughtText
@onready var game_over = $GameOver
@onready var game_end = $GameEnd
@onready var death_fx = $DeathFX
@onready var lightning_fx = $LightningFX
@onready var lobby : LevelResource = preload("res://Levels/Lobby/Lobby.tres")

var world : AbstractWorld = null

var dreams_caught = 0

var is_running := false


func _ready():
	_load_level(lobby)
	
	Events.wave_ended.connect(_on_wave_ended)
	Events.level_ended.connect(_on_level_ended)
	
	Events.player_dead.connect(_player_dead)

func _load_level(level: LevelResource):
	# TODO Clean if uneeded
#	_clean_projectiles()
#	_clean_builds()
	var old_players : Array[Player] = []
	if world != null:
		old_players = world.remove_players()
		world.queue_free()

	level_ended = false
	
	# HACK: wait for cleaning to be over before reloading the level
	# TODO: find a clean and reliable method
	var timer = get_tree().create_timer(0.05)
	await timer.timeout
	
	world = level.world_scene.instantiate()
	viewports_containers.world = world
	# Does nothing if no player has spawn yet
	# First player spawn is handled by main
	world.add_players(old_players)
	
	_init_tentacles()
	# TODO REFACTO: world should have control of _next_wave ?
	_next_wave(0)

func add_player(peer_id: int, region_id: int):
	world.spawn_player(peer_id, region_id)

func _next_level():
	level_index += 1
	wave_ended = false
	level_ended = false
	if level_index < level_catalog.levels.size():
		_load_level(level_catalog.levels[level_index])
	else:
		_levels_ended()

func _clean_builds():
	for build in get_tree().get_nodes_in_group("builds"):
		build.queue_free()

func _clean_projectiles():
	for projectile in get_tree().get_nodes_in_group("projectiles"):
		projectile.queue_free()

func _init_tentacles():
	var tentacles = get_tree().get_nodes_in_group("tentacle")
	for tentacle in tentacles:
		tentacle.init()

func start_level(new_level_index: int):
	level_index = new_level_index
	var level = level_catalog.levels[level_index]
	_load_level(level)
	is_running = true
	MusicPlayer.next()

func _connect_projectile(spawned_instance: Projectile):
	if spawned_instance is AllyProjectile:
		Events.missed_ally_projectile.connect(_on_missed_ally_projectile)
		Events.dream_caught.connect(_dream_caught)

func _dream_caught(_position: Vector2):
	dreams_caught += 1
	var wording = " dream caught" if dreams_caught == 1 else " dreams caught"
	dream_caught_text.text = "%d%s" % [dreams_caught, wording]

func _player_dead(region_id):
	# TODO TO REFACTO
	print("Player %d is dead !" % region_id)
	death_fx.play()
	game_over.show_game_over(world.wave_index + 1)
	get_tree().paused = true

func _levels_ended():
	game_end.show_scene()
	get_tree().paused = true

func _on_level_ended():
	if world.is_level_ended:
		_next_level()

func _on_wave_ended(wave_index: int):
	wave_ended = true
	# TODO REFACTO move is_level_ended to Game or move wave logic to world
	if world.is_level_ended:
		return
	if wave_ended:
		_next_wave(wave_index)

func _next_wave(wave_index: int):
	# TODO: REFACTO use signal from world when a new wave begins and move this code to camera
	wave_number_text.next_wave(level_index + 1, wave_index + 1)
	var tentacles = get_tree().get_nodes_in_group("tentacle")
	for tentacle in tentacles:
		tentacle.grow()
	wave_ended = false
	world.next_wave()

func _on_missed_ally_projectile(region_id):
	var other_region_id = 1 - region_id
	viewports_containers.sub_viewports[other_region_id].camera.start_flash(0.25, 0.3)
	lightning_fx.play()
	# TODO: spawn Doom projectile
	# spawner_handler.spawn(Projectile.ProjectyleType.Doom, {"speed": 30.0, "target": world.player}, sides)
