extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
@onready var anim = $AnimatedSprite2D

func _ready() -> void:
	anim.play('стоит')
