extends Node

enum Roles {
	NO_ROLE,
	SHOPKEEPER,
	CONSTRUCTION_WORKER
}

var names: Dictionary = {
	Roles.NO_ROLE: "",
	Roles.SHOPKEEPER: "Hazel",
	Roles.CONSTRUCTION_WORKER: "Laurence",
}

var lines = {
	Roles.SHOPKEEPER: [
		{
			"speaker": "",
			"line": ""
		},
		{
			"speaker": "",
			"line": ""
		},
	],
	
	Roles.CONSTRUCTION_WORKER: [
		{
			"speaker": "",
			"line": ""
		},
		{
			"speaker": "",
			"line": ""
		},
		{
			"speaker": "",
			"line": ""
		},
	]
}
