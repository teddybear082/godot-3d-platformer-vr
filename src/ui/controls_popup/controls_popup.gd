extends Popup
signal play_menu_click

func _on_btn_back_pressed() -> void:
	emit_signal("play_menu_click")
	set_visible(false)
