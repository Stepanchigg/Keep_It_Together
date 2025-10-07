class_name BlockDeathBlock 
extends Node2D

var damage = 100
var instal_kill = true

func _ready():
	connect('body_entered', _on_body_entered)
	
func _on_body_entered(body):
	if body.is_in_group('player') or body.name == 'Player':
		if body.has_method('take_damage'):
				body.die()
