extends Node

class_name MenuNavigator

signal exit_menu(menu)

enum MENU {
		NONE,
		MAIN,
		PLAY,
		NETWORK,
		SETTINGS,
		PAUSE,
	}

@onready var menu_dict = {
	MENU.MAIN: $MainMenu,
	MENU.PLAY: $PlayMenu,
	MENU.NETWORK: $NetworkMenu,
	MENU.SETTINGS: $SettingsMenu,
	MENU.PAUSE: $PauseMenu,
}

var active := false
var focused_menu : MENU = MENU.NONE
var navigation_history : Array[MENU]

func _ready():
	for from_menu in menu_dict.keys():
		for exit_signal in menu_dict[from_menu].exits_dict:
			var to_menu = menu_dict[from_menu].exits_dict[exit_signal]
			exit_signal.connect(switch.bind(to_menu))

func _input(event):
	if active and event.is_action_pressed("ui_cancel"):
		get_viewport().set_input_as_handled()
		go_back()

func open(start_menu: MENU):
	focus(start_menu)
	active = true
	reset_history()

func close():
	switch(MENU.NONE)

func reset_history():
	navigation_history = [MENU.NONE]

func go_back():
	var last_menu = navigation_history.pop_back()
	if last_menu == null or last_menu == MENU.NONE:
		exit_menu.emit(focused_menu)
		return
	switch(last_menu, true)

func switch(to_menu: MENU, going_back = false):
	if focused_menu != null:
		_hide(focused_menu)
		if !going_back:
			navigation_history.append(focused_menu)
	focus(to_menu)

func focus(to_menu: MENU):
	if to_menu == MENU.NONE:
		active = false
		return
	_show(to_menu)
	focused_menu = to_menu

func _show(menu: MENU):
	if menu == MENU.NONE:
		return
	menu_dict[menu].show()

func _hide(menu: MENU):
	if menu == MENU.NONE:
		return
	menu_dict[menu].hide()
