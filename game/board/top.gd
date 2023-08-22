extends Node2D

@onready var shop_markers = [$mark_0, $mark_1, $mark_2, $mark_3, $mark_4, $mark_5, $mark_6]
@onready var mark_spawn = $mark_spawn

# @onready var top_letters = [null, null, null, null, null, null, null]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func generate_shop_round():
	pass


func _on_top_area_0_input_event(viewport, event, shape_idx):
	if Input.is_action_just_pressed("click_left"):
		if get_parent().focused_letter == null: return
		if get_parent().top_letters[0] != null: return
		
		globs.emit_signal('move_letter_to_top', get_parent().focused_letter, 0)


func _on_top_area_1_input_event(viewport, event, shape_idx):
	if Input.is_action_just_pressed("click_left"):
		if get_parent().focused_letter == null: return
		if get_parent().top_letters[1] != null: return
		
		globs.emit_signal('move_letter_to_top', get_parent().focused_letter, 1)


func _on_top_area_2_input_event(viewport, event, shape_idx):
	if Input.is_action_just_pressed("click_left"):
		if get_parent().focused_letter == null: return
		if get_parent().top_letters[2] != null: return
		
		globs.emit_signal('move_letter_to_top', get_parent().focused_letter, 2)


func _on_top_area_3_input_event(viewport, event, shape_idx):
	if Input.is_action_just_pressed("click_left"):
		if get_parent().focused_letter == null: return
		if get_parent().top_letters[3] != null: return
		
		globs.emit_signal('move_letter_to_top', get_parent().focused_letter, 3)


func _on_top_area_4_input_event(viewport, event, shape_idx):
	if Input.is_action_just_pressed("click_left"):
		if get_parent().focused_letter == null: return
		if get_parent().top_letters[4] != null: return
		
		globs.emit_signal('move_letter_to_top', get_parent().focused_letter, 4)


func _on_top_area_5_input_event(viewport, event, shape_idx):
	if Input.is_action_just_pressed("click_left"):
		if get_parent().focused_letter == null: return
		if get_parent().top_letters[5] != null: return
		
		globs.emit_signal('move_letter_to_top', get_parent().focused_letter, 5)


func _on_top_area_6_input_event(viewport, event, shape_idx):
	if Input.is_action_just_pressed("click_left"):
		if get_parent().focused_letter == null: return
		if get_parent().top_letters[6] != null: return
		
		globs.emit_signal('move_letter_to_top', get_parent().focused_letter, 6)
