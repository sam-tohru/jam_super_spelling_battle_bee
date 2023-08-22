extends Node2D

@onready var won = $"."
@onready var firework_1 = $firework_1
@onready var firework_2 = $firework_2
@onready var firework_3 = $firework_3
@onready var firework_4 = $firework_4

@onready var won_background = $background_particles
@onready var won_label = $Label

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("skip"): player_won_animation()

func player_won_animation():
	won.visible = true
	won_background.emitting = true
	var tween = create_tween()
	tween.tween_property(won_label, 'scale', Vector2(1.2, 1.2), 0.2)
	tween.tween_property(won_label, 'scale', Vector2(1.0, 1.0), 0.1)
	
	await get_tree().create_timer(0.8).timeout
	globs.emit_signal('sfx_firework')
	firework_1.emitting = true
	await get_tree().create_timer(0.8).timeout
	globs.emit_signal('sfx_firework')
	firework_2.emitting = true
	await get_tree().create_timer(0.8).timeout
	globs.emit_signal('sfx_firework')
	firework_3.emitting = true
	await get_tree().create_timer(0.8).timeout
	globs.emit_signal('sfx_firework')
	firework_1.emitting = true
	await get_tree().create_timer(0.8).timeout
	globs.emit_signal('sfx_firework')
	firework_2.emitting = true
	await get_tree().create_timer(0.8).timeout
	globs.emit_signal('sfx_firework')
	firework_3.emitting = true
	await get_tree().create_timer(0.8).timeout
	globs.emit_signal('sfx_firework')
	firework_4.emitting = true
	globs.emit_signal('sfx_firework')
	firework_1.emitting = true
	await get_tree().create_timer(0.8).timeout
	globs.emit_signal('sfx_firework')
	firework_2.emitting = true
	await get_tree().create_timer(0.8).timeout
	globs.emit_signal('sfx_firework')
	firework_3.emitting = true
	await get_tree().create_timer(0.8).timeout
	globs.emit_signal('sfx_firework')
	firework_1.emitting = true
	await get_tree().create_timer(0.8).timeout
	globs.emit_signal('sfx_firework')
	firework_2.emitting = true
	await get_tree().create_timer(0.8).timeout
	globs.emit_signal('sfx_firework')
	firework_3.emitting = true
	await get_tree().create_timer(0.8).timeout
	globs.emit_signal('sfx_firework')
	firework_4.emitting = true
	won_background.emitting = false
	await get_tree().create_timer(0.8).timeout
	var new_tween = create_tween()
	new_tween.tween_property(won_label, 'scale', Vector2(0.1, 0.1), 0.5)
	won.visible = false
	
