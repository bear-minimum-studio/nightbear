extends Node2D

class_name AbstractWorld


signal player_dead(player_id: int)


var dream_caught = 0
var wave_index := 0
#var max_wave_index : int :
	#get: 
		#var animations = animation_player.get_animation_list()
		#var waves_animations = 0
		#for i in range(animations.size()):
			#if animations.has('wave%d' % i): # not counting RESET
				#waves_animations += 1
		#return max(waves_animations - 1, 0)


@onready var players : Array[Player] = [$Player0, $Player1]

@onready var proxy_camera0 : ProxyCamera = $ProxyCamera0
@onready var proxy_camera1 : ProxyCamera = $ProxyCamera1

@onready var animation_tree : AnimationTree = $AnimationTree
@onready var state_machine : AnimationNodeStateMachinePlayback = animation_tree.get("parameters/playback")
@onready var animation_player : AnimationPlayer = $AnimationPlayer


func _ready():
	Events.build.connect(_build)

# TODO: move to state machine
#func _physics_process(_delta):
	#if Input.is_action_just_pressed("next_wave"):
		#_on_wave_ended.rpc("")

func set_player_authority(peer_id: int, player_id: int):
	players[player_id].peer_id = peer_id

func spawn_shield(player: Player):
	var new_shield = Parameters.GAME_SHIELD.instantiate()
	new_shield.transform.origin = player.player_shade.global_position
	add_child(new_shield)

func spawn_dream_catcher(player: Player):
	var new_dream_catcher = Parameters.GAME_DREAM_CATCHER.instantiate()
	new_dream_catcher.transform.origin = player.global_position
	add_child(new_dream_catcher)

func _build(player: Player):
	spawn_shield(player)
	spawn_dream_catcher(player)

func _on_entity_spawned(instance):
	add_child(instance)

@rpc("authority", "call_local", "reliable")
func start():
	animation_tree.active = true

# TODO: clean up everything that listens to Events.wave_started
#@rpc("authority", "call_local", "reliable")
#func _start_wave(index: int):
	#wave_index = index
	#var wave_name = "wave%d" % index
	#if animation_player.get_animation_list().has(wave_name):
		#animation_player.play(wave_name)
		#Events.wave_started.emit(index, max_wave_index)


func _on_animation_tree_animation_finished(anim_name):
	if state_machine.get_current_node() == 'End':
		Events.level_ended.emit()


func _on_player_dead(player_id):
	player_dead.emit(player_id)

