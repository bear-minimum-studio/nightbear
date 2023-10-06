extends Node2D

class_name AbstractWorld


@export var start_timer : float = 0.1

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


var player_shade_scene = preload("res://Player/PlayerShade.tscn")
# Same index ad players
# => player_shades[0] is shade of players[0], same for player_shades[1]
var player_shades : Array[PlayerShade] = [null, null]

# TODO REFACTO
@onready var players : Array[Player] = [$Player0, $Player1]
@onready var spawn_positions : Array[Node2D] = [$SpawnPosition0, $SpawnPosition1]
@onready var animation_player : AnimationPlayer = $AnimationPlayer

# TODO REFACTO
@onready var region_0_to_1 : Vector2 :
	get: return spawn_positions[1].position - spawn_positions[0].position

@onready var region_1_to_0 : Vector2 :
	get: return - region_0_to_1


var dream_caught = 0

func _ready():
	Events.build.connect(_build)
	Events.player_moved.connect(_move_player_shades)
	_spawn_player_shade(players[0])
	_spawn_player_shade(players[1])

func set_player_authority(peer_id: int, region_id: int):
	players[region_id].peer_id = peer_id

# TODO REFACTO
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
	
	var wave_name = "wave%d" % wave_index
	if animation_player.get_animation_list().has(wave_name):
		animation_player.play(wave_name)



func _on_wave_ended(_anim_name: StringName):
	wave_index += 1
	
	if is_level_ended:
		Events.level_ended.emit()
	else:
		Events.wave_ended.emit(wave_index)
