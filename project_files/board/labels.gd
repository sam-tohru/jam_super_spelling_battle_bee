extends Node2D

@onready var top_name = $top_label/top_name
@onready var bot_name = $bot_label/bot_name



# Called when the node enters the scene tree for the first time.
func _ready():
	globs.name_change.connect(top_name_change)
	globs.bot_name_change.connect(bot_name_change)
	globs.end_battle_round.connect(shop_name_change)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func top_name_change(new_name: String):
	top_name.text = new_name
func bot_name_change(new_name: String):
	bot_name.text = new_name
func shop_name_change():
	bot_name.text = 'Shop'
