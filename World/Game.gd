extends Control

@export var level_catalog : LevelCatalogResource

var level_index := -1
var max_level_index : int:
	get:
		return max(level_catalog.size() - 1, 0)

@onready var level_container = $LevelContainer
@onready var wave_number_text = $MarginContainer/WaveNumber
@onready var dream_caught_text = $DreamCaughtText
@onready var game_over = $GameOver
@onready var game_end = $GameEnd
@onready var death_fx = $DeathFX
@onready var lightning_fx = $LightningFX
@onready var lobby : LevelResource = preload("res://Levels/Lobby/Lobby.tres")

var level : BaseLevel = null

var client_peer_id := 1
var is_client_level_instantiated := false
signal client_level_instantiated

var dreams_caught = 0

# TODO Check if it needs to be set back to false at some point
var is_running := false


func _ready():
	_load_level(lobby)
	
	Events.level_ended.connect(_on_level_ended)
	Events.player_dead.connect(_player_dead)


func _load_level(level_resource: LevelResource):
	if level != null:
		level.queue_free()
	
	level = level_resource.level_scene.instantiate()
	level_container.add_child(level)
	
	if multiplayer.get_unique_id() == client_peer_id:
		notify_client_level_instantiated.rpc()
	
	if is_multiplayer_authority():
		if not NetworkTools.local_multiplayer:
			if not is_client_level_instantiated:
				push_warning('await level instantiation in client')
				await client_level_instantiated
				push_warning('client level is instantiated')
			is_client_level_instantiated = false
		
		set_player_authority.rpc(client_peer_id, 1)
		
		level.start.rpc()
		notify_level_started.rpc()


@rpc("any_peer", "call_remote", "reliable")
func notify_client_level_instantiated():
	is_client_level_instantiated = true
	client_level_instantiated.emit()

@rpc("authority", "call_local", "reliable")
func set_player_authority(peer_id: int, player_id: int):
	if player_id == 1:
		client_peer_id = peer_id
	level.set_player_authority(peer_id, player_id)

@rpc("authority", "call_local", "reliable")
func notify_level_started():
	Events.level_started.emit(level_index, max_level_index)


func start_level(index: int):
	is_running = true
	level_index = index
	_load_level(level_catalog.levels[level_index])


func start():
	start_level(0)
	MusicPlayer.next()


func _clean_builds():
	for build in get_tree().get_nodes_in_group("builds"):
		build.queue_free()


func _clean_projectiles():
	for projectile in get_tree().get_nodes_in_group("projectiles"):
		projectile.queue_free()


func _connect_projectile(spawned_instance: Projectile):
	if spawned_instance is AllyProjectile:
		#Events.missed_ally_projectile.connect(_on_missed_ally_projectile)
		Events.dream_caught.connect(_dream_caught)


func _dream_caught(_position: Vector2):
	dreams_caught += 1
	var wording = " dream caught" if dreams_caught == 1 else " dreams caught"
	dream_caught_text.text = "%d%s" % [dreams_caught, wording]


func _player_dead(player_id):
	print("Player %d is dead !" % player_id)
	death_fx.play()
	is_running = false
	game_over.show_game_over(-1)
	get_tree().paused = true


func _end():
	is_running = false
	game_end.show_scene()
	get_tree().paused = true

func _on_level_ended():
	var next_level_index = level_index + 1
	if next_level_index <= max_level_index:
		start_level(next_level_index)
	else:
		_end()



# TODO currently unused
#func _on_missed_ally_projectile(region_id):
	#var other_region_id = 1 - region_id
	#viewports_containers.sub_viewports[other_region_id].camera.start_flash(0.25, 0.3)
	#lightning_fx.play()
	# TODO: spawn Doom projectile
	# spawner_handler.spawn(Projectile.ProjectyleType.Doom, {"speed": 30.0, "target": level.world.player}, sides)
