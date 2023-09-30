extends Critter

var rodent_ceo_image = preload("res://rodent-ceo.png")
var bird_ceo_image = preload("res://bird-ceo.png")
var trash_ceo_image = preload("res://trash-ceo.png")

var ceo_type = "rodent"


func change_image():
	match ceo_type:
		"rodent":
			texture = rodent_ceo_image
			status_types = [Types.DEVIL, Types.RODENT]
		"bird":
			texture = bird_ceo_image
			status_types = [Types.DEVIL, Types.BIRD]
		"trash":
			texture = trash_ceo_image
			status_types = [Types.DEVIL, Types.TRASH]
	set_hover_info()


func change_type():
	var old_ceo_type = ceo_type
	while ceo_type == old_ceo_type:
		var roll = randi() % 3
		match roll:
			0:
				ceo_type = "rodent"
			1:
				ceo_type = "bird"
			2:
				ceo_type = "trash"
	var tween = create_tween()
	tween.tween_property(self, "rotation_degrees", 180, 0.1)
	tween.tween_callback(change_image)
	tween.tween_property(self, "rotation_degrees", 360, 0.1)
	tween.tween_callback(set_rotation_degrees.bind(0))
	
func attack():
	var attacked = super.attack()
	if attacked:
		var roll = randi() % 4
		if roll == 0:
			change_type()
