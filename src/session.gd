extends Node
## Session Class Singleton



## Enums
enum StoryProgress {
	NEW_GAME = 0,
	TUTORIAL = 1,
}



## Constants
const NAME = "PongPing"

const VERSION = "0.0.0"

const DEBUGGING = true



## Public Variables
var story_progress : int = StoryProgress.NEW_GAME



## Private Methods
var _new_session : Dictionary



## Built-In Virtual Methods
func _ready() -> void:
	_new_session = _get_session().duplicate(true)
	load_session()


func _exit_tree() -> void:
	save_session()



## Public Methods
func save_session(path := "user://" + NAME + "session.save") -> void:
	var save := File.new()
	var opened := save.open(path, File.WRITE)
	if opened == OK:
		var session := _get_session()
		
		if DEBUGGING:
			print(session)
		save.store_string(to_json(session))
		save.close()


func load_session(path := "user://" + NAME + "session.save") -> void:
	var session := {}
	var save = File.new()
	var opened = save.open(path, File.READ)
	if opened == OK:
		var result := JSON.parse(save.get_as_text())
		if result.error == OK and typeof(result.result) == TYPE_DICTIONARY:
			session = result.result
		save.close()
	
	if DEBUGGING:
		print(session)
	if session.empty():
		return
	else:
		_set_session(session)


func reset() -> void:
	_set_session(_new_session.duplicate(true))
	save_session()



## Private Methods
func _get_session() -> Dictionary:
	var session := {
		"NAME": NAME,
		"VERSION": VERSION,
	}
	
	for property in get_property_list():
		if property["usage"] == 8192\
				and not (property["name"].begins_with("_")):
			session[property["name"]] = get(property["name"])
	
	return session


func _set_session(session : Dictionary) -> void:
	if session.get("NAME", "") != NAME\
			or session.get("VERSION", "") != VERSION:
		return
	
	for property in session:
		set(property, session[property])
