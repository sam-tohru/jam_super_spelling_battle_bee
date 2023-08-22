extends Node2D

@onready var board = $board
@onready var spawn_timer = $board/spawn_timer


@onready var letter = preload("res://letters/letter.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	globs.shop_round.connect(shop_round)
	globs.battle_round.connect(battle_round)
	globs.end_battle_round.connect(end_battle_round)
	
	globs.get_all_users()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func shop_round():
	if board.SETTING_UP: push_error('BOARD ALREADY SETTING UP, SHOP_ROUND') ; return
	board.SETTING_UP = true
	for letter_slot in board.bot_letters:
		if letter_slot == null: ## Also needs to check if not frozen
			await spawn_letter()
	board.SETTING_UP = false

func spawn_letter():
	# ADD NEW LETTER INSTANCE-
	var load_letter = load("res://letters/letter.tscn")
	var letter_instance = load_letter.instantiate()
	letter_instance.position = board.mark_spawn.position
	call_deferred('add_child', letter_instance)
	board.place_letter_onto_board(letter_instance)
	
	spawn_timer.start()
	await spawn_timer.timeout

func spawn_set_letter(let: String, att: int, hlth: int): ## spawns & sets cusom letters (battle round mainly)
	# ADD NEW LETTER INSTANCE
	var load_letter = load("res://letters/letter.tscn")
	var letter_instance = load_letter.instantiate()
	letter_instance.position = board.mark_spawn.position
	
	await call_deferred('add_child', letter_instance)
	
	## SET STATS ##
	# letter_instance.set_letter(let, att, hlth)
	
	board.place_letter_onto_board(letter_instance)
	
	spawn_timer.start()
	await spawn_timer.timeout
	letter_instance.set_letter(let, att, hlth)

func battle_round(): 
	if board.SETTING_UP: push_error('BOARD ALREADY SETTING UP, SHOP_ROUND') ; return
	await board.clear_bot()
	var full_data = await globs.get_random_sw_user_data()
	
	if full_data == null: error_spawn() ; return
	
	full_data = full_data.Weapons
	
	var max_letters = full_data[0].size()
	var i = 0 
	
	board.SETTING_UP = true
	while i < max_letters:
		await spawn_set_letter(full_data[0][i], full_data[1][i], full_data[2][i])
		i += 1
			
	board.SETTING_UP = false
	
	## Battle in board
	board.battle_board()
	
	## ENDS PUT SOMEHWERE ELSE ##
	# end_battle_round()

func error_spawn():
	var max_letters = ['U', 'R', 'B', 'A', 'A']
	var i = 0 
	
	board.SETTING_UP = true
	for letters in max_letters:
		await spawn_set_letter(letters, randi_range(1,8), randi_range(1,8))
		i += 1
			
	board.SETTING_UP = false
	
	## Battle in board
	board.battle_board()

func end_battle_round():
	globvars.MAX_SHOP_STATS = 9
	globs.emit_signal('updated_board')
	board.clear_bot()
	shop_round()
