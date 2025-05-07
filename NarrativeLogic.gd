extends Spatial

onready var game = $"/root/Game";

# variables for keeping track of interactions that have happened or not

# cabin level
var enteredCabinLevel = false;
var hasPettedCat = false;
var catRunsAway = false;

# beach level (1st time around)
var enteredBeachLevel = false;
var hasTalkedPolarBear = false;
var collectedScarf = false;
var bearHasScarf = false;

# ice level
var enteredIceLevel = false;
var reachedIce = false;
var hasTalkedMonster = false;
var foundFire = false;
var broughtFire = false;

# beach level (2nd time around)
var reachedBeach = false;
var hasTalkedRabbit = false;
var carrotCount = 0;
var broughtCarrots = false;

# forest level
var hasTalkedSquirrel = false;
var acornCount = 0;
var broughtAcorns = false;

# treetop level
var hasTalkedFox = false;
var foundGoggles = false;
var broughtGoggles = false;

# sky level
var talkToFox = false;
var hasTalkedBird = false;

var birdToBeach = false
var talkToOtters = false

# end of game
var hasTalkedPolarBearEnd = false;
var hasTalkedMonsterEnd = false;
var hasTalkedRabbitEnd = false;
var hasTalkedSquirrelEnd = false;
var hasTalkedFoxEnd = false;
var hasTalkedBirdEnd = false;
var hasTalkedOtterEnd = false;
var hasTalkedPenguinEnd = false;
var hasPetCatEnd = false;

# all of the game's narrative logic goes here

func interactWithObject(nameOfObject):
	print("interactWithObject: " + nameOfObject);
	
	# Cabin Area
	if nameOfObject == "Entered Cabin Level" && !enteredCabinLevel:
		$"/root/Game/Mar20/AnimatedCat/AnimationPlayer".play("CatCutScene");
		enteredCabinLevel = true;
		return;
	if nameOfObject == "AnimatedCat" && !hasPettedCat:
		deliverDialogue(["You pet your cat","It is furry","You: Wait!"]);
		hasPettedCat = true;
		$"/root/Game/Mar20/AnimatedCat/AnimationPlayer".play("CatCutScene2");
		catRunsAway = true;
		return;
		
	# Cabin Area at end of game
	if game.levelIndex == 1 && hasTalkedBird:
		if nameOfObject == "PolarBearCharacterwithscarf" && !hasTalkedPolarBearEnd:
			deliverDialogue("Polar bear: My mom said she’d like to make you a scarf for all your help. What colour would you like, red or green?");
			hasTalkedPolarBearEnd = true;
			checkForEndOfGame();
			return;
		if nameOfObject == "monster" && !hasTalkedMonsterEnd:
			deliverDialogue("Monster: You were right, it is much warmer, and everyone at the beach is so nice to me. I’ve made friends with all the crabs.");
			hasTalkedMonsterEnd = true;
			checkForEndOfGame();
			return;
		if nameOfObject == "bunny" && !hasTalkedRabbitEnd:
			deliverDialogue("Rabbit: The bunnies appreciated all the carrots. They said they were the best they’d ever had.");
			hasTalkedRabbitEnd = true;
			checkForEndOfGame();
			return;
		if nameOfObject == "SquirrelCharacter" && !hasTalkedSquirrelEnd:
			deliverDialogue("Squirrel: Thanks again for helping me get my leaf. Do you think it looks nice?");
			hasTalkedSquirrelEnd = true;
			checkForEndOfGame();
			return;
