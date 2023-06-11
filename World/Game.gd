extends Control

@onready var sub_viewport_containers = [$Viewports/SubViewportContainer0, $Viewports/SubViewportContainer1]
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
@onready var lobby : LevelResource = preload("res://Levels/Lobby.tres")

var dreams_caught = 0

var is_running := false


func _ready():
	_load_level(lobby)
	
	Events.wave_ended.connect(_on_wave_ended)
	Events.level_ended.connect(_on_level_ended)
	
	Events.player_dead.connect(_player_dead)

func _load_level(level: LevelResource):
	_clean_projectiles()
	_clean_builds()
	_center_players()

	level_ended = false
	
	# HACK: wait for cleaning to be over before reloading the level
	# TODO: find a clean and reliable method
	var timer = get_tree().create_timer(0.05)
	await timer.timeout
	
	var world = level.world.instantiate()
	sub_viewport_containers[0].world = world
	
	### WE NEED TO SET THE RENDERED WORLD FOR THE SECOND VIEWPORT AS THE WORLD CAN ONLY EXIST IN ONE VIEWPORT
	### /!\ SETTING THIS TO world DOESN'T WORK WE NEED TO USE THE EXACT OBJECT USED IN THE FIRST VIEWPORT
	sub_viewport_containers[1].sub_viewport.world_2d = sub_viewport_containers[0].sub_viewport.world_2d
	
	for region_id in [0,1]:
		sub_viewport_containers[region_id].camera_2d.position = world.spawn_positions[region_id].position
	
	_init_tentacles()
	_next_wave(0)

func _next_level():
	level_index += 1
	wave_ended = [false, false]
	level_ended = [false, false]
	if level_index < level_catalog.levels.size():
		_load_level(level_catalog.levels[level_index])
	else:
		_levels_ended()

func _center_players():
	if multiplayer.is_server():
		for player in world.players:
			player.reset_position.rpc()
		for player_shade in world.player_shades:
			player_shade.reset_position.rpc()

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
	# TO REFACTO
	print("Player %d is dead !" % region_id)
	death_fx.play()
	var wave_index = worlds[0].wave_index
	game_over.show_game_over(wave_index + 1)
	get_tree().paused = true

func _move_player_shade(world_id: int, new_position: Vector2):
	var player_shades = get_tree().get_nodes_in_group("player_shade")
	for player_shade in player_shades:
		if player_shade.world_id != world_id:
			player_shade.move_shade(new_position)

func _levels_ended():
	game_end.show_scene()
	get_tree().paused = true

func _on_level_ended(_world_id: int):
	if worlds[0].is_level_ended and worlds[1].is_level_ended:
		_next_level()

func _on_wave_ended(world_id: int, wave_index: int):
	wave_ended[world_id] = true
	if worlds[world_id].is_level_ended:
		return
	if wave_ended[1 - world_id]:
		_next_wave(wave_index)

func _next_wave(wave_index: int):
	wave_number_text.next_wave(level_index + 1, wave_index + 1)
	var tentacles = get_tree().get_nodes_in_group("tentacle")
	for tentacle in tentacles:
		tentacle.grow()
	for world_id in [0, 1]:
		wave_ended[world_id] = false
		worlds[world_id].next_wave()

func _on_missed_ally_projectile(_region_id):
	# TO REFACTO
	#	var other_region_id = 1 - region_id
	#	var world = worlds[other_region_id]
	#	var spawner_handler = world.spawner_handler
	#	viewport_containers[other_region_id].camera.start_flash(0.25, 0.3)
	#	lightning_fx.play()
	#	var sides = [SpawnHandler.Sides.Left, SpawnHandler.Sides.Top, SpawnHandler.Sides.Right, SpawnHandler.Sides.Bottom]
	#	spawner_handler.spawn(Projectile.ProjectyleType.Doom, {"speed": 30.0, "target": world.player}, sides)
	pass
