extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

####################################################################################################

func _on_bot_area_0_input_event(viewport, event, shape_idx):
	if Input.is_action_just_pressed("click_left"):
		if get_parent().focused_letter == null: return
		if get_parent().bot_letters[0] != null: return
		
		globs.emit_signal('move_letter_to_bot', get_parent().focused_letter, 0)

func _on_bot_area_1_input_event(viewport, event, shape_idx):
	if Input.is_action_just_pressed("click_left"):
		if get_parent().focused_letter == null: return
		if get_parent().bot_letters[1] != null: return
		
		globs.emit_signal('move_letter_to_bot', get_parent().focused_letter, 1)

func _on_bot_area_2_input_event(viewport, event, shape_idx):
	if Input.is_action_just_pressed("click_left"):
		if get_parent().focused_letter == null: return
		if get_parent().bot_letters[2] != null: return
		
		globs.emit_signal('move_letter_to_bot', get_parent().focused_letter, 2)

func _on_bot_area_3_input_event(viewport, event, shape_idx):
	if Input.is_action_just_pressed("click_left"):
		if get_parent().focused_letter == null: return
		if get_parent().bot_letters[3] != null: return
		
		globs.emit_signal('move_letter_to_bot', get_parent().focused_letter, 3)

func _on_bot_area_4_input_event(viewport, event, shape_idx):
	if Input.is_action_just_pressed("click_left"):
		if get_parent().focused_letter == null: return
		if get_parent().bot_letters[4] != null: return
		
		globs.emit_signal('move_letter_to_bot', get_parent().focused_letter, 4)

func _on_bot_area_5_input_event(viewport, event, shape_idx):
	if Input.is_action_just_pressed("click_left"):
		if get_parent().focused_letter == null: return
		if get_parent().bot_letters[5] != null: return
		
		globs.emit_signal('move_letter_to_bot', get_parent().focused_letter, 5)

func _on_bot_area_6_input_event(viewport, event, shape_idx):
	if Input.is_action_just_pressed("click_left"):
		if get_parent().focused_letter == null: return
		if get_parent().bot_letters[6] != null: return
		
		globs.emit_signal('move_letter_to_bot', get_parent().focused_letter, 6)
