extends  CharacterBody2D
enum {UP,RIGHT,LEFT}
const sound_walk = preload("res://music/fast-walking-on-a-concrete-surface.mp3")
const sound_jump = preload("res://music/прыжок.mp3")
const sound_death = preload("res://music/смерть от шипов.mp3")
const sound_land = preload("res://music/silent-fall-into-the-sand.mp3")

@onready var anim = $AnimatedSprite2D
var accelerarion = 50
var friction = 40
var speed = 100
var gravity = 980
var jump_velocity = -350
var is_jumping = false
var idle_dir = RIGHT
var health = 100
var respawn_position: Vector2
var is_alive = true
var current_chekpoint_id = -1
var was_in_air = false
@onready var actionable_finder: Area2D = $ActionableFinder
func _ready():
	add_to_group('player')
	respawn_position = global_position

func _unhandled_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("dialogue"):
		var actionables = actionable_finder.get_overlapping_areas()
		if actionables.size() > 0:
			actionables[0].action()
			return

func take_damage(amount):
	if not is_alive:
		return
	health -= amount
	if health <= 0:
		die()

func die():
	if not is_alive:
		return
	is_alive = false
	$AudioStreamPlayer2.stream = sound_death
	anim.play('смерть')
	$AudioStreamPlayer2.play()
	$CollisionShape2D.disabled = false
	$AnimatedSprite2D.visible = true
	await get_tree().create_timer(2.0).timeout
	respawn()

func respawn():
	idle_dir = RIGHT
	global_position = respawn_position
	health = 100
	is_alive = true
	$CollisionShape2D.disabled = false
	$AnimatedSprite2D.visible = true

func set_respawn_position(new_position: Vector2, chekpoint_id: int):
	respawn_position = new_position
	current_chekpoint_id = chekpoint_id

func _physics_process(delta: float) -> void:
	var was_on_floor = is_on_floor()
	if not is_on_floor():
		velocity.y += gravity * delta
	if was_in_air and is_on_floor():
		if is_alive:
			$AudioStreamPlayer2.stream = sound_land
			$AudioStreamPlayer2.play()
			was_in_air = false
	if Input.is_action_pressed('up') and is_on_floor() and was_on_floor:
		if is_alive:
			$AudioStreamPlayer2.stream = sound_jump
			$AudioStreamPlayer2.play()
			up_move()
	if Input.is_action_pressed('right'):
		if is_alive:
			right_move()
	elif Input.is_action_pressed('left'):
		if is_alive:
			left_move()
	else:
		if is_alive:
			idle()
	move_and_slide()

func up_move():
	if is_alive:
		velocity.y = jump_velocity
		was_in_air = true
		anim.play('Прыжок')
		var inpute_dir = Input.get_axis('left', 'right')
		if inpute_dir != 0:
			velocity.x = move_toward(velocity.x, inpute_dir * speed, accelerarion)
			idle_dir = LEFT if inpute_dir < 0 else RIGHT
		else:
			velocity.x = move_toward(velocity.x,0 ,friction)

func right_move():
	if is_alive:
		anim.flip_h = true
		if $AudioStreamPlayer/Timer.time_left == 0 and is_on_floor():
			$AudioStreamPlayer.stream = sound_walk
			$AudioStreamPlayer.pitch_scale = 1.0 + randf_range(-0.5, 0.5)
			$AudioStreamPlayer.play()
			$AudioStreamPlayer/Timer.start()
		if is_on_floor():
			anim.play("хотьба")
		else:
			$AudioStreamPlayer.stop()
		velocity.x = speed
		idle_dir = RIGHT
		
func left_move():
	if is_alive:
		anim.flip_h = false
		if $AudioStreamPlayer/Timer.time_left == 0 and is_on_floor():
			$AudioStreamPlayer.stream = sound_walk
			$AudioStreamPlayer.pitch_scale = 1.0 + randf_range(-0.5, 0.5)
			$AudioStreamPlayer.play()
			$AudioStreamPlayer/Timer.start()
		if is_on_floor():
			anim.play("хотьба")
		else:
			$AudioStreamPlayer.stop()
		velocity.x = -speed
		idle_dir = LEFT

func idle():
	velocity.x = 0
	if is_on_floor():
		match idle_dir:
				RIGHT:
					anim.flip_h = true
					$AudioStreamPlayer.stop()
					anim.play("стоять")
				LEFT:
					anim.flip_h = false
					$AudioStreamPlayer.stop()
					anim.play("стоять")
	else:
		anim.play("Прыжок")
