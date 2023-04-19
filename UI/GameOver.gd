extends Control


@onready var animation_player = $AnimationPlayer
@onready var wave_number_text = $WaveNumber
var game_over_ready = false

func show_game_over(wave_number: int):
	wave_number_text.text = "%d" % wave_number
	visible = true
	game_over_ready = false
	animation_player.play("Appear")


func _on_AnimationPlayer_animation_finished(_anim_name):
	game_over_ready = true

func _input(event):
	if !game_over_ready:
		return

	if event.is_action_pressed("ui_accept"):
		Events.replay_game.emit()
		visible = false
