extends Node

class_name SequenceElement

var sequence_element_entity = load("res://World/LevelManagement/SequenceElement.tscn")
var burst_entity = load("res://World/LevelManagement/Burst.tscn")

var id: String
var worlds: Array
var current_index: int
var subsequence: Array
var nb_elements: int
var current_element: SequenceElement
var father: SequenceElement
var father_next_called: bool

func initialize(squence_id: String, element_description: Resource, father_node: SequenceElement, father_worlds: Array) -> void:
	id = squence_id
	worlds = father_worlds
	father = father_node
	father_next_called = (father == null)
	_set_subsequence(element_description)

func _get_entity_for_element(element_description: Resource) -> PackedScene:
	if not element_description is SequenceResource:
		return burst_entity
	else:
		return sequence_element_entity

func _create_element(element_id: String, element_description: Resource) -> SequenceElement:
	var element: SequenceElement
	element = _get_entity_for_element(element_description).instance()
	add_child(element)
	element.initialize(element_id, element_description, self, worlds)
	return element

func _set_subsequence(element_description: Resource) -> void:
	if not element_description is SequenceResource:
		return

	subsequence = []
	if element_description.subsequence.size() == 0:
		nb_elements = -1
	else:
		var element_id := 0
		for sub_element_description in element_description.subsequence:
			subsequence.push_back(_create_element("%s%d" % [id, element_id], sub_element_description))
			element_id += 1
		
		nb_elements = element_id
		_set_current_element(0)

func _set_current_element(element_index: int) -> void:
	current_index = element_index
	if current_index > -1 and current_index < nb_elements:
		current_element = subsequence[current_index]

func end() -> void:
	if element_ended() and father_next_called:
		print("Element %s stopped." % id)
		if father != null:
			father.end()
		_queue_free()

func _queue_free():
	queue_free()

func play(element_index: int) -> void:
	if element_index > -1 and element_index < nb_elements:
		if current_element != null:
			current_element.stop()
		_set_current_element(element_index)
		if current_element != null:
			current_element.start()
	else:
		_father_next()
		end()

func _father_next() -> void:
	if father != null and !father_next_called:
		father_next_called = true
		father.next()

func element_ended() -> bool:
	var all_sub_elements_ended = true
	for sub_element in subsequence:
		if is_instance_valid(sub_element):
			all_sub_elements_ended = all_sub_elements_ended and sub_element.element_ended()
	return all_sub_elements_ended

func next() -> void:
	play(current_index + 1)

func start() -> void:
	print("Element %s started." % id)
	play(0)

func stop() -> void:
	pass
