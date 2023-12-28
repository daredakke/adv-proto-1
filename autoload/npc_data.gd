extends Node

const MC_NAME: String = "Shujinko"

#region Portraits
const MC_NORMAL = preload("res://assets/portraits/portrait-normal.png")
const MC_BORED = preload("res://assets/portraits/portrait-bored.png")
const MC_CONFUSED = preload("res://assets/portraits/portrait-confused.png")
const MC_HAPPY = preload("res://assets/portraits/portrait-happy.png")
const MC_TROUBLED = preload("res://assets/portraits/portrait-troubled.png")
#endregion

enum ID {
	NO_ROLE,
	
	# PEOPLE
	SHOPKEEPER,
	CONSTRUCTION_WORKER,
	
	# SIGNS
	TEST_SIGN,
}

var names: Dictionary = {
	ID.NO_ROLE: "",
	ID.SHOPKEEPER: "Hazel",
	ID.CONSTRUCTION_WORKER: "Laurence",
}

var lines: Dictionary = {
	ID.SHOPKEEPER: [
		{
			"speaker": names[ID.SHOPKEEPER],
			"line": "The camphor tends to grow by itself, avoiding clusters of other trees."
		},
		{
			"speaker": names[ID.SHOPKEEPER],
			"line": "There is something rather frightening about its tangled branches, and this estranges one from it."
		},
		{
			"portrait": MC_NORMAL,
			"speaker": MC_NAME,
			"line": "Is that so?"
		},
	],
	
	ID.CONSTRUCTION_WORKER: [
		{
			"portrait": MC_NORMAL,
			"speaker": MC_NAME,
			"line": "What's going on?"
		},
		{
			"speaker": names[ID.CONSTRUCTION_WORKER],
			"line": "Of the trees that grow far away in the hills the so-called white oak is the least familiar."
		},
		{
			"speaker": names[ID.CONSTRUCTION_WORKER],
			"line": "Though there is nothing very splendid or unusual about the tree, one always has the illusion that it is covered with snow."
		},
		{
			"portrait": MC_BORED,
			"speaker": MC_NAME,
			"line": "You guys talk about trees a lot, huh."
		},
		{
			"speaker": names[ID.CONSTRUCTION_WORKER],
			"line": "Talking to " + names[ID.SHOPKEEPER] + " made me appreciate them more."
		},
	],
	
	ID.TEST_SIGN: [
		{
			"speaker": "",
			"line": "This sign is for testing dialogue with inanimate entities."
		},
		{
			"speaker": "",
			"line": "Signs are just nameless NPCs and are useful for representing inanimate objects."
		},
		{
			"portrait": MC_HAPPY,
			"speaker": MC_NAME,
			"line": "Well ain't that neat."
		},
	]
}
