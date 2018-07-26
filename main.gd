extends Spatial

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func _process(delta):
	if (Input.is_action_just_pressed("ui_cancel")):
		get_tree().quit()
	if (Input.is_action_just_pressed("ui_custom_restart")):
		get_tree().reload_current_scene()
