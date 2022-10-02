#class_name PausePopup
extends Popup
# Docstring

#signal resume()
signal quit_level()
signal reload_level()


func popup(bounds: Rect2 = Rect2( 0, 0, 0, 0 )) -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	.popup(bounds)
	get_tree().set_pause(true)


func _on_btn_resume_pressed() -> void:
	_close()


func _on_btn_settings_pressed() -> void:
	$SettingsPopup.popup()


func _on_btn_controls_pressed() -> void:
	$ControlsPopup.popup()


func _on_btn_quit_pressed() -> void:
	_close()
	emit_signal("quit_level")


func _close() -> void:
	get_tree().set_pause(false)
	set_visible(false)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _on_btn_retry_pressed() -> void:
	get_tree().set_pause(false)
	emit_signal("reload_level")
