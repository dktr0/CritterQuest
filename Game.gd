extends Spatial

# This is the top-level script for the permanent Game.tscn scene/node
# All logic that keeps track of what has happened in the game,
# what should happen when specific objects are interacted with,
# and effects the changing of levels (which are children of this node)

var cabinPath = "res://levels/Cabin Cut Scene-KennedyG/MAINSCENE.tscn";
var beachPath = "res://levels/Beach - LeoJ/Beach Level.tscn";
var icePath = "res://levels/Ice Level - Jacob Grobe/IceLevel.tscn";
var treetopPath = "res://levels/Treetop Level Design - Frances/Game (1).tscn";
var forestPath = "res://levels/Forest Level-Amanda/Game.tscn";
var skyPath = "res://levels/Sky - Mikaela/Sky Biome March.tscn";

onready var cabinNavMesh = preload("res://NavMeshes/MainSceneNavMesh.tscn");
onready var beachNavMesh = preload("res://NavMeshes/BeachNavMesh.tscn");
onready var iceNavMesh = preload("res://NavMeshes/IceLevelNavMesh.tscn");
onready var forestNavMesh = preload("res://NavMeshes/ForesLevelNavMesh.tscn");
onready var treetopNavMesh = preload("res://NavMeshes/TreeTopNavMesh.tscn");

onready var cabinAudio = preload("res://levels/Cabin Cut Scene-KennedyG/CabinPositionalAudio.tscn");
onready var treetopAudio = preload("res://levels/Treetop Level Design - Frances/TreeTopPositionalAudio.tscn");
onready var skyAudio = preload("res://levels/Sky - Mikaela/SkyPositionalAudio.tscn");

var cabinScene;
var beachScene;
var iceScene;
var treetopScene;
var forestScene;
var skyScene;

var targetLevel;
var targetPosition;
var backgroundLoader;
var backgroundLoadPath;
var backgroundLoadWait;
var backgroundLoadBlockTime = 0.030;
var backgroundLoadedScene;
var fadeOutEnded = true;

onready var playerScene = preload("res://GeneralPlayer.tscn");
onready var balloonPlayerScene = preload("res://BalloonPlayer.tscn");
var player;
var levelIndex = 0;
var levelNode;

onready var dialogue = $Dialogue;
onready var narrativeLogic = $NarrativeLogic;

# functions meant to be called from Player, level or NPC scripts (just one = interactWithObject)

func interactWithObject(nameOfObject):
	narrativeLogic.interactWithObject(nameOfObject);
	
func teleportEntered(teleportName,body):
	if body.name.count("Player") > 0:
		narrativeLogic.teleportEntered(teleportName);
		
func teleportExited(teleportName,body):
	if body.name.count("Player") > 0:
		narrativeLogic.teleportExited(teleportName);


# functions meant to be called from/by NarrativeLogic.gd

func deliverDialogue(lines):
	dialogue.displayDialogue(lines);
	
func triggerLevelChange(newLevelIndex,positionInLevel=null):
	fadeOut();
	#$FadeOutTimer.start();
	targetLevel = newLevelIndex;
	targetPosition = positionInLevel;
	changeLevel(newLevelIndex,positionInLevel);


# functions called by the engine

func _ready():
	changeLevel(1);

func _process(time):
	processBackgroundLoading();
	if backgroundLoadedScene != null && fadeOutEnded:
		setupLoadedLevel();
		backgroundLoadPath = null;
		backgroundLoadedScene = null;
		fadeIn();

func _physics_process(delta):
	get_tree().call_group("Follower", "update_target_location", getPlayerPosition());
	# note: all of these keyboard shortcuts are just for testing things
	if Input.is_action_just_pressed("first_level"):
		triggerLevelChange(1);
	if Input.is_action_just_pressed("second_level"):
		triggerLevelChange(2);
	if Input.is_action_just_pressed("third_level"):
		triggerLevelChange(3);
	if Input.is_action_just_pressed("fourth_level"):
		triggerLevelChange(4);
	if Input.is_action_just_pressed("fifth_level"):
		triggerLevelChange(5);
	if Input.is_action_just_pressed("sixth_level"):
		triggerLevelChange(6);
	if Input.is_action_just_pressed("fullscreen"):
		OS.set_window_fullscreen(!OS.window_fullscreen);
	if Input.is_action_just_pressed("restart_level"):
		triggerLevelChange(levelIndex);
	if Input.is_action_just_pressed("restart_game"):
		get_tree().change_scene("res://Start Screen Stuff/StartMenu.tscn");


