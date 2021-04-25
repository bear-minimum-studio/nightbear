extends Control

signal replay

onready var animation_player = $AnimationPlayer
var ready = false

func show():
	visible = true
	ready = false
	animation_player.play("Appear")


func _on_AnimationPlayer_animation_finished(_anim_name):
	ready = true

func _input(event):
	if !ready:
		return

	if event.is_action_pressed("P1_build") or event.is_action_pressed("P2_build"):
		emit_signal("replay")
		visible = false
