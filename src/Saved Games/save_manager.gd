extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func save_game(id: int):
	print("Saving game...")
	var save_file = FileAccess.open("user://SaveFile" + str(id)+ ".save", FileAccess.WRITE)
	var save_nodes = get_tree().get_nodes_in_group("Saved Info")
	
	for node in save_nodes:
		
		# check the node is an instanced scene
		if node.scene_file_path.is_empty():
			print("persistent node '%s' is not an instanced scene, skipped" % node.name)
			continue
		
		#check if node has save function
		if !node.has_method("save"):
			print("persistent node '%s' is missing a save() function, skipped" % node.name)
			continue
			
		# call the node's save function
		var node_data = node.call("save")
		
		# JSON provides a static method to serialized JSON string
		var json_string = JSON.stringify(node_data)
		
		# store the save dictionary as a new line in the save file
		save_file.store_line(json_string)
	print("Game saved!")


func load_game(id: int):
	if not FileAccess.file_exists("user://SaveFile" + str(id)+ ".save"):
		return # no save to load

	# reset game info
	#GameInfo.reset_info()

	# load the file line by line and process the dictionary to restore the object it represents
	var save_file = FileAccess.open("user://SaveFile" + str(id)+ ".save", FileAccess.READ)
	while save_file.get_position() < save_file.get_length():
		var json_string = save_file.get_line()

		# helps with interacting with JSON
		var json = JSON.new()

		# check if there is any error while parsing the JSON string, skip in case of failure
		var parse_result = json.parse(json_string)
		if not parse_result == OK:
			print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
			continue

		# get data from the JSON object
		var node_data = json.data

		# set variables	
		for i in node_data.keys():
			if node_data[i] is Dictionary:
				
				GameInfo.set_dict(i, node_data[i])
			else:
				GameInfo.set(i, node_data[i])
	# load inventory
	GameInfo.inventory.load_inv()
