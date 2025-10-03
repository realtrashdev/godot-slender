class_name CharacterProfile extends Resource

enum Type {
	NUISANCE, DANGEROUS, LETHAL, # Enemy types
	VESSEL, SOUL, # Vessel types
}

@export_group("Basic Info")
@export var name: String = SaveManager.get_player_name()
@export var type: Type
@export_multiline var description: String
@export var icon: Texture2D
