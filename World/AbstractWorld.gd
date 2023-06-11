extends Node2D

class_name AbstractWorld

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
var player_shades = [null, null]

@onready var spawn_positions : Array[Node] = [$SpawnPosition0, $SpawnPosition1]
@onready var multiplayer_spawner : MultiplayerSpawner = $MultiplayerSpawner
@onready var animation_player : AnimationPlayer = $AnimationPlayer

@onready var region_0_to_1 : Vector2 :
	get: return spawn_positions[1].position - spawn_positions[0].position

@onready var region_1_to_0 : Vector2 :
	get: return - region_0_to_1


var dream_caught = 0

func _ready():
	Events.build.connect(_build)
	Events.player_moved.connect(_move_player_shade)

func set_player_spawns():
	players[0].spawn_position = spawn_positions[0].position
	players[1].spawn_position = spawn_positions[1].position

## /!\ set player.name because it is automatically synchronized by MultiplayerSpawner 
## /!\ /!\ player.name is used to pass multiple variables (dirty) /!\ /!\
func spawn_player(peer_id: int, region_id: int):
	var new_player = player_scene.instantiate()
	new_player.name = str(peer_id) + '_' + str(region_id)
	new_player.transform.origin = spawn_positions[region_id].position
	players[region_id] = new_player
	add_child(new_player)

## /!\ /!\ player.name is used to pass region_id (dirty) /!\ /!\
func spawn_player_shade(region_id: int):
	var new_player_shade = player_shade_scene.instantiate()
	new_player_shade.name = str(region_id)
	new_player_shade.transform.origin = spawn_positions[1 - region_id].position
	player_shades[region_id] = new_player_shade
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

func _move_player_shade(region_id: int, new_position: Vector2):
	var player_shades = get_tree().get_nodes_in_group("player_shade")
	for player_shade in player_shades:
		if player_shade.region_id != region_id:
			player_shade.move_shade(new_position + translate_to_other_region(region_id))

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
	
	var wave_name = "wave%d" % wave_index
	if animation_player.get_animation_list().has(wave_name):
		animation_player.play(wave_name)

func _on_wave_ended(_anim_name: StringName):
	wave_index += 1
	if is_level_ended:
		Events.level_ended.emit(world_id)
	else:
		Events.wave_ended.emit(world_id, wave_index)
