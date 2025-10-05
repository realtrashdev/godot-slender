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


# Default character desc, removed for now since intro is unimplemented
#
#A blank slate we morphed into something special.
#
#A representation of you in this world.
#
#
#Default stats.
