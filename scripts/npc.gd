class_name Npc
extends Area2D

@onready var npc_sprite: Sprite2D = $NPCSprite
@onready var selected_arrow: Sprite2D = $SelectedArrow

@export var npc_texture: Texture2D
@export var npc_id: NpcData.ID


func _ready() -> void:
	is_selected(false)
	
	if npc_texture:
		npc_sprite.texture = npc_texture


func is_selected(state: bool) -> void:
	selected_arrow.visible = state
