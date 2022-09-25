extends Node


var current_theme = "intro"
var queued_theme

var next_theme = {
	"intro": "preverse", 
	"preverse": "nightmare",
	"nightmare": "nightmare",
}

@onready var intro = $IntroMusic
@onready var preverse = $PreVerseMusic
@onready var nightmare = $NightmareMusic

@onready var soundtrack = {
	"intro": intro,
	"preverse": preverse,
	"nightmare": nightmare,
}


func start():
	_play("intro")

func next():
	# let current track finish and start the next one
	queued_theme = next_theme[current_theme]
	print("Queued theme: ", queued_theme)

func _ready():
	for track in soundtrack.values():
		var _connect_error = track.connect("finished",Callable(self,"_on_finished"))
	start()

func _play(theme):
	print("Playing " + theme + " track")
	soundtrack[theme].play()
	current_theme = theme
	queued_theme = _get_next_theme(theme)

func _get_next_theme(theme):
	# preverse is the only theme that's not looped 
	if theme=="preverse":
		return next_theme[theme]
	else:
		return theme

func _on_finished():
	_play(queued_theme)
