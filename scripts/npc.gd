class_name Npc
extends Area2D

@onready var npc_sprite: Sprite2D = $NPCSprite

@export var npc_texture: Texture2D
@export var npc_role: NpcNames.Roles = NpcNames.Roles.NO_ROLE

var npc_name: String


func _ready() -> void:
	if npc_texture:
		npc_sprite.texture = npc_texture
	
	npc_name = NpcNames.names[npc_role]
