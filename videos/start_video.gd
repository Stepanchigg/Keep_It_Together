extends Control

var next_scene = preload("res://videos/lore_video.tscn")

func _on_video_stream_player_finished() -> void:
	get_tree().change_scene_to_packed(next_scene)
