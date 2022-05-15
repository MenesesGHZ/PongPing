extends Control
## MainMenu Logic



## Private Methods
func _on_P1VSP2_pressed():
	Session.load_game_pvp()


func _on_P1VSAI_pressed():
	Session.load_game_pvai()


func _on_AIVSAI_pressed():
	Session.load_game_aivai()


func _on_AIVSAIPlus_pressed():
	Session.load_game_aivaip()


func _on_AIPVSAIP_pressed():
	Session.load_game_aipvaip()


func _on_Settings_pressed():
	Settings.show()


func _on_GitHub_pressed():
	OS.shell_open("https://github.com/MenesesGHZ/PongPing")
