extends Control

var video = preload("res://_end_video.tscn")

func _input(event: InputEvent):
	if event.is_action_pressed('end'):
		get_tree().change_scene_to_packed(video)
