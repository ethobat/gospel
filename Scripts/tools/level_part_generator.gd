@tool
extends EditorScript

# Collision tags:
# ncl - No collision.
# box - Box collider, occupies a full tile. Used for exterior wall parts.
# wal - Single wall on +X. Used for interior T-junction parts.
# str - Two walls on +X and -X. Used for straight corridors. can be walked through.
# crn - Two walls on +X and +Y. Used for corner corridors.
# ded - Three walls on +X, -X, and +Y. Used for dead end interior parts.

var limit = -1

var meshes_path = "res://Resources/3D/meshes/level_parts/"
var level_parts_path = "res://Scenes/level_parts/"

var subfolders = ["in", "ex", "p", "f"]

func _run():
	for file_name in DirAccess.get_files_at(meshes_path):
		if (file_name.get_extension() == "res"):
			#skins.append(load("res://assets/skins/"+file_name))
			print("---\nFound mesh "+file_name)
			create_level_part(load(meshes_path+file_name), file_name)
			limit -= 1
			if limit == 0:
				break


func get_destination_path(str: String):
	var ret = level_parts_path
	for prefix in subfolders:
		if str.substr(0,prefix.length()+1) == prefix + "_":
			ret += prefix + "/"
	return ret + str + ".tscn"

func get_collision_shape():
	pass

func create_level_part(mesh: Mesh, mesh_file_name: String):
	var extracted_name = mesh_file_name.substr(12, mesh_file_name.length()-16)
	var collision_type = extracted_name.substr(0, 3)
	extracted_name = extracted_name.substr(4)
	var save_path = get_destination_path(extracted_name)
	
	print(collision_type + " . " + extracted_name + " . " + save_path)
	#return
	
	var mesh_instance = MeshInstance3D.new()
	mesh_instance.name = extracted_name
	mesh_instance.mesh = mesh
		
	if collision_type != "ncl":
		var static_body_packed = load("res://Scenes/level_parts/collision_shapes/"+collision_type+".tscn")
		var static_body = static_body_packed.instantiate()
		mesh_instance.add_child(static_body)
		static_body.owner = mesh_instance
	
	save_packed_scene(mesh_instance, extracted_name, save_path)
	
func save_packed_scene(node: Node, name: String, path: String):
	print("Saving at " + path)
	var packed_scene = PackedScene.new()
	packed_scene.pack(node)
	packed_scene.resource_name = name
	ResourceSaver.save(packed_scene, path)
