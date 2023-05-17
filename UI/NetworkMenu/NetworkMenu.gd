extends Control

@onready var host_lan_button = $MarginContainer/VBoxContainer/HostLANButton
@onready var host_wan_button = $MarginContainer/VBoxContainer/HostWANButton
@onready var join_button = $MarginContainer/VBoxContainer/JoinButton
@onready var address_field = $MarginContainer/VBoxContainer/AddressField
@onready var local_ip_label = $MarginContainer/VBoxContainer/MarginContainer/VBoxContainer/HBoxContainer/LocalIPLabel
@onready var public_ip_label = $MarginContainer/VBoxContainer/MarginContainer/VBoxContainer/HBoxContainer2/PublicIPLabel
@onready var error_label = $MarginContainer/VBoxContainer/ErrorLabel
@onready var correct_label = $MarginContainer/VBoxContainer/CorrectLabel
@onready var local_button = $MarginContainer/VBoxContainer/LocalButton

signal hosting(wan: bool)
signal joining(host_address_and_port: String)
signal localing

@onready var joining_address : String

var local_ip = null :
	set(ip):
		local_ip = ip
		local_ip_label.text = ip

var public_ip = null :
	set(ip):
		public_ip = ip
		public_ip_label.text = ip

func _ready():
	Events.server_port_updated.connect(_on_server_port_updated)
	local_ip = NetworkTools.get_local_ipv4()
	public_ip = await NetworkTools.get_public_ip()

## Update displayed local ip address each time the server port is updated
## while upnp is looking for an available port
func _on_server_port_updated(_server_port: int):
	local_ip = NetworkTools.get_local_ipv4()

func _on_host_lan_button_pressed():
	print('hosting_lan')
	hosting.emit(false)

func _on_host_wan_button_pressed():
	print('hosting_wan')
	hosting.emit(true)
	
func _on_join_button_pressed():
	if not address_field.visible:
		join_button.disabled = true
		host_lan_button.disabled = true
		host_wan_button.disabled = true
		local_button.disabled = true
		address_field.show()
		address_field.grab_focus()

func _on_local_button_pressed():
	print('localing')
	localing.emit()


func _on_line_edit_text_submitted(new_text):
	error_label.visible = false
	correct_label.visible = false
	if NetworkTools.is_valid_address(new_text):
		correct_label.visible = true
		joining_address = new_text
		joining.emit(joining_address)
		print('joining ' + joining_address)
	else:
		error_label.visible = true
		print("Incorrect address")

func _on_address_field_focus_exited():
	address_field.hide()
	join_button.disabled = false
	host_lan_button.disabled = false
	host_wan_button.disabled = false
	local_button.disabled = false
	error_label.visible = false
	correct_label.visible = false

func _on_address_field_gui_input(event):
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_ESCAPE:
			address_field.release_focus()
			join_button.grab_focus()
