extends Control

class_name NetworkMenu


@onready var title = $MarginContainer/VBoxContainer/Title
@onready var ip_label = $MarginContainer/VBoxContainer/MarginContainer/VBoxContainer/HBoxContainer/IPLabel
@onready var ip_value = $MarginContainer/VBoxContainer/MarginContainer/VBoxContainer/HBoxContainer/IPValue
@onready var host_button = $MarginContainer/VBoxContainer/HostButton
@onready var join_button = $MarginContainer/VBoxContainer/JoinButton
@onready var address_field = $MarginContainer/VBoxContainer/AddressField
@onready var error_label = $MarginContainer/VBoxContainer/ErrorLabel
@onready var correct_label = $MarginContainer/VBoxContainer/CorrectLabel

@onready var joining_address : String

@onready var exits_dict = {}

@onready var default_focus = host_button

## Choose private (LAN) or public (WAN) networking
@export_enum("LAN", "WAN") var network: String = "LAN"


var ip = null :
	set(new_ip):
		# make the label focusable when ip is set the first time
		if ip == null:
			ip_value.focus_mode = FOCUS_CLICK
			ip_value.selecting_enabled = true
		ip = new_ip
		ip_value.text = new_ip


func _ready():
	match network:
		'LAN':
			Events.server_port_updated.connect(_on_server_port_updated)
			ip_label.text = 'Local IP:'
			title.text = 'LAN'
			ip = NetworkTools.get_local_ipv4()
		'WAN': 
			ip_label.text = 'Public IP:'
			title.text = 'Online'
			ip = await NetworkTools.get_public_ip()


## Update displayed local ip address each time the server port is updated
## while upnp is looking for an available port
func _on_server_port_updated(_server_port: int):
	if network == 'LAN':
		ip = NetworkTools.get_local_ipv4()


func _on_host_button_pressed():
	match network:
		'LAN':
			print('hosting_lan')
			Events.hosting.emit(false)
		'WAN':
			print('hosting_wan')
			Events.hosting.emit(true)


func _on_join_button_pressed():
	if not address_field.visible:
		join_button.disabled = true
		host_button.disabled = true
		address_field.show()
		address_field.grab_focus()


func _on_line_edit_text_submitted(new_text):
	error_label.visible = false
	correct_label.visible = false
	if NetworkTools.is_valid_address(new_text):
		correct_label.visible = true
		joining_address = new_text
		Events.joining.emit(joining_address)
		print('joining ' + joining_address)
	else:
		error_label.visible = true
		print("Incorrect address")

func _on_address_field_focus_exited():
	address_field.hide()
	join_button.disabled = false
	host_button.disabled = false
	error_label.visible = false
	correct_label.visible = false

func _on_address_field_gui_input(event):
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_ESCAPE:
			address_field.release_focus()
			join_button.grab_focus()
