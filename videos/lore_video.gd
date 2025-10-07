extends Control

var next_scene = preload("res://node_2d.tscn")

func _on_video_stream_player_finished() -> void:
	get_tree().change_scene_to_packed(next_scene)

func _input(event: InputEvent):
	if event.is_action_pressed('enter'):
		get_tree().change_scene_to_packed(next_scene)
