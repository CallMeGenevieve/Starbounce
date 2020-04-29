extends Control


var popup
var current_space_object

func _ready():
	popup = $HBoxContainer/EditSpaceButton.get_popup()
	popup.connect("id_pressed", self, "_on_edit_space_item_pressed")
	$PlanetEditor.hide()


func _on_AccessPauseMenuButton_pressed():
	get_parent().hidden = false
	get_tree().paused = true
	get_parent().get_node("PauseMenuBackground").show()
	get_parent().get_node("VBoxContainer").show()


func _on_MenuButton_about_to_show():
	$HBoxContainer/MenuButton/PopupMenu2.popup()


func _on_edit_space_item_pressed(item_id):
	var item_text = popup.get_item_text(item_id)
	var space_objects = get_parent().get_parent().get_parent().get_node("SpaceObjects")
	
	if item_text == "Create Planet":
		space_objects.simulation_paused = true
		space_objects.edit_mode = 1
		current_space_object = space_objects.create_space_object()
		self.init_editor(
			current_space_object.mass,
			current_space_object.scale.x,
			current_space_object.positional_particles.process_material.color,
			current_space_object.stay_in_place,
			current_space_object.position,
			current_space_object.speed,
			false
		)
		space_objects.apply_simulation_speed_on_particles()
		$PlanetEditor.show()
	elif item_text == "Edit Planet":
		space_objects.simulation_paused = true
		space_objects.edit_mode = 2
		current_space_object = space_objects.all_space_objects[space_objects.active_camera_index]
		space_objects.apply_simulation_speed_on_particles()
		self.init_editor(
			current_space_object.mass,
			current_space_object.scale.x,
			current_space_object.positional_particles.process_material.color,
			current_space_object.stay_in_place,
			current_space_object.position,
			current_space_object.speed,
			true
		)
		$PlanetEditor.show()


func init_space_object():
	current_space_object.mass = $PlanetEditor/VBoxContainer/ObjectMassEdit/Mass.value


func init_editor(mass, scale, trail_colour, static_mode, position, speed, editing):
	$PlanetEditor/VBoxContainer/ObjectMassEdit/Mass.value = mass
	$PlanetEditor/VBoxContainer/ScaleEdit/Scale.value = scale
	$PlanetEditor/VBoxContainer/TrailColourEdit/ColorPickerButton.color = trail_colour
	$PlanetEditor/VBoxContainer/StaticEdit/StaticBox.pressed = static_mode
	$PlanetEditor/VBoxContainer/PosXEdit/PosX.value = position.x
	$PlanetEditor/VBoxContainer/PosYEdit/PosY.value = position.y
	$PlanetEditor/VBoxContainer/SpeedXEdit/SpeedX.value = speed.x
	$PlanetEditor/VBoxContainer/SpeedYEdit/SpeedY.value = speed.y
	
	if editing:
		$PlanetEditor.default_mass = mass
		$PlanetEditor.default_scale = scale
		$PlanetEditor.default_particle_color = trail_colour
		$PlanetEditor.default_behaviour = static_mode
		$PlanetEditor.default_position = position
		$PlanetEditor.default_speed = speed
		$PlanetEditor/VBoxContainer/Buttons/ResetButton.show()


func _on_Mass_value_changed(value):
	current_space_object.mass = value


func _on_Scale_value_changed(value):
	current_space_object.scale.x = value
	current_space_object.scale.y = value


func _on_PosX_value_changed(value):
	current_space_object.position.x = value


func _on_PosY_value_changed(value):
	current_space_object.position.y = value


func _on_SpeedX_value_changed(value):
	current_space_object.speed.x = value


func _on_SpeedY_value_changed(value):
	current_space_object.speed.y = value


func _on_DeleteButton_pressed():
	if current_space_object.identifyer != "HopeShip":
		current_space_object.remove_space_object(current_space_object)
		_on_ApplyButton_pressed()
	else:
		$CantDeleteHopeNotification.show_modal(true)


func _on_ApplyButton_pressed():
	get_parent().get_parent().get_parent().get_node("SpaceObjects").simulation_paused = false
	exit_planet_editor()


func _on_ColorPickerButton_color_changed(color):
	current_space_object.set_trail_colour(color)


func _on_StaticBox_toggled(button_pressed):
	current_space_object.stay_in_place = button_pressed


func _on_CantDeleteHopeNotification_confirmed():
	_on_ApplyButton_pressed()


func _on_ButtonReload_pressed():
	get_tree().change_scene("res://scenes/Space/Space.tscn")


func _on_ButtonMainMenu_pressed():
	get_tree().change_scene("res://scenes/MainMenu/MainMenu.tscn")


func _on_ButtonContinue_pressed():
	$GameOverDialogue.hide()


func _on_ResetButton_pressed():
	current_space_object.mass = $PlanetEditor.default_mass
	current_space_object.scale.x = $PlanetEditor.default_scale
	current_space_object.positional_particles.process_material.color = $PlanetEditor.default_particle_color
	current_space_object.stay_in_place = $PlanetEditor.default_behaviour
	current_space_object.position = $PlanetEditor.default_position
	current_space_object.speed = $PlanetEditor.default_speed
	exit_planet_editor()


func exit_planet_editor():
	get_parent().get_parent().get_parent().get_node("SpaceObjects").edit_mode = 0
	get_parent().get_parent().get_parent().get_node("SpaceObjects").apply_simulation_speed_on_particles()
	$PlanetEditor.hide()
	$PlanetEditor/VBoxContainer/Buttons/ResetButton.hide()
