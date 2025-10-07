extends Area2D

@export var chekpoint_id = 0

func _ready():
	connect('body_entered', _on_body_entered)

func _on_body_entered(body):
	if body.is_in_group('player'):
		body.set_respawn_position(global_position, chekpoint_id)
