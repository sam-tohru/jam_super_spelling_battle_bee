extends Node2D

## Buttons themselves ##
@onready var refresh = $refresh
@onready var refresh_stats = $refresh/refresh_stats

@onready var menu = $menu
@onready var freeze = $freeze
@onready var freeze_icon = $freeze/freeze_icon
@onready var trash_icon = $freeze/trash_icon
@onready var battle = $battle

@onready var CAN_BATTLE = false


## Sprites ##
@onready var refresh_sprites = [preload("res://resources/buttons/refresh/ref_1.png"), preload("res://resources/buttons/refresh/ref_2.png"), preload("res://resources/buttons/refresh/ref_3.png"), preload("res://resources/buttons/refresh/ref_4.png"), preload("res://resources/buttons/refresh/ref_5.png"), preload("res://resources/buttons/refresh/ref_6.png")]
@onready var refreshPressed_sprites = [preload("res://resources/buttons/refresh/refPressed_1.png"), preload("res://resources/buttons/refresh/refPressed_2.png"), preload("res://resources/buttons/refresh/refPressed_3.png"), preload("res://resources/buttons/refresh/refPressed_4.png"), preload("res://resources/buttons/refresh/refPressed_5.png"), preload("res://resources/buttons/refresh/refPressed_6.png")]
@onready var menu_sprites = [preload("res://resources/buttons/menu/menu_1.png"), preload("res://resources/buttons/menu/menu_2.png"), preload("res://resources/buttons/menu/menu_3.png"), preload("res://resources/buttons/menu/menu_4.png"), preload("res://resources/buttons/menu/menu_5.png"), preload("res://resources/buttons/menu/menu_6.png")]
@onready var menuPressed_sprites = [preload("res://resources/buttons/menu/menuPressed_1.png"), preload("res://resources/buttons/menu/menuPressed_2.png"), preload("res://resources/buttons/menu/menuPressed_3.png"), preload("res://resources/buttons/menu/menuPressed_4.png"), preload("res://resources/buttons/menu/menuPressed_5.png"), preload("res://resources/buttons/menu/menuPressed_6.png")]
@onready var freeze_sprites = [preload("res://resources/buttons/freeze/freeze_1.png"), preload("res://resources/buttons/freeze/freeze_2.png"), preload("res://resources/buttons/freeze/freeze_3.png"), preload("res://resources/buttons/freeze/freeze_4.png"), preload("res://resources/buttons/freeze/freeze_5.png"), preload("res://resources/buttons/freeze/freeze_6.png")]
@onready var freezePressed_sprites = [preload("res://resources/buttons/freeze/freezePressed_1.png"), preload("res://resources/buttons/freeze/freezePressed_2.png"), preload("res://resources/buttons/freeze/freezePressed_3.png"), preload("res://resources/buttons/freeze/freezePressed_4.png"), preload("res://resources/buttons/freeze/freezePressed_5.png"), preload("res://resources/buttons/freeze/freezePressed_6.png")]

@onready var battle_sprites = [preload("res://resources/buttons/battle/battle_1.png"), preload("res://resources/buttons/battle/battle_2.png"), preload("res://resources/buttons/battle/battle_3.png"), preload("res://resources/buttons/battle/battle_4.png"), preload("res://resources/buttons/battle/battle_5.png"), preload("res://resources/buttons/battle/battle_6.png")]
@onready var battlePressed_sprites = [preload("res://resources/buttons/battle/battlePressed_1.png"), preload("res://resources/buttons/battle/battlePressed_2.png"), preload("res://resources/buttons/battle/battlePressed_3.png"), preload("res://resources/buttons/battle/battlePressed_4.png"), preload("res://resources/buttons/battle/battlePressed_5.png"), preload("res://resources/buttons/battle/battlePressed_6.png")]
@onready var battle_label = $battle_label


## Old frame ##
@onready var refresh_old = 0
@onready var menu_old = 0
@onready var freeze_old = 0
@onready var battle_old = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	globs.updated_board.connect(updated_board)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if globs.is_real_word(get_parent().top_letters):
		battle.set_modulate(Color(0.93333333730698, 0.7294117808342, 0.45098039507866))
		battle_label.set_modulate(Color(0.45098039507866, 0.15686275064945, 0.12549020349979))
		CAN_BATTLE = true
	else: 
		battle.set_modulate(Color(0.45098039507866, 0.15686275064945, 0.12549020349979))
		battle_label.set_modulate(Color(0.70588237047195, 0.62745100259781, 0.57647061347961))
		CAN_BATTLE = false


