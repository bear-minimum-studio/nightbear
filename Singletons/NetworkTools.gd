extends Node

# Emitted when UPnP port mapping setup is completed (regardless of success or failure).
signal upnp_completed

const LOCAL_PORT := 3628

var thread = null
var upnp : UPNP
var is_upnp_completed := false
var server_port := 1024
var local_multiplayer : bool

var ip_regex := RegEx.new()


func _ready():
	# regex to validate both IPV4 and IPV6
	ip_regex.compile("^((([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])$|^(([a-fA-F]|[a-fA-F][a-fA-F0-9\\-]*[a-fA-F0-9])\\.)*([A-Fa-f]|[A-Fa-f][A-Fa-f0-9\\-]*[A-Fa-f0-9])$|^(?:(?:(?:(?:(?:(?:(?:[0-9a-fA-F]{1,4})):){6})(?:(?:(?:(?:(?:[0-9a-fA-F]{1,4})):(?:(?:[0-9a-fA-F]{1,4})))|(?:(?:(?:(?:(?:25[0-5]|(?:[1-9]|1[0-9]|2[0-4])?[0-9]))\\.){3}(?:(?:25[0-5]|(?:[1-9]|1[0-9]|2[0-4])?[0-9])))))))|(?:(?:::(?:(?:(?:[0-9a-fA-F]{1,4})):){5})(?:(?:(?:(?:(?:[0-9a-fA-F]{1,4})):(?:(?:[0-9a-fA-F]{1,4})))|(?:(?:(?:(?:(?:25[0-5]|(?:[1-9]|1[0-9]|2[0-4])?[0-9]))\\.){3}(?:(?:25[0-5]|(?:[1-9]|1[0-9]|2[0-4])?[0-9])))))))|(?:(?:(?:(?:(?:[0-9a-fA-F]{1,4})))?::(?:(?:(?:[0-9a-fA-F]{1,4})):){4})(?:(?:(?:(?:(?:[0-9a-fA-F]{1,4})):(?:(?:[0-9a-fA-F]{1,4})))|(?:(?:(?:(?:(?:25[0-5]|(?:[1-9]|1[0-9]|2[0-4])?[0-9]))\\.){3}(?:(?:25[0-5]|(?:[1-9]|1[0-9]|2[0-4])?[0-9])))))))|(?:(?:(?:(?:(?:(?:[0-9a-fA-F]{1,4})):){0,1}(?:(?:[0-9a-fA-F]{1,4})))?::(?:(?:(?:[0-9a-fA-F]{1,4})):){3})(?:(?:(?:(?:(?:[0-9a-fA-F]{1,4})):(?:(?:[0-9a-fA-F]{1,4})))|(?:(?:(?:(?:(?:25[0-5]|(?:[1-9]|1[0-9]|2[0-4])?[0-9]))\\.){3}(?:(?:25[0-5]|(?:[1-9]|1[0-9]|2[0-4])?[0-9])))))))|(?:(?:(?:(?:(?:(?:[0-9a-fA-F]{1,4})):){0,2}(?:(?:[0-9a-fA-F]{1,4})))?::(?:(?:(?:[0-9a-fA-F]{1,4})):){2})(?:(?:(?:(?:(?:[0-9a-fA-F]{1,4})):(?:(?:[0-9a-fA-F]{1,4})))|(?:(?:(?:(?:(?:25[0-5]|(?:[1-9]|1[0-9]|2[0-4])?[0-9]))\\.){3}(?:(?:25[0-5]|(?:[1-9]|1[0-9]|2[0-4])?[0-9])))))))|(?:(?:(?:(?:(?:(?:[0-9a-fA-F]{1,4})):){0,3}(?:(?:[0-9a-fA-F]{1,4})))?::(?:(?:[0-9a-fA-F]{1,4})):)(?:(?:(?:(?:(?:[0-9a-fA-F]{1,4})):(?:(?:[0-9a-fA-F]{1,4})))|(?:(?:(?:(?:(?:25[0-5]|(?:[1-9]|1[0-9]|2[0-4])?[0-9]))\\.){3}(?:(?:25[0-5]|(?:[1-9]|1[0-9]|2[0-4])?[0-9])))))))|(?:(?:(?:(?:(?:(?:[0-9a-fA-F]{1,4})):){0,4}(?:(?:[0-9a-fA-F]{1,4})))?::)(?:(?:(?:(?:(?:[0-9a-fA-F]{1,4})):(?:(?:[0-9a-fA-F]{1,4})))|(?:(?:(?:(?:(?:25[0-5]|(?:[1-9]|1[0-9]|2[0-4])?[0-9]))\\.){3}(?:(?:25[0-5]|(?:[1-9]|1[0-9]|2[0-4])?[0-9])))))))|(?:(?:(?:(?:(?:(?:[0-9a-fA-F]{1,4})):){0,5}(?:(?:[0-9a-fA-F]{1,4})))?::)(?:(?:[0-9a-fA-F]{1,4})))|(?:(?:(?:(?:(?:(?:[0-9a-fA-F]{1,4})):){0,6}(?:(?:[0-9a-fA-F]{1,4})))?::)))))$")
	upnp_completed.connect(_on_upnp_completed)
	thread = Thread.new()
	thread.start(_upnp_setup)

