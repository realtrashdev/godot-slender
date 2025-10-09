class_name PlayerRestriction extends RefCounted

enum RestrictionType { RADAR, CAMERA_FULL, CAMERA_ANGLE, MOVEMENT_FULL, MOVEMENT_SPRINT, FLASHLIGHT_ANGLE }

var restriction: RestrictionType
var source: String
