extends Node

const MC_NAME: String = "Shujinko"

enum ID {
	NO_ROLE,
	SHOPKEEPER,
	CONSTRUCTION_WORKER
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
			"speaker": MC_NAME,
			"line": "Is that so?"
		},
	],
	
	ID.CONSTRUCTION_WORKER: [
		{
			"speaker": MC_NAME,
			"line": "What's going on?"
		},
		{
			"speaker": names[ID.CONSTRUCTION_WORKER],
			"line": "Of the trees that grow far away in the hills the so-called white oak is the least familiar."
		},
		{
			"speaker": names[ID.CONSTRUCTION_WORKER],
			"line": "Though there is nothing very splendid or unusual about the tree, one always has the illusion that it is covered with snow"
		},
		{
			"speaker": MC_NAME,
			"line": "You guys talk about trees a lot, huh."
		},
	]
}
