extends Area2D

var balloon_scene = preload("res://dialogues/balloon.tscn")
@export var dialogue_resource: DialogueResource
@export var dialogue_start: String = "start"

func action() -> void:
	var balloon = balloon_scene.instantiate()
	get_tree().current_scene.add_child(balloon)
	balloon.start(dialogue_resource, dialogue_start)
