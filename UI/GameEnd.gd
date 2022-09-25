extends Control

signal replay

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
		return

	if event.is_action_pressed("ui_accept"):
		emit_signal("replay")
		visible = false