# functions used internally by this script (not meant to be called from elsewhere)

func getPlayerPosition():
	if player != null:
		return player.global_transform.origin;
	else:
		return Vector3(0,0,0);

func changeLevel(n,p=null):
	if n == 1:
		instanceLevel(1,cabinPath,p);
	elif n == 2:
		instanceLevel(2,beachPath,p);
	elif n == 3:
		instanceLevel(3,icePath,p);
	elif n == 4:
		instanceLevel(4,forestPath,p);
	elif n == 5:
		instanceLevel(5,treetopPath,p);
	elif n == 6:
		instanceLevel(6,skyPath,p);

func instanceLevel(n,path,p=null):
	targetLevel = n;
	if(n == 1 && cabinScene != null):
		backgroundLoadedScene = cabinScene;
	elif(n == 2 && beachScene != null):
		backgroundLoadedScene = beachScene;
	elif(n == 3 && iceScene != null):
		backgroundLoadedScene = iceScene;
	elif(n == 4 && forestScene != null):
		backgroundLoadedScene = forestScene;
	elif(n == 5 && treetopScene != null):
		backgroundLoadedScene = treetopScene;
	elif(n == 6 && skyScene != null):
		backgroundLoadedScene = skyScene;
	else: # scene hasn't already been loaded, needs to be background loaded
		print("starting background loading of new level " + path);
		loadNewScene(path);
	
func setupLoadedLevel():
	if levelNode != null:
		print("deleting previous level");
		levelNode.queue_free();
	# find and delete any existing Player scene
	if player != null:
		print('deleting previous GeneralPlayer');
		player.queue_free();
		player = null;
	print("instancing level " + str(targetLevel));
	levelNode = backgroundLoadedScene.instance();
	levelIndex = targetLevel;
	# delete level designers' private nodes that would get in the way
	findAndFree(levelNode,"Camera");
	findAndFree(levelNode,"balloon");
	findAndFree(levelNode,"HotAirBalloon");
	# instance the new General or BalloonPlayer
	if levelIndex > 1 && levelIndex < 6: # for all levels except sky level
		print("level index is not 6, instancing GeneralPlayer");
		player = playerScene.instance(); # make a new GeneralPlayer
	elif levelIndex == 6:
		print("level index is 6, instancing BalloonPlayer");
		player = balloonPlayerScene.instance();
	if levelIndex == 1:
		if !narrativeLogic.hasTalkedBird: # beginning of game
			print("beginning of game, going with GeneralPlayer");
			player = levelNode.get_node("GeneralPlayer");
			print("isBalloonPlayer: " + str(player.isBalloonPlayer));
			findAndFree(levelNode,"GeneralPlayer2");
		else: # end of game
			print("end of game (has talked to bird), going with GeneralPlayer2");
			player = levelNode.get_node("GeneralPlayer2");
			print("isBalloonPlayer: " + str(player.isBalloonPlayer));
			findAndFree(levelNode,"GeneralPlayer");
	else:
		# see if the level has an existing player object to get position and size
		var tempPlayer;
		tempPlayer = levelNode.get_node_or_null("GeneralPlayer");
		if tempPlayer == null:
			tempPlayer = levelNode.get_node_or_null("Player");
		if tempPlayer == null:
			tempPlayer = levelNode.get_node_or_null("BalloonPlayer");
		# if we found a player object in the level, copy its position etc and delete it
		if tempPlayer != null:
			print("found temporary player in loaded level; copying transform then deleting...")
			player.transform = tempPlayer.transform;
			if targetPosition != null: # if a specific position was provided when this function was called
				player.position = targetPosition;
			print(" translation: " + str(player.translation));
			print(" scale: " + str(player.scale));
			tempPlayer.queue_free();
		else:
			print("hmmm... no player instance found in loaded level (will spawn at 0,0,0)");
		add_child(player);
	player.set_name("Player");
	injectNavMesh();
	injectPositionalAudio();
	tweakLevel();
	print("adding new level to Game node");
	add_child(levelNode);
	signalLevelEntry();
	