#		if nameOfObject == "fox with goggles" && !hasTalkedFoxEnd:
#			deliverDialogue("Fox: Being back in the skies is so exciting. If you ever want to join us in one of the planes just say the word.");
#			hasTalkedFoxEnd = true;
#			checkForEndOfGame();
#			return;
		if nameOfObject == "Toucan(Jack)" && !hasTalkedBirdEnd:
			deliverDialogue("Bird: It is very much less windy, I like it around here.");
			hasTalkedBirdEnd = true;
			checkForEndOfGame();
			return;
		if nameOfObject == "OtterCharacter" && !hasTalkedOtterEnd:
			deliverDialogue("Otter: We found so many rocks while we were digging that we started our own collection.");
			hasTalkedOtterEnd = true;
			checkForEndOfGame();
			return;
		if nameOfObject == "penguin" && !hasTalkedPenguinEnd:
			deliverDialogue("Penguin: Sometimes I wonder if I could fly.");
			hasTalkedPenguinEnd = true;
			checkForEndOfGame();
			return;
		if nameOfObject == "CatEnd" && !hasPetCatEnd:
			deliverDialogue("You pet your cat. It is furry.");
			hasPetCatEnd = true;
			checkForEndOfGame();
			return;

	# Beach Level
	if nameOfObject == "Entered Beach Level":
		enteredBeachLevel = true;
		if bearHasScarf: # we must have been here before and completed scarf objective
			print("reentering beach level (scarf objective already completed)");
			$"/root/Game/BEACH LEVEL/bunny".show();
			$"/root/Game/BEACH LEVEL/monster".show();
			game.findAndFree(game.levelNode,"disappears in r2");
			game.findAndFree(game.levelNode,"PolarBearCharacterwithscarf");
		else:
			$"/root/Game/BEACH LEVEL/bunny".hide();
			$"/root/Game/BEACH LEVEL/monster".hide();
		return;
	if nameOfObject == "Jaber_PolarBear" && !hasTalkedPolarBear: # the first scene with the polar bear at the beach
		deliverDialogue(["You: Hello.", "Polar Bear: A human?","I've strayed quite far from my home haven't I?", "You: Your home?", "Polar Bear: Yes. It's icey and cold, nothing like this.", "It's quite warm here and I don't know what I'm standing on.", "You: It's sand.", "Polar Bear: Well sand is very hot and it hurts my paws.", "You: How did you get so far from your home?", "Polar Bear: Well, my mother made me a scarf so that I could keep worm during the night.", "She said, 'it's nice and blue so you'll never lose it', because I lose things often.", "It's really a bad habit of mine, I'm quite forgetful sometimes.", "And I thought 'I'll never lose this scarf', but one day the wind was very strong and blew the scarf right off my neck and across the water.", "So, I came to look for it, but I've been looking for a while and can't find anything.", "You: I'll help you find your scarf", "Polar Bear: Would you? It's blue and it should be somewhere on the shore.","Objective: Find the polar bear's scarf"])
		hasTalkedPolarBear = true;
		return;
	if nameOfObject == "Pbearscarf" && !collectedScarf:
		collectedScarf = true;
		return;
	if nameOfObject == "Jaber_PolarBear" && collectedScarf && !bearHasScarf:
		$"/root/Game/BEACH LEVEL/disappears in r2/Jaber_PolarBear".visible = false;
		var newBear = $"/root/Game/BEACH LEVEL/PolarBearCharacterwithscarf";
		newBear.visible = true;
		bearHasScarf = true;
		deliverDialogue(["Polar bear: Thank you! If it's not too much trouble, could you help me get back to my home?","Objective: Take the polar bear to the ice"]);
		newBear.startFollowing();
		return;
		
	# Ice Level
	if nameOfObject == "Entered Ice Level" && !enteredIceLevel:
		enteredIceLevel = true;
		return;
	if nameOfObject == "PolarBearCharacterwithscarf" && game.levelIndex == 3 && !reachedIce:
		deliverDialogue(["Thank you for your help! If you ever find yourself in need of some nice scarves I'm sure my mom will knit one for you."]);
		reachedIce = true;
		startFollowing("/root/Game/Game/StoryNPCs/PolarBearCharacterwithscarf");
		return;
	if nameOfObject == "monster2" && !hasTalkedMonster && !foundFire:
		deliverDialogue(["Monster: Human! Please help! I have gotten myself stuck.", "You: What can I do?", "Monster: Fire is forbidden here, but the penguins love to break the rules. If you could grab their fire from one of the igloos and bring it here, it should melt the ice enough for me to wiggle out.", "You: Okay, I will be right back.", "Monster: Please hurry. I am starting to lose feeling in my legs.","Objective: Find the big fire for the monster"]);
		hasTalkedMonster = true;
		return;
	if nameOfObject == "Charlton_campfireV6" && !foundFire:
		foundFire = true;
		return;
	if nameOfObject == "monster2" && !broughtFire && foundFire:
		deliverDialogue(["Monster: Thank you for the help human. It is much appreciated.", "You: No problem. How did you get yourself stuck anyways?", "Monster: If it wasn’t painfully obvious, I am quite old.", "In my old age I find myself lulling to sleep often, even when I don’t want to. I believe that I had fallen asleep during my morning walk.", "A cold front must have hit while I was sleeping and gotten me stuck to this wall.", "You: Are you okay now?", "Monster: I'm okay. I hate the cold though.", "These old bones need to be warm. They need to be free. The cold makes me feel brittle, fragile.", "I want to feel like I did in my youth, a long time ago. But I'm stuck here.", "You: Would you ever leave?", "Monster: I haven't gone anywhere in a long time, but I think I'd like to see more. See what else is out there.", "You: I am going back to the shore, where my home is. It’s much warmer if that is somewhere you would like to go.", "Monster: You would take me there?", "You: As long as you don't mind taking the boat back.", "Monster: That is perfectly fine. I shall follow you there.","Objective: Lead the monster to the beach"]);
		# TODO: Monster needs transitioning into the Beach Level here when approaching the transition place.
		broughtFire = true;
		$"/root/Game/Game/NPCs/monster2".visible = false;
		$"/root/Game/Game/Misc Objects/IceBerg".visible = false;
		$"/root/Game/Game/StoryNPCs/monster".visible = true;
		startFollowing("/root/Game/Game/StoryNPCs/monster");
		return;
	
	# Beach Level Two	
	if nameOfObject == "monster" && broughtFire && game.levelIndex == 2 && !reachedBeach:
		deliverDialogue(["Monster: This is quite lovely. I have feeling in my arms again.", "You: The sun really warms up the sand.", "Monster: It is wonderful. Thank you human. You have made this old monster very happy.", "You: You're welcome", "Monster: If you ever need anything, you know where to find me."]);
		reachedBeach = true;
		return;
	
	if game.levelIndex == 2 && nameOfObject == "bunny" && !hasTalkedRabbit:
		# note objective is supposed to be 5 carrots, but with some glitches that's too hard
		deliverDialogue(["You: Hi.", "Rabbit: Hi there, we don’t get many humans around this area.", "You: I live in the cabin over there.", "Rabbit: With the cat right? I’ve met her before, she seems real nice.", "You: She is. Have you seen her around anywhere?", "Rabbit: Sorry, I didn’t see her. I’m sure she’ll come home real soon.", "You: How did you get to the shore?", "Rabbit: I wanted a carrot but there weren’t any around my home.", " I remembered seeing some near the water when I traveled this way with some friends recently so I thought I’d find them, but I got lost. I also never found any carrots.", "I kind of promised that I’d bring some back to the other bunnies but now I’m without any carrots and I can’t find my way home.", "You: I could help you find some carrots.", "Rabbit: Really? If it’s no trouble, that would be really helpful. They grow in grassy patches so they should be somewhere off of the sand.", "You: I’ll have a look around and see if there’s anything.","Objective: Find 3 carrots for the rabbit"]);
		hasTalkedRabbit = true;
		return;
	if game.levelIndex == 2 && nameOfObject.count("Carrot") > 0:
		carrotCount = carrotCount + 1;
		if carrotCount >= 3:
			deliverDialogue("You've collected 3 carrots - take them to the Bunny!");
		return;
	if game.levelIndex == 2 && nameOfObject == "bunny" && hasTalkedRabbit && carrotCount >=3 && !broughtCarrots:
		deliverDialogue(["Rabbit: Thank you for the carrots. Do you know how to get to the forest from here? My friends are probably worried about where I’ve gone.", "You: I can take you there, it’s over in that direction.","Objective: Take the rabbit to the forest"]);
		startFollowing("/root/Game/BEACH LEVEL/bunny");
		broughtCarrots = true;
		return;

