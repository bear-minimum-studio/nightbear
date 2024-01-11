extends BaseLevel



@onready var animation_tree = $AnimationTree
@onready var state_machine = animation_tree.get("parameters/playback")
@onready var animation_player = $AnimationPlayer


enum states {PLAY, NIGHTMARE_TUTO, SHIELD_TUTO}

var shown_tutos = []

var state = states.PLAY :
	set(value):
		match value:
			states.NIGHTMARE_TUTO:
				world.process_mode = Node.PROCESS_MODE_DISABLED
				state_machine.travel("NightmareTuto")
				
			states.SHIELD_TUTO:
				world.process_mode = Node.PROCESS_MODE_DISABLED
				state_machine.travel('ShieldTuto')
				
			states.PLAY:
				state_machine.travel('RESET')
				world.process_mode = Node.PROCESS_MODE_INHERIT
				
		state = value





func _input(event):
	if state == states.PLAY:
		return
	
	if event.is_action_pressed('ui_accept') or event.is_action_pressed('ui_cancel'):
		set_state.rpc(states.PLAY)


func load_world():
	super.load_world()
	world.level_playback.animation_tree.animation_started.connect(_on_wave_started)


@rpc("any_peer", "call_local", "reliable")
func set_state(new_state: states):
	state = new_state


func _on_wave_started(anim_name):
	if not is_multiplayer_authority():
		return
	
	var world_state = world.level_playback.state_machine.get_current_node()
	if world_state == 'NightmareTuto':
		if states.NIGHTMARE_TUTO not in shown_tutos:
			set_state.rpc(states.NIGHTMARE_TUTO)
			shown_tutos.append(state)
	if world_state == 'ShieldTuto':
		if states.SHIELD_TUTO not in shown_tutos:
			set_state.rpc(states.SHIELD_TUTO)
			shown_tutos.append(state)


func _on_player_dead(player_id: int):
	if is_multiplayer_authority():
		var checkpoint = world.level_playback.state_machine.get_current_node()
		reload.rpc()
		await world_reloaded
		play_world_at_checkpoint.rpc(checkpoint)


@rpc("authority", "call_local", "reliable")
func play_world_at_checkpoint(checkpoint):
	world.start()
	world.level_playback.state_machine.start(checkpoint)

