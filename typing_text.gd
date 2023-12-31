@tool
extends Label

signal text_done_displaying

@export var text_size = 16
@export var text_color = Color.WHITE
@export var reveal = true
@export var play_sound = false

var ticks = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	if !Engine.is_editor_hint():
		if reveal:
			visible_characters = 0
		if play_sound:
			$Sound.play()
	label_settings.font_size = text_size
	label_settings.font_color = text_color



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if !Engine.is_editor_hint():
		if ticks % 2 == 0 && reveal && visible && visible_ratio < 1.0:
			visible_characters += 1
			if visible_ratio >= 1.0:
				emit_signal("text_done_displaying")
				$Sound.stop()
		ticks += 1
	if Engine.is_editor_hint():
		label_settings.font_size = text_size
		label_settings.font_color = text_color
		
		
func reset():
	visible_characters = 0
	visible_ratio = 0.0
	ticks = 0
	if play_sound:
		$Sound.play()
