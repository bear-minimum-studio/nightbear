@tool
extends EditorPlugin

const SETUP_DIALOG = preload("res://addons/newlevel/LevelSetupDialog.tscn")

# A class member to hold the button during the plugin life cycle.
var button : Button
var dialog : LevelSetupDialog


func _enter_tree():
	# Initialization of the plugin goes here.
	# Load the button scene and instantiate it.
	button = preload("res://addons/newlevel/NewLevelButton.tscn").instantiate()
	button.pressed.connect(show_dialog)

	# Add the loaded scene to the docks.
	add_control_to_container(CONTAINER_TOOLBAR, button)
	# Note that LEFT_UL means the left of the editor, upper-left button.


func _exit_tree():
	# Clean-up of the plugin goes here.
	# Remove the button.
	remove_control_from_container(CONTAINER_TOOLBAR, button)
	# Erase the control from the memory.
	button.queue_free()


func show_dialog():
	dialog = SETUP_DIALOG.instantiate()
	add_child(dialog)
	dialog.close_requested.connect(exit_dialog)
	#print(dialog.templates)
	
func exit_dialog():
	dialog.queue_free()