#	if nameOfObject == "Rabbit" && !reachedForest:
#		deliverDialogue(["Rabbit: Thanks a lot for the carrot and the ride! If you need anything just let us rabbits know and we will be there right away."]);
#		#Stopping it in the other level even tho I think it wont move. Just in casse
#		stopFollowing("/root/Game/BEACH LEVEL/bunny")
#		reachedForest = true
#		return;
	
	# Forest Level
	if nameOfObject == "Squirrel" && !hasTalkedSquirrel:
		deliverDialogue(["You: Hello", "I don’t mean to bother you but I’m looking for my friend. She’s a cat and I’m not sure where she ran off to.", "Squirrel: I haven't seen a cat.", "You: Okay, thank you for the help.", "You: Are you sure? I can help with the acorns if you need anymore.", "Squirrel:  I need a few more to be able to reach the branch up above.", "It’s been some time since the leaves grew on this great oak tree. I used to live in one that was similar and the leaves remind me of times long ago, so I want to keep one. For memories.", "You: I can find you some acorns.","Objective: Find 8 acorns for the squirrel"]);
		#Hide this squirrel after the interaction and make the other one visible ???
		hasTalkedSquirrel = true
		return;
	if nameOfObject.count("Acorn") > 0:
		acornCount = acornCount + 1;
		if hasTalkedSquirrel && acornCount == 8:
			deliverDialogue("You've found 8 acorns! Objective: return to the Squirrel");
		return;
	if nameOfObject == "Squirrel" && !broughtAcorns && acornCount >=8:
		deliverDialogue(["You: Will these be enough?", "Squirrel: Yes, I think they will be.", "Thank you for helping me. That was very kind of you.", "You: You’re welcome. I hope you like your leaf.", "Squirrel: If it’s possible, could you help us with something else?", "You: What is it?", "Squirrel: We have traveled quite some way and need to get back up to the treetops but we don’t remember the way. Could you help us get back?","Objective: Take the squirrels to the treetops"]);
		startFollowing("/root/Game/Game/Squirrel");
		startFollowing("/root/Game/Game/SquirrelLeaf");
		broughtAcorns = true
		return;

	#This squirrel is in the other level, so hence the squrrelB name again