func _upnp_setup():
	# UPNP queries take some time.
	upnp = UPNP.new()
	
	var discover_result = upnp.discover()
	assert(discover_result == UPNP.UPNP_RESULT_SUCCESS, \
		"UPNP Discover Failed! Error %s" % discover_result)

	assert(upnp.get_gateway() and upnp.get_gateway().is_valid_gateway(), \
		"UPNP Invalid Gateway!")

	while upnp.add_port_mapping(server_port, 0, "NightbearMultiplayer") != UPNP.UPNP_RESULT_SUCCESS \
		and server_port < 65535:
		server_port = server_port + 1
		Events.server_port_updated.emit(server_port)

	upnp_completed.emit()

func _exit_tree():
	# Wait for thread finish here to handle game exit while the thread is running.
	await thread.wait_to_finish()
	upnp.delete_port_mapping(server_port)
	pass

func _on_upnp_completed():
	is_upnp_completed = true


func is_valid_address(address_and_port: String) -> bool:
	var address = get_address(address_and_port)
	var port = get_port(address_and_port)
	return (0 < port and port < 65536) and (is_valid_ip(address) or is_valid_hostname(address))

## Resolves hostname with a preference for ipv4
## return '' if not resolvable
func url_to_ip(url: String) -> String:
	var ipv4 = IP.resolve_hostname(url,IP.TYPE_IPV4)
	var ipv6 = IP.resolve_hostname(url,IP.TYPE_IPV6)
	if ipv4 != '':
		return ipv4
	else:
		return ipv6

func is_valid_hostname(url: String) -> bool:
	return url_to_ip(url) != ''

func is_valid_ip(address: String) -> bool:
	var matched = ip_regex.search(address)
	return matched != null

func get_address(address_and_port: String) -> String:
	return address_and_port.split(":")[0]

## On localhost we don't want to have to precise the port for easier debuging.
## Return 0 on Error
func get_port(address_and_port: String) -> int:
	if get_address(address_and_port) == "localhost": return LOCAL_PORT
	var splits = address_and_port.split(":")
	if splits.size() != 2:
		return 0
	return splits[1].to_int()

## Return all the local ipv4 except 127.0.0.1
func get_local_ipv4_addresses(return_localhost=false):
	var ipv4_addresses = []
	for addr in IP.get_local_addresses():
		if addr.split('.').size() != 4:
			continue
		if (not return_localhost) and (addr == '127.0.0.1'):
			continue
		ipv4_addresses.append(addr)
	return ipv4_addresses

func concatenate_port_and_address(address: String, port: int) -> String:
	return "%s:%d" % [address, port]

func get_local_ipv4():
	return concatenate_port_and_address(get_local_ipv4_addresses()[0], LOCAL_PORT)

func get_public_ip():
	if is_upnp_completed:
		return concatenate_port_and_address(upnp.query_external_address(), server_port)
	await upnp_completed
	return concatenate_port_and_address(upnp.query_external_address(), server_port)
