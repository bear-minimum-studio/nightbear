extends Control


@export var level_catalog : LevelCatalogResource

signal level_selected


@onready var item_list: ItemList = $HBoxContainer/ItemList


func _ready():
	populate_levels()
	item_list.select(0)
	item_list.grab_focus()


func populate_levels():
	for level in level_catalog.levels:
		item_list.add_item(level.name, preload("res://icon.png"))


func inspect(level: LevelResource):
	$HBoxContainer/LevelInspector/MarginContainer/VBoxContainer/Name.text = level.name
	$HBoxContainer/LevelInspector/MarginContainer/VBoxContainer/HBoxContainer/Difficulty.text = level.difficulty
	$HBoxContainer/LevelInspector/MarginContainer/VBoxContainer/Description.text = '[i]' + level.description + '[/i]'


func _on_item_list_item_selected(index: int) -> void:
	inspect(level_catalog.levels[index])
	print(index)


func _on_item_list_item_activated(index: int) -> void:
	# TODO: returning level would be cleaner
	#level_selected.emit(level_catalog.levels[index])
	level_selected.emit(index)
