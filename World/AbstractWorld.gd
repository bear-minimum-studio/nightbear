extends Node2D

class_name AbstractWorld

@export var start_timer : float = 2.0

var wave_index := 0

var number_of_waves : int :
	get: 
		var animations = animation_player.get_animation_list()
		var waves_animations = 0
		for i in range(animations.size()):
			if animations.has('wave%d' % i): # not counting RESET
				waves_animations += 1
		return waves_animations

var is_level_ended : bool :
	get: return wave_index >= number_of_waves

var player_scene = preload("res://Player/Player.tscn")
var players : Array[Player] = [null, null]

var player_shade_scene = preload("res://Player/PlayerShade.tscn")
# Same index ad players
# => player_shades[0] is shade of players[0], same for player_shades[1]
var player_shades : Array[PlayerShade] = [null, null]

@onready var spawn_positions : Array[Node2D] = [$SpawnPosition0, $SpawnPosition1]
@onready var animation_player : AnimationPlayer = $AnimationPlayer

@onready var region_0_to_1 : Vector2 :
	get: return spawn_positions[1].position - spawn_positions[0].position

@onready var region_1_to_0 : Vector2 :
	get: return - region_0_to_1


var dream_caught = 0

func _ready():
	Events.build.connect(_build)
	Events.player_moved.connect(_move_player_shades)


func remove_players() -> Array[Player]:
	var old_players = players
	players = []
	
	for player in old_players:
		remove_child(player)
	return old_players

func add_players(new_players: Array[Player]):
	for new_player in new_players:
		_add_player(new_player)

func _add_player(new_player: Player):
	players[new_player.region_id] = new_player
	_reset_player_position(new_player.region_id)
	add_child(new_player)
	_spawn_player_shade(new_player)

func _reset_player_position(region_id):
	if players[region_id] != null:
		players[region_id].transform.origin = spawn_positions[region_id].position
	if player_shades[region_id] != null:
		player_shades[region_id].transform.origin = spawn_positions[region_id].position

## /!\ set player.name because it is automatically synchronized by MultiplayerSpawner 
## /!\ /!\ player.name is used to pass multiple variables (dirty) /!\ /!\
func spawn_player(peer_id: int, region_id: int):
	var new_player = player_scene.instantiate()
	# TODO Remove if unneeded
	new_player.name = str(peer_id) + '_' + str(region_id)
	new_player.region_id = region_id
	players[region_id] = new_player
	_add_player(new_player)

func _spawn_player_shade(player: Player):
	var new_player_shade = player_shade_scene.instantiate()
	new_player_shade.player = player
	new_player_shade.position_offset = translate_to_other_region(player.region_id)
	player_shades[player.region_id] = new_player_shade
	add_child(new_player_shade)

func spawn_shield(region_id: int, pos: Transform2D):
	var new_shield = Parameters.GAME_SHIELD.instantiate()
	new_shield.transform.origin = pos.origin + translate_to_other_region(region_id)
	add_child(new_shield)

func spawn_dream_catcher(pos: Transform2D):
	var new_dream_catcher = Parameters.GAME_DREAM_CATCHER.instantiate()
	new_dream_catcher.transform.origin = pos.origin
	add_child(new_dream_catcher)

func _build(region_id: int, pos:Transform2D):
	spawn_shield(region_id, pos)
	spawn_dream_catcher(pos)

func _move_player_shades():
	for player_shade in player_shades:
		player_shade.move_shade()

func translate_to_other_region(current_region: int):
	if current_region == 0:
		return region_0_to_1
	elif current_region == 1:
		return region_1_to_0

func _on_entity_spawned(instance):
	add_child(instance)

func next_wave():
	if is_level_ended:
		wave_index = -1
	
	if start_timer > 0:
		var t = get_tree().create_timer(start_timer)
		await t.timeout
	
	_freeze_players(false)
	
	var wave_name = "wave%d" % wave_index
	if animation_player.get_animation_list().has(wave_name):
		animation_player.play(wave_name)

func _on_wave_ended(_anim_name: StringName):
	wave_index += 1
	
	_freeze_players()
	
	if is_level_ended:
		Events.level_ended.emit()
	else:
		Events.wave_ended.emit(wave_index)

func _freeze_players(freeze: bool = true):
	for player in players:
		# TODO: improve and factorize
		# when loading lobby, the players do not exist yet but the level is started anyway
		if player == null: return
		player.frozen = freeze
