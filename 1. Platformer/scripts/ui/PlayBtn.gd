extends Button

export(String, FILE) var to_scene_path: = ""

func _on_button_up () -> void:
	get_tree ().change_scene (to_scene_path)

func _get_configuration_warning () -> String:
	return "You need to provide a \"to_scene_path\"" if to_scene_path == "" else ""
