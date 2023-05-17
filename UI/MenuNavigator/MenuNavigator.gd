extends Node
class_name MenuNavigator

signal navigate(to_menu: MENU)

enum MENU {
		NONE,
		MAIN,
		PLAY,
		NETWORK,
		SETTINGS,
	}

@onready var menu_dict = {
	MENU.MAIN: $MainMenu,
	MENU.PLAY: $PlayMenu,
	MENU.NETWORK: $NetworkMenu,
	MENU.SETTINGS: $SettingsMenu,
}

var focused_menu : MENU = MENU.NONE


func _ready():
	navigate.connect(switch)
	for from_menu in menu_dict.keys():
		for exit_signal in menu_dict[from_menu].exits_dict:
			var to_menu = menu_dict[from_menu].exits_dict[exit_signal]
			exit_signal.connect(switch.bind(to_menu))

func switch(to_menu: MENU):
	if focused_menu != null:
		_hide(focused_menu)
	focus(to_menu)

func focus(to_menu: MENU):
	if to_menu == MENU.NONE:
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
