extends Node2D

var linesToDisplay;

# API (functions that can be called from other scripts that use the dialogue system)

func displayDialogue(lines):
	if lines != null:
		if typeof(lines) == TYPE_STRING:
			linesToDisplay = [lines];
		elif typeof(lines) == TYPE_ARRAY:
			linesToDisplay = lines;
		else:
			linesToDisplay = null;
			$Panel.visible = false;
			return;
		displayNextLine();


# signal handlers and functions that respond to engine calls

func _ready():
	$Panel.visible = false;
	
func _physics_process(_delta):
	if Input.is_action_just_pressed("Interact") || Input.is_action_just_pressed("jump"):
		displayNextLine();

func _on_NextButton_pressed():
	displayNextLine();
	pass # Replace with function body.


# other functions used internally by the dialogue system (not to be called externally)
	
func displayNextLine():
	if linesToDisplay == null:
		$Panel.visible = false;
		return;
	var lineToDisplay = linesToDisplay.pop_front();
	if lineToDisplay == null:
		linesToDisplay == null;
		$Panel.visible = false;
		return;
	$"Panel/TextDisplay".text = lineToDisplay;
	if linesToDisplay.size() == 0:
		$"Panel/NextButton".text = "[Close]";
	else:
		$"Panel/NextButton".text = "[More...]";
	$Panel.visible = true;
