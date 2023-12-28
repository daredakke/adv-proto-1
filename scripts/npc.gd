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


func _on_npc_texture_changed() -> void:
	anchor_sprite_to_npc_base()


func anchor_sprite_to_npc_base() -> void:
	var sprite_height: float = npc_sprite.get_rect().size.y
	var npc_height: float = abs(npc_sprite.position.y * 2)
	var new_sprite_y_position: float = (npc_height - sprite_height) * 0.5
	
	npc_sprite.position.y += new_sprite_y_position