func findAndFree(parentNode,path):
	var nodeToFree = parentNode.get_node_or_null(path);
	if nodeToFree != null:
		print("deleting node " + path);
		nodeToFree.queue_free();

func fadeOut():
	$FadeAnimationPlayer.play("fadeout");
	$FadeOutTimer.start();
	fadeOutEnded = false;
	
func fadeIn():
	$FadeAnimationPlayer.play("fadein");
	
func _on_FadeOutTimer_timeout():
	print("fade out ended");
	fadeOutEnded = true;

func loadNewScene(path):
	backgroundLoader = ResourceLoader.load_interactive(path);
	if backgroundLoader == null:
	  print("unable to create loader (possibly invalid path to resource) for: " + path);
	  return;
	backgroundLoadWait = 1;
	backgroundLoadPath = path;
	backgroundLoadedScene = null;

func processBackgroundLoading():
	if backgroundLoader == null: # not currently background loading a scene
		return;
	if backgroundLoadWait > 0: # allow at least one frame to pass before polling
		backgroundLoadWait -= 1;
		return;
	var t = OS.get_ticks_msec();
	while OS.get_ticks_msec() < t + backgroundLoadBlockTime:
		var err = backgroundLoader.poll()
		if err == ERR_FILE_EOF: # Finished loading.
			print("finished loading " + backgroundLoadPath);
			backgroundLoadedScene = backgroundLoader.get_resource();
			backgroundLoader = null;
			if targetLevel == 1:
				print("storing cabin scene");
				cabinScene = backgroundLoadedScene;
			elif targetLevel == 2:
				print("storing beach scene");
				beachScene = backgroundLoadedScene;
			elif targetLevel == 3:
				print("storing ice scene");
				iceScene = backgroundLoadedScene;
			elif targetLevel == 4:
				print("storing forest scene");
				forestScene = backgroundLoadedScene;
			elif targetLevel == 5:
				print("storing treetop scene");
				treetopScene = backgroundLoadedScene;
			elif targetLevel == 6:
				print("storing sky scene");
				skyScene = backgroundLoadedScene;
			break;
		elif err == OK: # normal progress
			break;
		else: # error loading resource
			print("unable to load (possibly error in a dependency): " + backgroundLoadPath);
			backgroundLoader = null;
			backgroundLoadPath = null;
			break;
			
func injectNavMesh():
	if levelIndex == 1:
		levelNode.add_child(cabinNavMesh.instance());
		print("injected nav mesh");
	elif levelIndex == 2:
		levelNode.add_child(beachNavMesh.instance());
		print("injected nav mesh");
	elif levelIndex == 3:
		levelNode.add_child(iceNavMesh.instance());
		print("injected nav mesh");
	elif levelIndex == 4:
		levelNode.add_child(forestNavMesh.instance());
		print("injected nav mesh");
	elif levelIndex == 5:
		levelNode.add_child(treetopNavMesh.instance());
		print("injected nav mesh");
		
func injectPositionalAudio():
	if levelIndex == 1:
		levelNode.add_child(cabinAudio.instance());
		print("injected positional audio");
	elif levelIndex == 5: 
		levelNode.add_child(treetopAudio.instance());
		print("injected positional audio");
	elif levelIndex == 6:
		levelNode.add_child(skyAudio.instance());
		print("injected positional audio");
		
func signalLevelEntry():
	if levelIndex == 1:
		interactWithObject("Entered Cabin Level");
	elif levelIndex == 2:
		interactWithObject("Entered Beach Level");
	elif levelIndex == 3:
		interactWithObject("Entered Ice Level");
	elif levelIndex == 4:
		interactWithObject("Entered Forest Level");
	elif levelIndex == 5:
		interactWithObject("Entered Treetop Level");
	elif levelIndex == 6:
		interactWithObject("Entered Sky Level");
		
func tweakLevel():
	if levelIndex == 1 && narrativeLogic.hasTalkedBird:
		findAndFree(levelNode,"AnimatedCat");
	if levelIndex == 1 && !narrativeLogic.hasTalkedBird:
		findAndFree(levelNode,"NPCs");
	if levelIndex == 2:
		player.jump = 60;

func _on_GameOverTimer_timeout():
	get_tree().change_scene("res://Start Screen Stuff/StartMenu.tscn");