#	if nameOfObject == "SquirrelB" && !reachedTreetops:
#		deliverDialogue(["Squirrel: Thank you once again. I will keep an eye out for your cat."]);
#		#again in the next level. There is another squirrel in the next level so no need for transitioning of the squirrel
#		reachedTreetops =  true;
#		return;
	
	# Treetops Level
	if nameOfObject == "fox no goggles" && !hasTalkedFox:
		deliverDialogue(["Fox: A human? In the trees? How did you find yourself up here?", "You: Helping a new friend.", "Fox: And how do you like this place so far?", "You: It's very windy.", "Fox: Not windy enough, if you ask me. I’m used to flying high in the sky. Even here I find myself too grounded, not enough adventure.", "You: You like to fly?", "Fox: All the time! I do so with my friends. Sometimes I fly solo. It’s very thrilling.", "But I’m stuck here and can’t get back.", "You: Why are you stuck here?", "Fox: Well, I wear these goggles that help me when I’m flying. Birds are very used to the wind and things but sometimes my eyes can’t handle it.", "They help me see better and keep the wind out of my face, but they fell off my head last time I was flying with my friend. She did a bit of a loop in the sky that I wasn’t ready for and they fell somewhere in the treetops.", "I was hoping I’d find them but I can’t see them anywhere.", "You: I'll look around if you want.", "Fox: You will? Wonderful! It might be hanging from some sort of branch in the trees. Take the bridges around the treetops to look around, but be sure to keep your balance.","Objective: Find the goggles for the fox"]);
		hasTalkedFox = true;
		return;
	if nameOfObject == "fox goggles" && !foundGoggles:
		foundGoggles = true;
		deliverDialogue("You found the goggles! Objective: Return to the Fox.");
		return;
	if nameOfObject == "fox no goggles" && !broughtGoggles && foundGoggles:
		deliverDialogue(["Fox: Thank you for finding these! I can fly high into the sky again! Would you like to come and see? I’m sure my friends would love to share the thrill of flying with you.", "You: Like go to the sky?", "Fox: The clouds. It’s really easy. There’s a hot air balloon at the outskirts of the trees that will take you right up.", "You: Okay, let's go.","Objective: Take hot air balloon to the clouds"]);
		$"/root/Game/TreetopLevel/fox no goggles".visible = false;
		$"/root/Game/TreetopLevel/fox with goggles".visible = true;
		# startFollowing("/root/Game/TreetopLevel/fox with goggles");		
		broughtGoggles = true;
		return;
	if nameOfObject == "hotairballoon_Naomi" && broughtGoggles:
		if broughtGoggles:
			game.triggerLevelChange(6);
		else:
			deliverDialogue("The hot air balloon sits lifeless, without a pilot who knows how to handle it.");
		return;
		
	# Sky Level

	if nameOfObject == "fox in plane" && !talkToFox:
		deliverDialogue(["Fox: See! Isn’t it awesome?", "You: It is awesome.", "Fox: Do you have a fear of heights? I should have asked if you had a fear of heights. If you are afraid of heights then the hot air balloon could take you back, but I can’t imagine why you could do that when there’s still so much to see."]);
		talkToFox = true;
		return;
	
	if nameOfObject == "Toucan(Jack)" && !hasTalkedBird:
		deliverDialogue(["You: Do you not enjoy flying?", "Bird: Not really. I don’t like the wind in my feathers. Once I fell and hit my leg on one of the trees down below.", " I think I’m not really good at flying. I’m sure that sounds weird but sometimes I wish there was somewhere else I could go. I want a place I can just relax, with less wind and where it’s not as cool.", "You: There are plenty of places you could go.", "Bird: I’m kind of scared. Of leaving. Of not finding a place to stay. I don’t want to be left alone anywhere.", "You: I live down by the water in a cabin with my cat. It’s a nice place, warm and less windy.", "Bird: Is it lonely?", "You: No. There are plenty of friends to help you if you want to go.", "Bird: I don't know...", "You: If you're scared of not finding a place to stay there is no need to worry. You will always find a place to belong, even if it's not where you expect to be.", "Bird: You promise that it's nice.", "You: I promise.", "Bird: Okay, let's go to the water.","Objective: Descend with the bird to the beach"]);
		hasTalkedBird = true;
		return;

	# Return to Cabin

	if nameOfObject == "Bird" && !birdToBeach:
		deliverDialogue(["Bird: Wow, you were right, this place is nice.", "You: It is. And you can go down to the water and meet some friends, there are crabs and otters that you can meet.", "Bird: Okay, I will do that. But what will you do now?", "You: I still didn’t find my cat, but I will try to look again tomorrow.", "Bird: Well, thank you for everything. I hope that you find your cat soon."]);
		# deliverDialogue(["It is getting late, tiem to head home"]);
		birdToBeach = true;
		return;
		
	# Non-story NPC dialogue
	
	# Beach level
	if game.levelIndex == 2:
		if nameOfObject == "Jaber_Otter2" || nameOfObject == "Jaber_Otter":
			if !talkToOtters:
				deliverDialogue(["Otter 1: Did you find anything yet?","Otter 2: Not yet. Are you sure they were here?", "Otter 1: Yes, I saw them right here.", "Otter 1: Are you looking for something, human?", "Otter 2: Maybe they want the carrots.", "Otter 1: Well, if we give them our carrots we won’t have any left.", "Otter 2: I’ll keep looking for more.", "Otter 1: Alright. Did you want the carrot?", "You: The rabbit over there was looking for a few.", "Otter 1: Well this is all we have but there’s another over on the rock.", "You: Thanks for the help.", "Otter 2: Wish us luck, I feel something grabbing at my feet."]);
				talkToOtters = true;
				return;
			else:
				randomDialogue(["The crabs on the beach like to pinch. Be careful if you're anywhere near the water.", "I love the sun. I can’t imagine being anywhere else."]);
				return;

	# Ice Level
	if game.levelIndex == 3:
		if nameOfObject == "Snowman" || nameOfObject == "Snowman2" || nameOfObject == "Snowman3" || nameOfObject == "Penguin" || nameOfObject == "Penguin2" || nameOfObject == "PolarBearCharacterwithoutscarf" || nameOfObject == "PolarBearCharacterwithoutscarf2" || nameOfObject == "PolarBearCharacterwithoutscarf3":
			randomDialogue(["Welcome to the ice world. If you find yourself shivering make sure to put on an extra layer.", "I know we’re very far from the rest of the forest, but I like that. It’s always quiet and we have the place to ourselves.", "I wonder what it would be like to visit the forest. I’ve never been but I would like to see the colours of the leaves."]);
			return;

	# Forest Level
	if game.levelIndex == 4 && nameOfObject == "bunny":
		randomDialogue(["Sometimes I find things fall from the trees. Do you think the squirrels are throwing things again?", "Be careful that you don’t get your feet all dirty. After it rains the ground can get very muddy.", "There’s nothing like seeing the colours of the leaves during the fall. The forest is never prettier."]);
		return;

	# Treetop Level
	if game.levelIndex == 5 && nameOfObject == "Jaber_SquirrelNPC":
		randomDialogue(["Sometimes when I walk around these bridges, I get lost.", "It’s nice being up in the trees. You can see everything done below without getting any of the dirt in your paws."]);
		return;

	# Sky Level
	if game.levelIndex == 6 && nameOfObject == "SkyNPC" :
		randomDialogue(["I could watch the airplanes fly around all day long.", "You need to be extra careful around here. Losing your balance could mean ending up in the trees.", "We rarely get visitors around here. It’s tough to get up to the clouds but when we do it’s always a nice surprise."]);
		return;


