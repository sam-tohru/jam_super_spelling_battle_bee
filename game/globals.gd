extends Node

signal clear_bot
signal shop_round
signal updated_board

signal clicked_letter
signal move_letter_to_top
signal move_letter_to_bot
signal drop_in_area

signal freeze_button

signal battle_round
signal end_battle_round
signal bot_name_change

signal after_battle_animations

signal menu_screen
signal gun_mode_changed

signal name_change
signal music_volume_changed

signal sfx_woosh
signal sfx_punch
signal sfx_grunt
signal sfx_battle_done
signal sfx_firework
signal fight_animation

signal screen_shake
signal hit_effect

func _ready():
	
	SilentWolf.configure({
		"api_key": "KMHlAKy5bx1JfuRkIWrxo3bhlrPyZR9C10VU6meE",
		"game_id": "letter-battler",
		"game_version": "2",
		"log_level": 1 })
	SilentWolf.configure_scores({
		"open_scene_on_close": "res://scenes/MainPage.tscn" })

func send_word_to_sw(letters_array: Array):
	var full_array = encode_letters(letters_array)
	globvars.sw_letters[globvars.sw_name] = full_array
	var test_data = {"Weapons": full_array, "Money": 23}
	print('SAVING PLAYER WORD: ', globvars.sw_name , ' | ', test_data['Weapons'])
	SilentWolf.Players.save_player_data(globvars.sw_name, test_data)
	
	## all_users are updated also ##
	if globvars.sw_all_users.is_empty(): get_all_users()
	if !globvars.sw_all_users.has(globvars.sw_name):
		globvars.sw_all_users.append(globvars.sw_name)
		var all_users_data = {"Weapons": globvars.sw_all_users, "Money": 23}
		print('UPDATED ALL USERS: ', globvars.sw_all_users_name, ' || ', all_users_data['Weapons'])
		SilentWolf.Players.save_player_data(globvars.sw_all_users_name, all_users_data)

func get_all_users():
	var sw_result = await SilentWolf.Players.get_player_data(globvars.sw_all_users_name).sw_get_player_data_complete
	print("Player data: " + str(sw_result.player_data.Weapons))
	globvars.sw_all_users = sw_result.player_data.Weapons
func get_random_sw_user_data():
	var rand_player = globvars.sw_all_users.pick_random()
	var sw_result = await SilentWolf.Players.get_player_data(str(rand_player)).sw_get_player_data_complete
	print("Player data: " + str(sw_result.player_data.Weapons))
	
	emit_signal('bot_name_change', rand_player)
	
	return sw_result.player_data

func encode_letters(letters_array) -> Array:
	var char_array = []
	var att_array = []
	var hlth_array = []
	var i = 0
	for letter in letters_array:
		if letter == null: continue
		char_array.append(letter.character)
		att_array.append(letter.attack)
		hlth_array.append(letter.health)
	var full_array = [char_array, att_array, hlth_array]
	return full_array
	

################################################################################

func is_real_word(top_array) -> bool:
	var character_array = []
	for letter in top_array:
		if letter == null: continue
		character_array.append(letter.character.to_lower())
	var word = ''.join(character_array)
	## print(word, ' | IN: ', globvars.valid_words.has(word))
	
	if globvars.valid_words.has(word): return true
	return false

