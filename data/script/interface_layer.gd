extends CanvasLayer
onready var button = $menu_layer/button/inventory
var menu_use = false
var menu_type = "menu"

func _input(event):
	if event.is_action_pressed("debug_restart"):
		Global.player_data.doors_open = 0
		get_tree().reload_current_scene()
	if event.is_action_pressed("ui_cancel"):
		if !$anim_player.is_playing() and menu_type == "inventory":
			$audio/se/back_main.play()
			$inventory_layer/item_layer/item_list.release_focus()
			$anim_player.play("inventory_close")
			menu_type = "menu"
			yield($anim_player, "animation_finished")
			$menu_layer/button/inventory.grab_focus()
		elif !$anim_player.is_playing() and !menu_use:
			$audio/se/enter_main.play()
			if !Global.game_data.multiplayer:
				get_tree().paused = true
			menu_use = true
			$anim_player.play("menu_open")
			yield($anim_player, "animation_finished")
			$menu_layer/button/inventory.grab_focus()
		elif !$anim_player.is_playing() and menu_use:
			$audio/se/back_main.play()
			if !Global.game_data.multiplayer:
				get_tree().paused = false
			menu_use = false
			$anim_player.play("menu_close")
			yield($anim_player, "animation_finished")
			button.release_focus()

func focus_entered():
	$audio/se/cursor_main.play()
	if $menu_layer/button/inventory.has_focus():
		button = $menu_layer/button/inventory
	elif $menu_layer/button/achivement.has_focus():
		button = $menu_layer/button/achivement
	elif $menu_layer/button/setting.has_focus():
		button = $menu_layer/button/setting
	elif $menu_layer/button/exit.has_focus():
		button = $menu_layer/button/exit
func button_pressed():
	$audio/se/enter_main.play()
	if button.name == "inventory":
		$anim_player.play("inventory_open")
		yield($anim_player, "animation_finished")
		$inventory_layer/item_layer/item_list.grab_focus()
		$inventory_layer/item_layer/item_list.select(0)
		
		
		menu_type = "inventory"
	if button.name == "exit":
		yield($audio/se/enter_main, "finished")
		get_tree().quit()
