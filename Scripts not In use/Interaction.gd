extends RayCast

var current_collider

onready var interaction_label = get_node("/root/Game/UI/InteractionLabel")

func _ready():
	set_interaction_text("")

func _process(delta):
	var collider = get_collider();
	
	
	if collider != null:
		if is_colliding() and collider.is_in_group("Interactable"):
		
			if current_collider != collider:
				set_interaction_text("Interact")
				current_collider = collider
		
			if Input.is_action_just_pressed("Interact"):
				set_interaction_text("")
			
		elif current_collider:
			current_collider = null
			set_interaction_text("")
	else:
		set_interaction_text("");


func set_interaction_text(text):
	if !text:
		interaction_label.set_text("")
		interaction_label.set_visible(false)
	else:
		
		interaction_label.set_text("Press E to %s" % [ text])
		interaction_label.set_visible(true)
