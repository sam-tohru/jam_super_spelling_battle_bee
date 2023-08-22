extends Node2D

@onready var drag_mode = $drag_mode
@onready var mode_label = $drag_mode/mode_label

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_menu_2_pressed():
	self.queue_free()
