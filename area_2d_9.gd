extends Area2D

@onready var VideoSignal = $".."
@onready var VD = $"../VideoStreamPlayer"
var video = preload("res://videos/ШКЯ-Макарошки.ogv")
func _ready():
	connect('body_entered', _on_body_entered)

func _on_body_entered(body):
	get_tree().change_scene_to_packed(video)
