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



func _ready():
	super._ready()
	world.animation_tree.animation_started.connect(_on_wave_started)


func _input(event):
	if state == states.PLAY:
		return
	
	if event.is_action_pressed('ui_accept') or event.is_action_pressed('ui_cancel'):
		state = states.PLAY


func _on_wave_started(anim_name):
	var world_state = world.state_machine.get_current_node()
	if world_state == 'NightmareTuto':
		if states.NIGHTMARE_TUTO not in shown_tutos:
			state = states.NIGHTMARE_TUTO
			shown_tutos.append(state)
	if world_state == 'ShieldTuto':
		if states.SHIELD_TUTO not in shown_tutos:
			state = states.SHIELD_TUTO
			shown_tutos.append(state)


func _on_animation_tree_animation_finished(anim_name):
	return
	if anim_name == 'RESET':
		world.process_mode = Node.PROCESS_MODE_INHERIT # HACK cracra boudin, implement in state machine


func _on_player_dead(player_id):
	var checkpoint = world.state_machine.get_current_node()
	reload()
	world.state_machine.start(checkpoint)
