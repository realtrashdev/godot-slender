class_name CharacterProfile extends Resource

enum Type {
	NUISANCE, DANGEROUS, LETHAL, # Enemy types
	VESSEL, SOUL, CHARACTER # Vessel types
}

@export_group("Basic Info")
@export var name: String
@export var type: Type
@export_multiline var description: String
@export var icon: Texture2D

@export_group("Unlocking")
@export_multiline var unlock_description: String
@export var locked_icon: Texture2D
