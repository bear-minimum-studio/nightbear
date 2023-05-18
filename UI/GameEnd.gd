extends Control


@onready var animation_player = $AnimationPlayer
var game_end_ready = false

func show_scene():
	visible = true
	game_end_ready = false
	animation_player.play("Appear")

func _on_AnimationPlayer_animation_finished(_anim_name):
	game_end_ready = true

func _input(event):
	if !game_end_ready:
		if event.is_action_pressed("ui_accept"):
			_skip_animation.rpc()
		return

	if event.is_action_pressed("ui_accept"):
		_on_ui_accept.rpc()


@rpc("call_local","any_peer")
func _skip_animation():
	if animation_player.is_playing():
		animation_player.advance(animation_player.current_animation_length - animation_player.current_animation_position)

@rpc("call_local", "any_peer")
func _on_ui_accept():
	Events.replay_game.emit()
	visible = false
