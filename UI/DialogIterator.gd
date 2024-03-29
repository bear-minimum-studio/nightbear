@tool
extends Control

@export var current_step := 0 :
	get:
		return current_step
	set(new_current_step):
		current_step = new_current_step
		print_screen(current_step)

signal end

var is_active = false

func hide_iterator():
	current_step = 0
	var children = get_children()
	for child in children:
		child.hide()

func start():
	is_active = true
	print_screen(0)

func print_screen(_step):
	var children = get_children()
	var number_of_steps = children.size()
	for index in range(number_of_steps):
		var child = children[index]
		if (index) == current_step:
			child.show()
		else:
			child.hide()

func _input(event):
	if !is_active:
		return

	var number_of_steps = get_children().size()
	if event.is_action_pressed("ui_accept"):
		get_viewport().set_input_as_handled() # stop ui_accept to propagate to main menu when closing intro
		current_step += 1

		if (current_step >= number_of_steps):
			is_active = false
			hide_iterator()
			emit_signal("end")
		else:
			print_screen(current_step)

func _ready():
	hide_iterator()