func teleportEntered(teleportName):
	print("teleportEntered: " + teleportName);
	if teleportName == "CabinToBeach":
		if catRunsAway:
			game.triggerLevelChange(2);
		else:
			print("teleport to beach doesn't work until cat has run away...");
	elif teleportName == "BeachToIce":
		if bearHasScarf && !broughtCarrots:
			game.triggerLevelChange(3);
		else:
			print("teleport to ice doesn't work until bear has scarf...");
	elif teleportName == "BeachToForest":
		if broughtCarrots:
			game.triggerLevelChange(4);
		else:
			print("teleport to forest doesn't work until bunny has been brought 3 carrots...");
	elif teleportName == "IceToBeach":
		if broughtFire:
			game.triggerLevelChange(2);
		else:
			print("teleport to beach doesn't work until monster is rescued...");
	elif teleportName == "ForestToTreetop":
		if broughtAcorns:
			game.triggerLevelChange(5);
		else:
			print("teleport to forest doesn't work until squirrel has been brought 8 acorns...");
	elif teleportName == "SkyToCabin":
		if hasTalkedBird:
			game.triggerLevelChange(1);
		else:
			deliverDialogue("A strong wind keeps you from descending, at the moment.");
	else:
		print("ERROR: unrecognized teleport named");

func teleportExited(teleportName):
	print("teleportExited: " + teleportName);
	# teleportExited doesn't do anything else (yet)
	
func checkForEndOfGame():
	if hasTalkedPolarBearEnd && hasTalkedMonsterEnd && hasTalkedRabbitEnd && hasTalkedSquirrelEnd && hasTalkedBirdEnd && hasTalkedOtterEnd && hasTalkedPenguinEnd && hasPetCatEnd:
		print("game over triggered (countdown...)");
		game.fadeOut();
		game.get_node("GameOverTimer").start();		
	else:
		print("haven't talked to everyone yet...");

# helper functions

func randomDialogue(lines):
	var c = randi() % lines.size();
	deliverDialogue(lines[c]);

func deliverDialogue(lines):
	game.deliverDialogue(lines);

func startFollowing(path):
	var n = get_node(path);
	if n != null:
		n.startFollowing();

func stopFollowing(path):
	var n = get_node(path);
	if n != null:
		n.stopFollowing();
