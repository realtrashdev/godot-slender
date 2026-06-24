class_name SaveSystem


static func write(path: String, data: Dictionary) -> void:
	var file = FileAccess.open(path, FileAccess.WRITE)
	if file:
		file.store_var(data)
		file.close()
	else:
		push_error("Failed to save: %s" % path)


static func read(path: String) -> Dictionary:
	if not FileAccess.file_exists(path):
		return {}
	var file = FileAccess.open(path, FileAccess.READ)
	if not file:
		push_error("Failed to open: %s" % path)
		return {}
	var data = file.get_var()
	file.close()
	if typeof(data) != TYPE_DICTIONARY:
		push_error("Save corrupted: %s" % path)
		return {}
	return data
