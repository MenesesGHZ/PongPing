extends CanvasLayer
## Settings Logic



## OnReady Variables
onready var color_rect : ColorRect = get_node("ColorRect")

onready var exit : Button = get_node("ColorRect/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/Exit")



## Built-In Virtual Methods
func _ready() -> void:
	color_rect.visible = false


func _process(delta : float) -> void:
	if Input.is_action_just_released("ui_cancel"):
		toggle()



## Public Methods
func toggle() -> void:
	if color_rect.visible:
		hide()
	else:
		show()


func show() -> void:
	exit.visible = Session.get_currect_view() != Session.Views.MAIN_MENU
	
	get_tree().paused = true
	color_rect.visible = true


func hide() -> void:
	get_tree().paused = false
	color_rect.visible = false



## Private Methods
func _on_Close_pressed():
	hide()


func _on_Exit_pressed():
	Session.load_main_menu()
	hide()