func _on_ani_timer_timeout():
	var refresh_rand = randi_range(0, 5)
	while refresh_rand == refresh_old: refresh_rand = randi_range(0, 5)
	refresh_old = refresh_rand
	
	var menu_rand = randi_range(0,5)
	while menu_rand == menu_old: menu_rand = randi_range(0, 5)
	menu_old = menu_rand
	
	var freeze_rand = randi_range(0, 5)
	while freeze_rand == freeze_old: freeze_rand = randi_range(0, 5)
	freeze_old = freeze_rand
	
	var battle_rand = randi_range(0, 5)
	while battle_rand == battle_old: battle_rand = randi_range(0, 5)
	battle_old = battle_rand
	
	## Changes sprites ##
	refresh.set_texture_normal(refresh_sprites[refresh_rand])
	refresh.set_texture_pressed(refreshPressed_sprites[refresh_rand])
	menu.set_texture_normal(menu_sprites[menu_rand])
	menu.set_texture_pressed(menuPressed_sprites[menu_rand])
	
	freeze.set_texture_normal(freeze_sprites[freeze_rand])
	freeze.set_texture_pressed(freezePressed_sprites[freeze_rand])
	
	battle.set_texture_normal(battle_sprites[battle_rand])
	battle.set_texture_pressed(battlePressed_sprites[battle_rand])


func updated_board():
	refresh_stats.text = str(globvars.MAX_SHOP_STATS)

func _on_refresh_pressed(): # REDUCES MAX_SHOP_STATS HERE BY 1
	if get_parent().SETTING_UP or get_parent().BATTLE_PHASE: return
	
	if globvars.MAX_SHOP_STATS > 1: globvars.MAX_SHOP_STATS -= 1 ; refresh_stats.text = str(globvars.MAX_SHOP_STATS)
	globs.emit_signal('screen_shake', 10, 0.8)
	globs.emit_signal('clear_bot')
	globs.emit_signal('shop_round')



func _on_menu_pressed():
	globs.emit_signal('menu_screen')


func _on_freeze_pressed():
	globs.emit_signal('freeze_button')

@onready var instruct_label = $instruct_label
@onready var instructing_player = false
func _on_battle_pressed():
	if CAN_BATTLE and !get_parent().BATTLE_PHASE: globs.emit_signal('battle_round')
	elif !CAN_BATTLE and !instructing_player: instruct_player()

func instruct_player():
	change_instruct_player(true)
	var tween = create_tween()
	tween.tween_property(instruct_label, 'rotation_degrees', -5, 0.1)
	tween.tween_property(instruct_label, 'visible', true, 0.0)
	tween.tween_property(instruct_label, 'rotation_degrees', randi_range(2,5), 0.15)
	tween.tween_property(instruct_label, 'rotation_degrees', 0, 0.15)
	tween.tween_property(instruct_label, 'rotation_degrees', randi_range(-2,-5), 0.15)
	tween.tween_property(instruct_label, 'rotation_degrees', 0, 0.15)
	tween.tween_property(instruct_label, 'rotation_degrees', randi_range(2,5), 0.15)
	tween.tween_property(instruct_label, 'rotation_degrees', 0, 0.15)
	tween.tween_property(instruct_label, 'rotation_degrees', randi_range(-2,-5), 0.15)
	tween.tween_property(instruct_label, 'rotation_degrees', 0, 0.15)
	tween.tween_property(instruct_label, 'rotation_degrees', randi_range(2,5), 0.15)
	tween.tween_property(instruct_label, 'rotation_degrees', 0, 0.15)
	tween.tween_property(instruct_label, 'rotation_degrees', randi_range(-2,-5), 0.15)
	tween.tween_property(instruct_label, 'rotation_degrees', 0, 0.15)
	tween.tween_property(instruct_label, 'rotation_degrees', randi_range(2,5), 0.15)
	tween.tween_property(instruct_label, 'rotation_degrees', 0, 0.15)
	tween.tween_property(instruct_label, 'rotation_degrees', randi_range(-2,-5), 0.15)
	tween.tween_property(instruct_label, 'rotation_degrees', 0, 0.15)
	tween.tween_property(instruct_label, 'visible', false, 0.0)
	tween.tween_callback(change_instruct_player.bind(false))
func change_instruct_player(go_to: bool): instructing_player = go_to
