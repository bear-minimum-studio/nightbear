extends Control

@onready var sub_viewport_containers = [$Viewports/SubViewportContainer0, $Viewports/SubViewportContainer1]
@onready var wave_number_text = $MarginContainer/WaveNumber
@onready var dream_caught_text = $DreamCaughtText
@onready var game_over = $GameOver
@onready var game_end = $GameEnd
@onready var sequence = $SequencePlayer
@onready var death_fx = $DeathFX
@onready var lightning_fx = $LightningFX
@onready var sequence_player = $SequencePlayer
@onready var world = $Viewports/SubViewportContainer0/SubViewport/World


var dreams_caught = 0

var is_running := false


func _ready():
	for spawner_handler in world.spawner_handlers:
		spawner_handler.entity_spawned.connect(_connect_projectile)
	
	Events.new_subsequence.connect(_new_subsequence)
	Events.sequence_ended.connect(_sequence_ended)
	
	Events.build.connect(_build)
	Events.player_dead.connect(_player_dead)
	Events.player_moved.connect(_move_player_shade)
	
	### WE NEED TO SET THE RENDERED WORLD FOR THE SECOND VIEWPORT AS THE WORLD CAN ONLY EXIST IN ONE VIEWPORT
	### /!\ SETTING THIS TO world DOESN'T WORK WE NEED TO USE THE EXACT OBJECT USED IN THE FIRST VIEWPORT
	sub_viewport_containers[1].sub_viewport.world_2d = sub_viewport_containers[0].sub_viewport.world_2d
	
	for region_id in [0,1]:
		sub_viewport_containers[region_id].camera_2d.position = world.spawn_positions[region_id].position


func initialize():
	world.set_player_spawns() 
	_center_players()
	_clean_builds()
	_clean_projectiles()
	_init_tentacles()
	_init_sequence()

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

func _init_sequence():
	sequence.init(world)

# TODO: MAKE LEVEL PARAMETRABLE
func start_level():
	is_running = true
	MusicPlayer.next()
	initialize()
	# Sequence should be played on server side only
	# Maybe only instanciate SequencePlayer on server side ?
	sequence.start()

func _build(_world_id: int, pos:Transform2D):
	# TO REFACTO
	world.spawn_wall(pos)
	world.spawn_dream_catcher(pos)

func _connect_projectile(spawned_instance: Projectile):
	if spawned_instance is AllyProjectile:
		Events.missed_ally_projectile.connect(_on_missed_ally_projectile)
		Events.dream_caught.connect(_dream_caught)

func _dream_caught(_position: Vector2):
	dreams_caught += 1
	var wording = " dream caught" if dreams_caught == 1 else " dreams caught"
	dream_caught_text.text = "%d%s" % [dreams_caught, wording]

func _player_dead(world_id):
	# TO REFACTO
	print("Player %d is dead !" % world_id)
	death_fx.play()
	var wave_index = sequence.current_index
	game_over.show_game_over(wave_index + 1)
	get_tree().paused = true

func _move_player_shade(world_id: int, new_position: Vector2):
	# TO REFACTO
	var player_shades = get_tree().get_nodes_in_group("player_shade")
	for player_shade in player_shades:
		if player_shade.world_id != world_id:
			player_shade.move_shade(new_position)

func _sequence_ended():
	game_end.show_scene()
	get_tree().paused = true

func _new_subsequence(wave_index: int):
	wave_number_text.next_wave(wave_index + 1)
	var tentacles = get_tree().get_nodes_in_group("tentacle")
	for tentacle in tentacles:
		tentacle.grow()

func _on_missed_ally_projectile(_world_id):
	# TO REFACTO
	#	var other_world_id = 1 - world_id
	#	var world = worlds[other_world_id]
	#	var spawner_handler = world.spawner_handler
	#	viewport_containers[other_world_id].camera.start_flash(0.25, 0.3)
	#	lightning_fx.play()
	#	var sides = [SpawnHandler.Sides.Left, SpawnHandler.Sides.Top, SpawnHandler.Sides.Right, SpawnHandler.Sides.Bottom]
	#	spawner_handler.spawn(Projectile.ProjectyleType.Doom, {"speed": 30.0, "target": world.player}, sides)
	pass
