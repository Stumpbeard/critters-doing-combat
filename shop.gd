extends TextureRect

var level_info = {"level": 1, "to_next_level": 1, "hp": 0, "strength": 0, "speed": 0, "kill_dollars": 0}
var level_up_scene = preload("res://level_up_pop_up.tscn")
var player_scene = preload("res://ratler.tscn")

var player

func _ready():
	$ShopBuyMenu.scale = Vector2(0, 0)
	player = player_scene.instantiate()
	player.position = Vector2(1076, 600)
	player.in_shop_mode = true
	add_child(player)

func _on_typing_text_text_done_displaying():
	show_shop_menu()


func show_shop_menu():
	create_tween().tween_property($ShopBuyMenu, "scale", Vector2(1, 1), 0.5).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)

func set_player_info(new_level_info, heals):
	level_info = new_level_info
	$ShopBuyMenu.set_player_info(new_level_info, heals)

func level_up_critter():
	player.level_up()
	var level_up_pop = level_up_scene.instantiate()
	level_up_pop.position = player.position
	add_child(level_up_pop)

func _on_shop_buy_menu_bought_hp():
	level_up_critter()


func _on_shop_buy_menu_bought_strength():
	level_up_critter()


func _on_shop_buy_menu_bought_speed():
	level_up_critter()
